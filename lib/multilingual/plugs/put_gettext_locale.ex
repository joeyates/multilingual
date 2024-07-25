if Code.ensure_loaded?(Gettext) do
  defmodule Multilingual.Plugs.PutGettextLocale do
    alias Multilingual.View

    def init(_opts), do: nil

    def call(conn, _opts) do
      locale = View.fetch_key(conn, :locale)
      Gettext.put_locale(locale)
      conn
    end
  end
end
