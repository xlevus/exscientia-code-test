defmodule Codegen.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries) do
      add(:name, :string)
      add(:description, :string)

      timestamps()
    end
  end
end
