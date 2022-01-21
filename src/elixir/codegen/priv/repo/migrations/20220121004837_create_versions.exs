defmodule Codegen.Repo.Migrations.CreateVersions do
  use Ecto.Migration

  def change do
    create table(:versions) do
      add(:version, :string)
      add(:schema, :map)
      add(:data_uri, :string)
      add(:library, references(:libraries, on_delete: :delete_all))

      timestamps()
    end

    create(index(:versions, [:library]))
  end
end
