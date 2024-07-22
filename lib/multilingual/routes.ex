defmodule Multilingual.Routes do
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
