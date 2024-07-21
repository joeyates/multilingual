defmodule Multilingual.Test.Project.Router do
  use Phoenix.Router

  import Multilingual.Routes, only: [metadata: 1]

  scope "/", Multilingual.Test.Project do
    get "/about", PageController, :about, metadata("en")
  end
end


