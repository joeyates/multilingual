defmodule Multilingual.Routes do
  @doc """
  Creates metadata for multilingual routes.

  ## Examples

      iex> Multilingual.Routes.metadata("it")
      [metadata: %{multilingual: %{locale: "it"}}]
  """
  def metadata(locale) do
    [metadata: %{multilingual: %{locale: locale}}]
  end
end
