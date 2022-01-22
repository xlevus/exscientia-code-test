defmodule Property do
  defstruct name: "", py_type: "", docstring: nil
end

defmodule Klass do
  defstruct name: "", properties: [], docstring: nil
end

defmodule Codegen.SDK.Builder.Dataclass do
  def build(name, schema, context \\ %{}) do
    {properties, context} = extract_properties(schema, context)

    klass = %Klass{
      name: name,
      properties: properties,
      docstring: Map.get(schema, "description")
    }

    {klass, merge_context(context, %{classes: [klass]})}
  end

  def extract_properties(schema, context) do
    {for {name, spec} <- schema["properties"] do
       {property, context} = process_property(name, spec, context)
       property
     end, context}
  end

  def process_property(name, spec, context) do
    {type, ctx_updates} = py_type(Map.get(spec, "type"), spec, context)
    context = merge_context(context, ctx_updates)

    {
      %Property{
        name: name,
        py_type: type,
        docstring: Map.get(spec, "description")
      },
      context
    }
  end

  def py_type("integer", _, _), do: {"int", nil}

  def py_type("number", _, _),
    do: {"typing.Union[int, float, decimal.Decimal]", %{imports: ["typing", "decimal"]}}

  def py_type("string", _, _), do: {"typing.AnyStr", %{imports: ["typing"]}}

  def py_type(_, _, _), do: {"typing.Any", %{imports: ["typing"]}}

  def merge_context(context, nil) do
    context
  end

  def merge_context(context, updates) do
    Enum.reduce(
      updates,
      context,
      fn {key, changes}, ctx -> merge_context_field(key, ctx, changes) end
    )
  end

  defp merge_context_field(:imports, context, changes) do
    Map.update(context, :imports, changes, fn val ->
      Enum.uniq(val ++ changes)
    end)
  end

  defp merge_context_field(:classes, context, changes) do
    Map.update(context, :classes, changes, fn val ->
      val ++ changes
    end)
  end
end
