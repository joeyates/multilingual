if Code.ensure_loaded?(Phoenix.Component) do
  defmodule Multilingual.HTML do
    import Multilingual.Components
    alias Multilingual.Routes
    alias Multilingual.View

    @doc """
    Builds a list of data for rel links for the document head.
    """
    def get_rel_links(%Plug.Conn{} = conn) do
      router = Phoenix.Controller.router_module(conn)
      path = View.fetch_key(conn, :path)
      locale = View.fetch_key(conn, :locale)

      case Routes.build_page_mapping(router, path) do
        {:ok, mapping} ->
          rels = build_rels(conn, locale, mapping)
          rel_links(%{rels: rels})

        _ ->
          ""
      end
    end

    defp build_rels(conn, page_locale, mapping) do
      mapping
      |> Enum.map(fn {locale, path} ->
        url = Phoenix.VerifiedRoutes.unverified_url(conn, path)

        if locale == page_locale do
          {"canonical", nil, url}
        else
          {"alternate", locale, url}
        end
      end)
    end
  end
end