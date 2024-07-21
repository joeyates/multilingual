defmodule Multilingual.RoutesTest.PageController do
  use Phoenix.Controller
end

defmodule Multilingual.RoutesTest.Router do
  use Phoenix.Router

  import Multilingual.Routes, only: [metadata: 1]

  scope "/", Multilingual.RoutesTest do
    get "/about", PageController, :about, metadata("en")
  end
end

defmodule Multilingual.RoutesTest do
  use ExUnit.Case
  doctest Multilingual.Routes

  import Multilingual.Routes
  alias Multilingual.RoutesTest.Router

  describe "path_locale/2" do
    test "returns a path's locale" do
      assert path_locale(Router, "/about") == "en"
    end

    test "returns nil when the path is not found" do
      assert path_locale(Router, "/doesnt_exist") == nil
    end
  end
end
