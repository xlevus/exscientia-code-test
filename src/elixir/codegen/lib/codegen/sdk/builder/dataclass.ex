defmodule Property do
  defstruct name: "", py_type: "", docstring: nil
end

defmodule Klass do
  defstruct name: "", properties: [], docstring: nil
end

defmodule Codegen.SDK.Builder.Dataclass do
  def build(name, schema, ctx \\ %{}) do
    property_spec =
      schema
      |> Map.get("properties", [])
      |> Map.to_list()

    {ctx, properties} =
      ctx
      |> Map.put_new(:root_schema, schema)
      |> extract_properties(property_spec, [])

    klass = %Klass{
      name: name,
      properties: properties,
      docstring: Map.get(schema, "description")
    }

    {update_ctx(ctx, classes: [klass]), klass}
  end

  def extract_properties(ctx, [], properties) do
    {ctx, properties}
  end

  def extract_properties(ctx, [{name, spec} | remaining], properties) do
    {ctx, property} = process_property(ctx, name, spec)

    extract_properties(ctx, remaining, properties ++ [property])
  end

  def process_property(ctx, name, spec) do
    # Bodge, but don't want to pass around yet another var
    spec = Map.put(spec, :name, name)

    {ctx, type} = py_type(ctx, Map.get(spec, "type"), spec)

    {
      ctx,
      %Property{
        name: name,
        py_type: type,
        docstring: Map.get(spec, "description")
      }
    }
  end

  def py_type(ctx, "integer", _), do: {ctx, "int"}

  def py_type(ctx, "number", _),
    do: {update_ctx(ctx, imports: ["typing"]), "typing.Union[int, float]"}

  def py_type(ctx, "string", _), do: {update_ctx(ctx, imports: ["typing"]), "typing.AnyStr"}

  def py_type(ctx, "array", spec) do
    {ctx, subtype} =
      cond do
        Map.has_key?(spec, "items") -> py_type(ctx, ["array", :items], spec["items"])
        Map.has_key?(spec, "properties") -> py_type(ctx, ["array", :properties], spec)
        true -> py_type(ctx, nil, nil)
      end

    {ctx, ~s|typing.List[#{subtype}]|}
  end

  def py_type(ctx, ["array", :items], spec) do
    py_type(ctx, Map.get(spec, "type"), spec)
  end

  def py_type(ctx, ["array", :properties], spec) do
    # This should probably assert it's unique
    name = Macro.camelize(spec[:name])

    {ctx, klass} = build(name, spec, ctx)
    {ctx, name}
  end

  def py_type(ctx, _, _), do: {update_ctx(ctx, imports: ["typing"]), "typing.Any"}

  def update_ctx(ctx, []) do
    ctx
  end

  def update_ctx(ctx, [{ctx_field, field_change} | remaining]) do
    ctx
    |> update_ctx_field(ctx_field, field_change)
    |> update_ctx(remaining)
  end

  defp update_ctx_field(ctx, :imports, changes) do
    Map.update(ctx, :imports, changes, fn val ->
      Enum.uniq(val ++ changes)
    end)
  end

  defp update_ctx_field(ctx, :classes, changes) do
    Map.update(ctx, :classes, changes, fn val ->
      val ++ changes
    end)
  end
end
