defmodule Codegen.SDK.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resources" do
    field(:name, :string)
    field(:schema, :map)
    field(:uri, :string)
    field(:library, :id)

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:name, :schema, :uri])
    |> validate_required([:name, :schema, :uri])
  end
end
