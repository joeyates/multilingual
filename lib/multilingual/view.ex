defmodule Multilingual.View do
  @attrs [:locale, :route]
  @enforce_keys @attrs
  defstruct @attrs

  @doc """
  Fetches a key from the private View data in the connection or socket.
  Returns nil if no view data is found.

  Raises an error if an erroneous key is requested.

  ## Examples

      iex> view = %Multilingual.View{locale: "en", route: "/about"}
      ...> conn = Plug.Conn.put_private(%Plug.Conn{}, :multilingual, view)
      ...> Multilingual.View.get_key(conn, :route)
      "/about"

      iex> view = %Multilingual.View{locale: "en", route: "/about"}
      ...> conn = Plug.Conn.put_private(%Plug.Conn{}, :multilingual, view)
      ...> Multilingual.View.get_key(conn, :bad_key)
      ** (FunctionClauseError) no function clause matching in Multilingual.View.get_key/2

      iex> Multilingual.View.get_key(%Plug.Conn{}, :route)
      nil

      iex> view = %Multilingual.View{locale: "en", route: "/about"}
      ...> socket = Phoenix.LiveView.put_private(%Phoenix.LiveView.Socket{}, :multilingual, view)
      ...> Multilingual.View.get_key(socket, :route)
      "/about"

      iex> view = %Multilingual.View{locale: "en", route: "/about"}
      ...> socket = Phoenix.LiveView.put_private(%Phoenix.LiveView.Socket{}, :multilingual, view)
      ...> Multilingual.View.get_key(socket, :bad_key)
      ** (FunctionClauseError) no function clause matching in Multilingual.View.get_key/2

      iex> Multilingual.View.get_key(%Phoenix.LiveView.Socket{}, :locale)
      nil
  """
  def get_key(%Plug.Conn{} = conn, key) when key in @attrs do
    case Map.get(conn.private, :multilingual) do
      nil -> nil
      view -> Map.get(view, key)
    end
  end

  if Code.ensure_loaded?(Phoenix.LiveView) do
    def get_key(%Phoenix.LiveView.Socket{} = socket, key) when key in @attrs do
      case Map.get(socket.private, :multilingual) do
        nil -> nil
        view -> Map.get(view, key)
      end
    end
  end

  @doc """
  Fetches a key from the private View data in the connection and raises
  an error is not view is found.

  ## Examples

      iex> view = %Multilingual.View{locale: "en", route: "/about"}
      ...> conn = Plug.Conn.put_private(%Plug.Conn{}, :multilingual, view)
      ...> Multilingual.View.fetch_key(conn, :route)
      "/about"

      iex> view = %Multilingual.View{locale: "en", route: "/about"}
      ...> conn = Plug.Conn.put_private(%Plug.Conn{}, :multilingual, view)
      ...> Multilingual.View.fetch_key(conn, :bad_key)
      ** (FunctionClauseError) no function clause matching in Multilingual.View.fetch_key/2

      iex> assert_raise Multilingual.MissingViewDataInConnError, fn ->
      ...>  Multilingual.View.fetch_key(%Plug.Conn{}, :locale)
      ...> end

      iex> view = %Multilingual.View{locale: "en", route: "/about"}
      ...> socket = Phoenix.LiveView.put_private(%Phoenix.LiveView.Socket{}, :multilingual, view)
      ...> Multilingual.View.fetch_key(socket, :route)
      "/about"

      iex> view = %Multilingual.View{locale: "en", route: "/about"}
      ...> socket = Phoenix.LiveView.put_private(%Phoenix.LiveView.Socket{}, :multilingual, view)
      ...> Multilingual.View.fetch_key(socket, :bad_key)
      ** (FunctionClauseError) no function clause matching in Multilingual.View.fetch_key/2

      iex> assert_raise Multilingual.MissingViewDataInSocketError, fn ->
      ...>  Multilingual.View.fetch_key(%Phoenix.LiveView.Socket{}, :locale)
      ...> end
  """
  def fetch_key(%Plug.Conn{} = conn, key) when key in @attrs do
    case conn.private[:multilingual] do
      %__MODULE{} = view ->
        Map.fetch!(view, key)

      nil ->
        raise Multilingual.MissingViewDataInConnError
    end
  end

  if Code.ensure_loaded?(Phoenix.LiveView) do
    def fetch_key(%Phoenix.LiveView.Socket{} = socket, key) when key in @attrs do
      case socket.private[:multilingual] do
        %__MODULE{} = view ->
          Map.fetch!(view, key)

        nil ->
          raise Multilingual.MissingViewDataInSocketError
      end
    end
  end
end
