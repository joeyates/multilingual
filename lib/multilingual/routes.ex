defmodule Multilingual.Routes do
  def localized_path(router, path, locale) do
    case localized_route(router, path, locale) do
      nil ->
        nil

      route ->
        route.path
    end
  end

  defp localized_route(router, path, locale) do
    with {:ok, route} <- find_path_route(router, path),
         {:ok, localized} <- find_localized_route(router, route, locale) do
      localized
    else
      _any ->
        nil
    end
  end

  defp find_localized_route(router, route, locale) do
    other =
      Phoenix.Router.routes(router)
      |> Enum.find(fn other ->
        case locale(other) do
          {:ok, ^locale} ->
            same_view(route, other)

          _any ->
            false
        end
      end)

    case other do
      nil -> {:error, :not_found}
      other -> {:ok, other}
    end
  end

  defp same_view(route_1, route_2) do
    with true <- route_1.verb == route_2.verb,
         true <- route_1.plug == route_2.plug,
         true <- route_1.plug_opts == route_2.plug_opts,
         true <- route_1.helper == route_2.helper do
      true
    else
      _any ->
        false
    end
  end

  @doc """
  Creates metadata for multilingual routes.

  ## Examples

      iex> Multilingual.Routes.metadata("it")
      [metadata: %{multilingual: %{locale: "it"}}]
  """
  def metadata(locale) do
    [metadata: %{multilingual: %{locale: locale}}]
  end

  @doc """
  Returns the locale from the metadata of the route which provides
  the requested path.
  """
  def path_locale(router, path) do
    with {:ok, route} <- find_path_route(router, path),
         {:ok, locale} <- locale(route) do
      locale
    else
      _error ->
        nil
    end
  end

  defp find_path_route(router, path) do
    route =
      router
      |> Phoenix.Router.routes()
      |> Enum.find(&(&1.path == path))

    if route do
      {:ok, route}
    else
      {:error, :not_found}
    end
  end

  defp locale(route) do
    case get_in(route, [:metadata, :multilingual, :locale]) do
      nil -> {:error, :no_locale}
      locale -> {:ok, locale}
    end
  end
end
