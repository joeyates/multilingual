defmodule Multilingual.PlugTest do
  use ExUnit.Case, async: true

  import Multilingual.Plug
  alias Multilingual.Test.Project.Router

  describe "init/1" do
    test "returns the default locale" do
      assert init(default_locale: "en") == %{default_locale: "en"}
    end

    test "raises an error when the default locale is not provided" do
      assert_raise FunctionClauseError, fn ->
        init(%{})
      end
    end
  end

  describe "call/2" do
    test "stores the current path as private data" do
      conn = %Plug.Conn{request_path: "/about", private: %{phoenix_router: Router}}

      conn = call(conn, %{default_locale: "cn"})

      assert conn.private.multilingual.path == "/about"
    end

    test "stores the locale as private data" do
      conn = %Plug.Conn{request_path: "/about", private: %{phoenix_router: Router}}

      conn = call(conn, %{default_locale: "cn"})

      assert conn.private.multilingual.locale == "en"
    end

    test "uses the default locale when the path does not have a locale" do
      conn = %Plug.Conn{request_path: "/some-page", private: %{phoenix_router: Router}}

      conn = call(conn, %{default_locale: "cn"})

      assert conn.private.multilingual.locale == "cn"
    end
  end
end
