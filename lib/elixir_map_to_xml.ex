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

  defp build_tag(key, value, attributes \\ %{})

  defp build_tag(key, %{} = map, attributes) do
    keys = Map.keys(map)

    if Enum.member?(keys, "#content") do
      attributes =
        for key <- keys, String.slice(key, 0, 1) == "-", into: %{} do
          {String.slice(key, 1..-1), map[key]}
        end

      build_tag(key, map["#content"], attributes)
    else
      tags =
        for key <- keys do
          build_tag(key, map[key])
        end

      element(key, attributes, tags)
    end
  end

  defp build_tag(key, [_ | _] = values, attributes) do
    for value <- values, do: build_tag(key, value, attributes)
  end

  defp build_tag(key, value, attributes) do
    element(key, attributes, "#{value}")
  end
end
