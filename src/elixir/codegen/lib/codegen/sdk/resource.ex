defmodule Codegen.SDK.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resources" do
    field(:name, :string)
    field(:schema, :map)
    field(:uri, :string)
    field(:schema_uri, :string)
    field(:library, :id)

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:name, :schema, :uri, :schema_uri])
    |> validate_required([:name, :schema, :uri, :schema_uri])
  end
end
