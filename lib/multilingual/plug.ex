defmodule Multilingual.Plug do
  import Plug.Conn
  alias Multilingual.Routes
  alias Multilingual.View

  def init(opts) do
    {default_locale, []} = Keyword.pop!(opts, :default_locale)

    %{default_locale: default_locale}
  end

  def call(conn, opts) do
    path = conn.request_path
    router = Phoenix.Controller.router_module(conn)
    locale = Routes.path_locale(router, path) || opts.default_locale
    put_private(conn, :multilingual, %View{path: path, locale: locale})
  end
end
