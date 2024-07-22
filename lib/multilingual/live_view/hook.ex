if Code.ensure_loaded?(Phoenix.LiveView) do
  defmodule Multilingual.LiveView.Hook do
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
