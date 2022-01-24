defmodule Codegen.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add(:name, :string)
      add(:schema, :map)
      add(:uri, :string)
      add(:schema_uri, :string)
      add(:library, references(:libraries, on_delete: :nothing))

      timestamps()
    end

    create(index(:resources, [:library]))
  end
end
