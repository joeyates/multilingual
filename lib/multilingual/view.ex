defmodule Multilingual.View do
  @attrs [:locale, :path]
  @enforce_keys @attrs
  defstruct @attrs

  @doc """
  Fetches a key from the private View data in the connection.

  ## Examples

    iex> view = %Multilingual.View{locale: "en", path: "/about"}
    ...> conn = Plug.Conn.put_private(%Plug.Conn{}, :multilingual, view)
    ...> Multilingual.View.fetch_key(conn, :path)
    "/about"

    iex> view = %Multilingual.View{locale: "en", path: "/about"}
    ...> conn = Plug.Conn.put_private(%Plug.Conn{}, :multilingual, view)
    ...> Multilingual.View.fetch_key(conn, :bad_key)
    ** (FunctionClauseError) no function clause matching in Multilingual.View.fetch_key/2
  """
  def fetch_key(%Plug.Conn{} = conn, key) when key in @attrs do
    Map.fetch!(conn.private.multilingual, key)
  end
end
