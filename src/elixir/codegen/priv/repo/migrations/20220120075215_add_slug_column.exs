defmodule Codegen.Repo.Migrations.AddSlugColumn do
  use Ecto.Migration

  def change do
    alter table("libraries") do
      add(:slug, :text)
    end

    create(unique_index(:libraries, [:slug]))
  end
end
