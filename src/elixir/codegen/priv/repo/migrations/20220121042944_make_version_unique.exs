defmodule Codegen.Repo.Migrations.MakeVersionUnique do
  use Ecto.Migration

  def change do
    create(unique_index(:versions, [:version]))
  end
end
