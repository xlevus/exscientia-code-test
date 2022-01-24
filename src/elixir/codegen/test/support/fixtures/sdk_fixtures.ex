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
        # Create a random slug. Something isn't clearing the DB between
        # each test and I don't care enough at this point to work out why.
        slug: ~s|some-name-#{Enum.random(0..99999)}|
      })
      |> Codegen.SDK.create_library()

    library
  end

  @doc """
  Generate a resource.
  """
  def resource_fixture(attrs) do
    resource_fixture(library_fixture(), attrs)
  end

  def resource_fixture(library, attrs) do
    {:ok, resource} =
      Codegen.SDK.create_resource(
        library,
        Enum.into(attrs, %{
          name: "some name",
          schema: %{},
          uri: "some uri"
        })
      )

    resource
  end
end
