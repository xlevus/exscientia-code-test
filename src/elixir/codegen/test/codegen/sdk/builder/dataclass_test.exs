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

  @nested_array_schema %{
    "properties" => %{
      "int_array" => %{
        "type" => "array",
        "items" => %{"type" => "integer"}
      },
      "obj_array" => %{
        "type" => "array",
        "properties" => %{"field" => %{}}
      }
    }
  }

  describe "build dataclass" do
    test "builds a dataclass" do
      {ctx, class} = Dataclass.build("Example", @schema)

      assert class.name == "Example"
      assert is_list(class.properties)
      assert class.docstring == @schema["description"]

      assert ctx == %{
               classes: [class],
               imports: ["typing"],
               root_schema: @schema
             }
    end

    test "builds nested dataclass" do
      {ctx, class} = Dataclass.build("NestedExample", @nested_array_schema)

      assert class.properties == [
               %Property{name: "int_array", py_type: "typing.List[int]"},
               %Property{name: "obj_array", py_type: "typing.List[ObjArray]"}
             ]

      assert length(ctx[:classes]) == 2
    end
  end

  describe "property extraction" do
    test "extract_properties returns" do
      {_, property} =
        Dataclass.process_property(
          %{},
          "field_name",
          %{"type" => "integer", "description" => "foo"}
        )

      assert property.name == "field_name"
      assert property.py_type == "int"
      assert property.docstring == "foo"
    end
  end

  describe "ctx merging" do
    test "empty ctx creates imports" do
      ctx = Dataclass.update_ctx(%{}, imports: ["foo"])
      assert ctx == %{imports: ["foo"]}
    end

    test "appends new imports" do
      ctx = Dataclass.update_ctx(%{imports: ["foo"]}, imports: ["bar"])
      assert ctx == %{imports: ["foo", "bar"]}
    end

    test "deduplicates new imports" do
      ctx = Dataclass.update_ctx(%{imports: ["foo"]}, imports: ["foo"])
      assert ctx == %{imports: ["foo"]}
    end
  end
end
