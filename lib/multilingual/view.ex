defmodule Multilingual.View do
  @attrs [:locale, :path]
  @enforce_keys @attrs
  defstruct @attrs

  @doc """
  Fetches a key from the private View data in the connection or returns nil
  if the view is not found.
  Raise an error if an erroneous key is requested.

  ## Examples

    iex> view = %Multilingual.View{locale: "en", path: "/about"}
    ...> conn = Plug.Conn.put_private(%Plug.Conn{}, :multilingual, view)
    ...> Multilingual.View.get_key(conn, :path)
    "/about"

    iex> Multilingual.View.get_key(%Plug.Conn{}, :path)
    nil

    iex> view = %Multilingual.View{locale: "en", path: "/about"}
    ...> conn = Plug.Conn.put_private(%Plug.Conn{}, :multilingual, view)
    ...> Multilingual.View.get_key(conn, :bad_key)
    ** (FunctionClauseError) no function clause matching in Multilingual.View.get_key/2
  """
  def get_key(%Plug.Conn{} = conn, key) when key in @attrs do
    case Map.get(conn.private, :multilingual) do
      nil -> nil
      view -> Map.get(view, key)
    end
  end

  @doc """
  Fetches a key from the private View data in the connection and raises
  an error is not view is found.

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
