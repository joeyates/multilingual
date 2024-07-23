defmodule Multilingual.MissingViewDataInConnError do
  defexception []

  def message(_exception) do
    ~S"""
    The connection does not have the expected view data.

    Ensure that you have the Multilingual.StoreView plug in your router.

    ## Example

      defmodule MyAppWeb.Router do
        use MyAppWeb, :router

        alias Multilingual.StoreView

        pipeline :browser do
          ...
          plug StoreView, default_locale: "en"
        end
      end
    """
  end
end

defmodule Multilingual.MissingViewDataInSocketError do
  defexception []

  def message(_exception) do
    ~S"""
    The socket does not have the expected view data.

    Ensure that you have the Multilingual.LiveView.Hook in your LiveView.

    ## Example

        defmodule MyAppWeb.HomeLive do
          use MyAppWeb, :live_view

          on_mount {Multilingual.LiveView.Hook, default_locale: "en"}
        end
    """
  end
end
