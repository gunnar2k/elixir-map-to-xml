defmodule MapToXmlTest do
  use ExUnit.Case

  describe "basic functionality" do
    test "one tag" do
      assert MapToXml.from_map(%{
               "Tag1" => "Value1"
             }) == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1>Value1</Tag1>"
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
  end

  describe "attribute support" do
    test "simple value" do
      assert MapToXml.from_map(%{
               "Tag1" => %{
                 "#content" => "some value",
                 "-id" => 123,
                 "-something" => "111"
               }
             }) ==
               "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1 id=\"123\" something=\"111\">some value</Tag1>"
    end

    test "nested map as value" do
      assert MapToXml.from_map(%{
               "Tag1" => %{
                 "#content" => %{
                   "Tag2" => %{
                     "Tag3" => "value"
                   }
                 },
                 "-id" => 123,
                 "-something" => "111"
               }
             }) ==
               "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1 id=\"123\" something=\"111\">\n  <Tag2>\n    <Tag3>value</Tag3>\n  </Tag2>\n</Tag1>"
    end

    test "nested maps with attributes" do
      assert MapToXml.from_map(%{
               "Tag1" => %{
                 "#content" => %{
                   "Tag2" => %{
                     "#content" => %{
                       "Tag3" => %{
                         "#content" => "final value",
                         "-id" => "1234",
                         "-something" => "value"
                       }
                     },
                     "-id" => "1234",
                     "-something" => "value"
                   }
                 },
                 "-id" => "1234",
                 "-something" => "value"
               }
             }) ==
               "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1 id=\"1234\" something=\"value\">\n  <Tag2 id=\"1234\" something=\"value\">\n    <Tag3 id=\"1234\" something=\"value\">final value</Tag3>\n  </Tag2>\n</Tag1>"
    end

    test "lists" do
      assert MapToXml.from_map(%{
               "Tag1" => %{
                 "#content" => [
                   "value1",
                   "value2"
                 ],
                 "-id" => "1234",
                 "-something" => "value"
               }
             }) ==
               "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Tag1 id=\"1234\" something=\"value\">value1</Tag1>\n<Tag1 id=\"1234\" something=\"value\">value2</Tag1>"
    end
  end
end
