defmodule Multilingual.Test.Project.Router do
  use Phoenix.Router
  import Phoenix.LiveView.Router

  import Multilingual.Routes, only: [metadata: 1]

  scope "/", Multilingual.Test.Project do
    # A simple route for a Phoenix view
    get "/about", PageController, :about, metadata("en")
    get "/it/chi-siamo", PageController, :about, metadata("it")

    # A route with a parameter
    get "/contacts/:name", PageController, :contact, metadata("en")
    get "/it/contatti/:name", PageController, :contact, metadata("it")

    get "/monolingual", PageController, :monolingual

    live "/live/about", AboutLive, :index, metadata("en")
    live "/it/live/chi-siamo", AboutLive, :index, metadata("it")

    live "/live/contacts/:name", ContactsLive, :index, metadata("en")
    live "/it/live/contatti/:name", ContactsLive, :index, metadata("it")
  end
end
