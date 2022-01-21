defmodule Codegen.SDK.Version do
  use Ecto.Schema
  import Ecto.Changeset

  schema "versions" do
    field(:version, :string)
    field(:data_uri, :string)
    field(:schema, :map)
    field(:library, :id)

    timestamps()
  end

  @doc false
  def changeset(version, attrs) do
    version
    |> cast(attrs, [:schema, :data_uri, :version, :library])
    |> validate_required([:schema, :data_uri, :version, :library])
    |> unique_constraint(:version)
  end
end
