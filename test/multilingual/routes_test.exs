defmodule Multilingual.RoutesTest do
  use ExUnit.Case
  doctest Multilingual.Routes

  import Multilingual.Routes
  alias Multilingual.Test.Project.Router

  describe "build_page_mapping/2" do
    test "returns a mapping of locales to paths for the current page" do
      assert build_page_mapping(Router, "/about") ==
               {:ok, %{"en" => "/about", "it" => "/it/chi-siamo"}}
    end

    test "returns an error tuple when the path doesn't exist" do
      assert build_page_mapping(Router, "/doesnt_exist") == {:error, :not_found}
    end

    test "returns an error tuple when the path is not localized" do
      assert build_page_mapping(Router, "/monolingual") == {:error, :not_localized}
    end
  end

  describe "localized_path/3" do
    test "returns the localized path" do
      assert localized_path(Router, "/about", "it") == "/it/chi-siamo"
    end

    test "returns an error tuple when the path doesn't exist" do
      assert localized_path(Router, "/doesnt_exist", "it") == nil
    end

    test "returns an error tuple when the path is not localized" do
      assert localized_path(Router, "/monolingual", "it") == nil
    end

    test "returns an error tuple when the path is not localized for the requested locale" do
      assert localized_path(Router, "/about", "fr") == nil
    end
  end

  describe "path_locale/2" do
    test "returns a path's locale" do
      assert path_locale(Router, "/about") == "en"
    end

    test "returns nil when the path is not found" do
      assert path_locale(Router, "/doesnt_exist") == nil
    end
  end
end
