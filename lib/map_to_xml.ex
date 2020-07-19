defmodule MapToXml do
  @moduledoc """
  Documentation for `MapToXml`.
  """
  import XmlBuilder

  @doc """
  Convert a map to an XML document.

  ## Examples

  ### Basic example

  ```elixir
  MapToXml.from_map(%{
    "tag1" => "value1",
    "tag2" => "value2",
    "tag3" => "value3"
  })
  ```

  will output:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <tag1>value1</tag1>
  <tag2>value2</tag2>
  <tag3>value3</tag3>
  ```

  ### Nested maps

  ```elixir
  MapToXml.from_map(%{
    "tag1" => %{
      "tag2" => %{
        "tag3" => "value"
      }
    }
  })
  ```

  will output:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <tag1>
    <tag2>
      <tag3>value</tag3>
    </tag2>
  </tag1>
  ```

  ### Repeated child tags

  ```elixir
  MapToXml.from_map(%{
    "Tags" => %{
      "Tag1" => [
        %{"Sub1" => "Val1"},
        %{"Sub1" => "Val2"},
        %{"Sub1" => "Val3"}
      ]
    }
  })
  ```

  will output:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <Tags>
    <Tag1>
      <Sub1>Val1</Sub1>
    </Tag1>
    <Tag1>
      <Sub1>Val2</Sub1>
    </Tag1>
    <Tag1>
      <Sub1>Val3</Sub1>
    </Tag1>
  </Tags>
  ```

  ### Attributes

  ```elixir
  MapToXml.from_map(%{
    "Tag1" => %{
      "#content" => "some value",
      "-id" => 123,
      "-something" => "111"
    }
  })
  ```

  will output:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <Tag1 id="123" something="111">some value</Tag1>
  ```
  """
  @spec from_map(map) :: binary
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
