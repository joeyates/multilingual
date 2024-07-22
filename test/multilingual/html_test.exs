defmodule Multilingual.HTMLTest do
  use ExUnit.Case

  import Multilingual.HTML
  alias Multilingual.Test.Project.Router

  describe "get_rel_links/1" do
    test "returns rel links based on the router" do
      conn =
        Phoenix.ConnTest.build_conn()
        |> Map.put(:router, Router)
        |> Plug.Conn.put_private(:phoenix_router, Router)
        |> Plug.Conn.put_private(:phoenix_router_url, "http://example.com")
        |> Plug.Conn.put_private(:multilingual, %Multilingual.View{path: "/about", locale: "en"})

      result =
        get_rel_links(conn)
        |> Phoenix.HTML.Safe.to_iodata()
        |> to_string()

      expected = "\n  \n    <link rel=\"canonical\" href=\"http://example.com/about\">\n  \n\n  \n    <link rel=\"alternate\" hreflang=\"it\" href=\"http://example.com/it/chi-siamo\">\n  \n"

      assert result == expected
    end
  end
end

