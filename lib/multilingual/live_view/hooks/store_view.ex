if Code.ensure_loaded?(Phoenix.LiveView) do
  defmodule Multilingual.Hooks.StoreView do
    @moduledoc """
    Store the view information in the LiveView socket's private data.

    This hook **must** be registered for each LiveView in order
    to enable all other Multilingual features in Phoenix live views.

    ## Example

        defmodule MyAppWeb.HomeLive do
          use MyAppWeb, :live_view

          alias Multilingual.Hooks.StoreView

          on_mount {StoreView, default_locale: "en"}
        end
    """

    import Phoenix.LiveView
    alias Multilingual.Routes
    alias Multilingual.View

    def on_mount([default_locale: default_locale], _params, _session, socket) do
      socket =
        socket
        |> attach_hook(:multilingual_store_view, :handle_params, fn _params, uri, socket ->
          uri = URI.parse(uri)
          locale = Routes.path_locale(socket.router, uri.path) || default_locale
          view = %View{route: uri.path, locale: locale}
          socket = put_private(socket, :multilingual, view)
          {:cont, socket}
        end)

      {:cont, socket}
    end
  end
end
