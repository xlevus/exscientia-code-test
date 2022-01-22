defmodule Codegen.SDK.Builder.DataclassTest do
  use ExUnit.Case

  alias Codegen.SDK.Builder.Dataclass

  @schema %{
    "description" => "An example schema.",
    "properties" => %{
      "an_int" => %{"type" => "integer"},
      "a_string" => %{"type" => "string"}
    }
  }

  describe "build dataclass" do
    test "builds a dataclass" do
      {class, context} = Dataclass.build("Example", @schema)

      assert class.name == "Example"
      assert is_list(class.properties)
      assert class.docstring == @schema["description"]

      assert context == %{
               classes: [class],
               root_schema: @schema
             }
    end
  end

  describe "property extraction" do
    test "extract_properties returns tuples" do
      {property, _} =
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
      ctx = Dataclass.update_context(%{}, imports: ["foo"])
      assert ctx == %{imports: ["foo"]}
    end

    test "appends new imports" do
      ctx = Dataclass.update_context(%{imports: ["foo"]}, imports: ["bar"])
      assert ctx == %{imports: ["foo", "bar"]}
    end

    test "deduplicates new imports" do
      ctx = Dataclass.update_context(%{imports: ["foo"]}, imports: ["foo"])
      assert ctx == %{imports: ["foo"]}
    end
  end
end
