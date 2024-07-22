defmodule Multilingual.Routes do
  @doc """
  Builds a mapping of locales to paths for the current page.

  ## Examples

  In the router:

    scope "/", MyAppWeb do
      get "/about", PageController, :index, metadata("en")
      get "/it/chi-siamo", PageController, :index, metadata("it")
    end

    iex> Multilingual.Routes.build_page_mapping(MyAppWeb.Router, "/about")
    {:ok, %{"en" => "/about", "it" => "/it/chi-siamo"}}

  The result can be used to create a language switcher in the view.

    <% locales = ["en", "it"] %>
    <% locale = Multilingual.View.fetch_key(@conn, :locale) %>
    <% path = Multilingual.View.fetch_key(@conn, :path) %>
    <% {:ok, mapping} = Multilingual.Routes.build_page_mapping(@conn, path) %>
    <nav>
      <ul>
        <%= for lcl <- locales do %>
          <%= if lcl == locale do %>
            <li><%= lcl %></li>
          <% else %>
            <%= if mapping[lcl] do %>
              <li><a href={mapping[lcl]}><%= lcl %></a></li>
            <% end %>
          <% end %>
        <% end %>
      </ul>
    </nav>
  """
  def build_page_mapping(router, path) do
    with {:ok, current_route} <- find_path_route(router, path),
         :ok <- is_localized?(current_route) do
      build_route_mapping(router, current_route)
      |> then(&{:ok, &1})
    else
      error ->
        error
    end
  end

  defp is_localized?(route) do
    case route.metadata do
      %{multilingual: _multilingual} -> :ok
      _any -> {:error, :not_localized}
    end
  end

  defp build_route_mapping(router, route) do
    Phoenix.Router.routes(router)
    |> Enum.reduce(
      %{},
      fn other, mapping ->
        with :get <- other.verb,
             true <- same_view(route, other),
             %{multilingual: multilingual} <- other.metadata do
          Map.put(mapping, multilingual.locale, other.path)
        else
          _any ->
            mapping
        end
      end
    )
  end

  @doc """
  Returns the equivalent localized path for the given path and locale.

  If the path is not found, it returns `nil`.

  ## Examples

    In the router:
      scope "/", MyAppWeb do
        get "/about", PageController, :index, metadata("en")
        get "/it/chi-siamo", PageController, :index, metadata("it")
      end

    iex> Multilingual.Routes.localized_path(MyAppWeb.Router, "/about", "it")
    "/it/chi-siamo"
  """
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

  def locale(route) do
    case get_in(route, [:metadata, :multilingual, :locale]) do
      nil -> {:error, :no_locale}
      locale -> {:ok, locale}
    end
  end
end
