defmodule Codegen.SDK.Library do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libraries" do
    field(:description, :string)
    field(:name, :string)
    field(:slug, :string)

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:name, :slug, :description])
    |> set_slug(library)
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
    |> validate_camelcase(:name)
  end

  defp validate_camelcase(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, text ->
      case Macro.camelize(text) == text && !String.contains?(text, " ") do
        true -> []
        false -> [{field, "Must be in CamelCase format"}]
      end
    end)
  end

  defp slugify(string) do
    if string do
      String.downcase(Regex.replace(~r/[^A-Za-z0-9-]/, string, "-"))
    end
  end

  defp set_slug(changeset, library) do
    slug = get_change(changeset, :slug)

    slug =
      if is_nil(slug) do
        library.slug
      else
        slug
      end

    slug =
      if is_nil(slug) do
        slugify(get_change(changeset, :name))
      else
        slug
      end

    put_change(changeset, :slug, slug)
  end
end
