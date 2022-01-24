defmodule Codegen.SDK.Builder.RenderTest do
  use ExUnit.Case

  alias Codegen.SDK.Builder.Render
  alias Codegen.SDK.Builder.Dataclass

  @schema %{
    "description" => "Fishsticks.",
    "properties" => %{
      "an_int" => %{
        "type" => "integer"
      },
      "obj_array" => %{
        "type" => "array",
        "properties" => %{"field" => %{}}
      }
    }
  }

  describe "render context" do
    test "renders imports" do
      {context, _} = Dataclass.build("TestData", @schema)

      code = Render.render(context)

      assert String.contains?(code, "import typing")
      assert String.contains?(code, "class TestData:")
      assert String.contains?(code, "    an_int: int")
    end
  end
end
