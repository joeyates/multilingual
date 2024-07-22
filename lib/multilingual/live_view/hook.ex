if Code.ensure_loaded?(Phoenix.LiveView) do
  defmodule Multilingual.LiveView.Hook do
    @moduledoc """
    Store the view information in the LiveView socket's private data.

    This hook **must** registered in for each LiveView in order
    to enable all other Multilingual features in Phoenix live views.

    ## Example

        defmodule MyAppWeb.HomeLive do
          use MyAppWeb, :live_view

          @impl true
          def mount(params, session, socket) do
            ...
          end

          on_mount {Multilingual.LiveView.Hook, default_locale: "en"}
        end
    """

    import Phoenix.LiveView
    alias Multilingual.Routes
    alias Multilingual.View

    def on_mount([default_locale: default_locale], _params, _session, socket) do
      socket =
        socket
        |> attach_hook(:multilingual, :handle_params, fn _params, uri, socket ->
          uri = URI.parse(uri)
          locale = Routes.path_locale(socket.router, uri.path) || default_locale
          view = %View{path: uri.path, locale: locale}
          socket = put_private(socket, :multilingual, view)
          {:cont, socket}
        end)

      {:cont, socket}
    end
  end
end
