defmodule Multilingual.MixProject do
  use Mix.Project

  def project do
    [
      app: :multilingual,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/project"]
  defp elixirc_paths(_env), do: ["lib"]

  defp deps do
    [
      {:ex_cldr, ">= 2.39.2"},
      {:jason, ">= 1.4.1"},
      {:phoenix, ">= 1.7.10"},
      {:phoenix_live_view, ">= 0.20.1", optional: true}
    ]
  end
end
