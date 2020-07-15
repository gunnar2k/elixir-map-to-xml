defmodule MapToXmlTest do
  use ExUnit.Case

  test "one tag" do
    assert MapToXml.from_map(%{
             "Tag1" => "Value1"
           }) == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1>Value1</Tag1>"
  end

  test "numeric values" do
    assert MapToXml.from_map(%{
             "Tag1" => 1234,
             "Tag2" => 12.15
           }) ==
             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1>1234</Tag1>\n<Tag2>12.15</Tag2>"
  end

  test "boolean values" do
    assert MapToXml.from_map(%{
             "Tag1" => true,
             "Tag2" => false
           }) ==
             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1>true</Tag1>\n<Tag2>false</Tag2>"
  end

  test "multiple tags" do
    assert MapToXml.from_map(%{
             "Tag1" => "Value1",
             "Tag2" => "Value2",
             "Tag3" => "Value3"
           }) ==
             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1>Value1</Tag1>\n<Tag2>Value2</Tag2>\n<Tag3>Value3</Tag3>"
  end

  test "nested maps becomes nested tags" do
    assert MapToXml.from_map(%{
             "Tag1" => %{
               "Tag2" => %{
                 "Tag3" => "Value"
               }
             }
           }) ==
             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1>\n  <Tag2>\n    <Tag3>Value</Tag3>\n  </Tag2>\n</Tag1>"
  end

  test "maps with lists become repeated child tags" do
    assert MapToXml.from_map(%{
             "Tags" => %{
               "Tag1" => [
                 %{"Sub1" => "Val1"},
                 %{"Sub1" => "Val2"},
                 %{"Sub1" => "Val3"}
               ]
             }
           }) ==
             "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tags>\n  <Tag1>\n    <Sub1>Val1</Sub1>\n  </Tag1>\n  <Tag1>\n    <Sub1>Val2</Sub1>\n  </Tag1>\n  <Tag1>\n    <Sub1>Val3</Sub1>\n  </Tag1>\n</Tags>"
  end
end
