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
    |> cast(attrs, [:schema, :data_uri, :version])
    |> validate_required([:schema, :data_uri, :version])
  end
end
