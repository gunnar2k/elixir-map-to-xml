defmodule MapToXml do
  @moduledoc """
  Documentation for `MapToXml`.
  """
  import XmlBuilder

  @doc """
  Convert a map to XML document.
  """
  def from_map(%{} = map) do
    map
    |> Map.keys()
    |> Enum.map(fn key ->
      build_tag(key, map[key])
    end)
    |> document()
    |> generate()
  end

  defp build_tag(key, %{} = value) do
    sub_keys = Map.keys(value)

    sub_elements =
      for sub_key <- sub_keys do
        build_tag(sub_key, value[sub_key])
      end

    element(key, sub_elements)
  end

  defp build_tag(key, [_ | _] = values) do
    for value <- values, do: build_tag(key, value)
  end

  defp build_tag(key, value) do
    element(key, "#{value}")
  end
end
