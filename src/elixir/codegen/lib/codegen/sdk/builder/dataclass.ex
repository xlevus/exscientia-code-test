defmodule Property do
  defstruct name: "", py_type: "", docstring: nil
end

defmodule Klass do
  defstruct name: "", properties: [], docstring: nil
end

defmodule Codegen.SDK.Builder.Dataclass do
  def build(name, schema, context \\ %{}) do
    property_spec =
      schema
      |> Map.get("properties", [])
      |> Map.to_list()

    {properties, context} =
      context
      |> Map.put_new(:root_schema, schema)
      |> extract_properties(property_spec)

    klass = %Klass{
      name: name,
      properties: properties,
      docstring: Map.get(schema, "description")
    }

    {klass, update_context(context, classes: [klass])}
  end

  def extract_properties(context, properties) do
    {for {name, spec} <- properties do
       {property, context} = process_property(name, spec, context)
       property
     end, context}
  end

  def process_property(name, spec, context) do
    [type | ctx_updates] = py_type(Map.get(spec, "type"), spec, context)
    context = update_context(context, ctx_updates)

    {
      %Property{
        name: name,
        py_type: type,
        docstring: Map.get(spec, "description")
      },
      context
    }
  end

  def py_type("integer", _, _), do: ["int"]

  def py_type("number", _, _),
    do: ["typing.Union[int, float, decimal.Decimal]", imports: ["typing", "decimal"]]

  def py_type("string", _, _), do: ["typing.AnyStr", imports: ["typing"]]

  def py_type(_, _, _), do: ["typing.Any", imports: ["typing"]]

  def update_context(context, []) do
    context
  end

  def update_context(context, [{ctx_field, field_change} | remaining]) do
    context
    |> update_context_field(ctx_field, field_change)
    |> update_context(remaining)
  end

  defp update_context_field(context, :imports, changes) do
    Map.update(context, :imports, changes, fn val ->
      Enum.uniq(val ++ changes)
    end)
  end

  defp update_context_field(context, :classes, changes) do
    Map.update(context, :classes, changes, fn val ->
      val ++ changes
    end)
  end
end
