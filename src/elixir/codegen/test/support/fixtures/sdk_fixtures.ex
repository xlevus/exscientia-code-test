defmodule Codegen.SDKFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Codegen.SDK` context.
  """

  @doc """
  Generate a library.
  """
  def library_fixture(attrs \\ %{}) do
    {:ok, library} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        slug: "some-name"
      })
      |> Codegen.SDK.create_library()

    library
  end
end
