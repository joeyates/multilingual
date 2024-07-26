defmodule Multilingual.Test.Project.Router do
  use Phoenix.Router

  import Multilingual.Routes, only: [metadata: 1]

  scope "/", Multilingual.Test.Project do
    # A simple route for a Phoenix view
    get "/about", PageController, :about, metadata("en")
    get "/it/chi-siamo", PageController, :about, metadata("it")

    # A route with a parameter
    get "/contacts/:name", PageController, :contact, metadata("en")
    get "/it/contatti/:name", PageController, :contact, metadata("it")

    get "/monolingual", PageController, :monolingual
  end
end
