defmodule Codegen.SDK.Library do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libraries" do
    field(:description, :string)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
