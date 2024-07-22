defmodule Multilingual.Test.Project.Router do
  use Phoenix.Router

  import Multilingual.Routes, only: [metadata: 1]

  scope "/", Multilingual.Test.Project do
    get("/about", PageController, :about, metadata("en"))

    get("/monolingual", PageController, :monolingual)
  end

  scope "/it", Multilingual.Test.Project do
    get("/chi-siamo", PageController, :about, metadata("it"))
  end
end
