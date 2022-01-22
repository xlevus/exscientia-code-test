defmodule Codegen.SDK.Builder.DataclassTest do
  use ExUnit.Case

  alias Codegen.SDK.Builder.Dataclass

  describe "build dataclass" do
    test "builds a dataclass" do
      {class, context} =
        Dataclass.build("Foo", %{
          "description" => "A Foo.",
          "properties" => %{
            "foo" => %{"type" => "integer"},
            "bar" => %{}
          }
        })

      assert class.name == "Foo"
      assert is_list(class.properties)
      assert class.docstring == "A Foo."

      assert context == %{
               classes: [class]
               # imports: ["typing"]
             }
    end
  end

  describe "property extraction" do
    test "extract_properties returns tuples" do
      {property, context} =
        Dataclass.process_property(
          "field_name",
          %{"type" => "integer", "description" => "foo"},
          %{}
        )

      assert property.name == "field_name"
      assert property.py_type == "int"
      assert property.docstring == "foo"
    end
  end

  describe "context merging" do
    test "empty context creates imports" do
      ctx = Dataclass.merge_context(%{}, %{imports: ["foo"]})
      assert ctx == %{imports: ["foo"]}
    end

    test "appends new imports" do
      ctx = Dataclass.merge_context(%{imports: ["foo"]}, %{imports: ["bar"]})
      assert ctx == %{imports: ["foo", "bar"]}
    end

    test "deduplicates new imports" do
      ctx = Dataclass.merge_context(%{imports: ["foo"]}, %{imports: ["foo"]})
      assert ctx == %{imports: ["foo"]}
    end
  end
end
