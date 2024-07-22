defmodule Multilingual.StoreView do
  @moduledoc """
  Store the view information in the connection's private data.

  This plug **must** be used in the router pipeline in order
  to enable all other Multilingual features in Phoenix views.

  ## Example

    defmodule MyAppWeb.Router do
      use MyAppWeb, :router

      alias Multilingual.StoreView

      pipeline :browser do
        ...
        plug StoreView, default_locale: "en"
      end
    end
  """
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
