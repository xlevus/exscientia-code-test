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

    {context, properties} =
      context
      |> Map.put_new(:root_schema, schema)
      |> extract_properties(property_spec, [])

    klass = %Klass{
      name: name,
      properties: properties,
      docstring: Map.get(schema, "description")
    }

    {klass, update_context(context, classes: [klass])}
  end

  def extract_properties(context, [], properties) do
    {context, properties}
  end

  def extract_properties(context, [{name, spec} | remaining], properties) do
    {context, property} = process_property(context, name, spec)

    extract_properties(context, remaining, properties ++ [property])
  end

  def process_property(context, name, spec) do
    [type | ctx_updates] = py_type(Map.get(spec, "type"), spec)
    context = update_context(context, ctx_updates)

    {
      context,
      %Property{
        name: name,
        py_type: type,
        docstring: Map.get(spec, "description")
      }
    }
  end

  def py_type("integer", _), do: ["int"]

  def py_type("number", _),
    do: {"typing.Union[int, float, decimal.Decimal]", imports: ["typing", "decimal"]}

  def py_type("string", _), do: ["typing.AnyStr", imports: ["typing"]]

  def py_type("array", spec) do
    [subtype | changes] =
      cond do
        Map.has_key?(spec, "items") -> py_type(["array", :items], spec)
        Map.has_key?(spec, "properties") -> py_type(["array", :properties], spec)
        true -> py_type(nil, nil)
      end

    [~s|typing.List[#{subtype}]|] ++ changes
  end

  def py_type(["array", :properties], spec) do
    ["Foo"]
  end

  def py_type(_, _), do: ["typing.Any", imports: ["typing"]]

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
