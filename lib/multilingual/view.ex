defmodule Multilingual.View do
  @enforce_keys [:locale, :path]
  defstruct [:locale, :path]
end
