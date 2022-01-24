defmodule Codegen.SDKTest do
  use Codegen.DataCase

  alias Codegen.SDK

  describe "libraries" do
    alias Codegen.SDK.Library

    import Codegen.SDKFixtures

    @invalid_attrs %{description: nil, slug: nil, name: nil}

    test "list_libraries/0 returns all libraries" do
      library = library_fixture()
      assert SDK.list_libraries() == [library]
    end

    test "get_library!/1 returns the library with given id" do
      library = library_fixture()
      assert SDK.get_library!(library.id) == library
      assert SDK.get_library!(library.slug) == library
    end

    test "create_library/1 with valid data creates a library" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Library{} = library} = SDK.create_library(valid_attrs)
      assert library.description == "some description"
      assert library.name == "some name"
      assert library.slug == "some-name"
    end

    test "create_library/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SDK.create_library(@invalid_attrs)
    end

    test "update_library/2 with valid data updates the library" do
      library = library_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Library{} = library} = SDK.update_library(library, update_attrs)
      assert library.description == "some updated description"
      assert library.name == "some updated name"
    end

    test "update_library/2 with invalid data returns error changeset" do
      library = library_fixture()
      assert {:error, %Ecto.Changeset{}} = SDK.update_library(library, @invalid_attrs)
      assert library == SDK.get_library!(library.id)
    end

    test "delete_library/1 deletes the library" do
      library = library_fixture()
      assert {:ok, %Library{}} = SDK.delete_library(library)
      assert_raise Ecto.NoResultsError, fn -> SDK.get_library!(library.id) end
    end

    test "change_library/1 returns a library changeset" do
      library = library_fixture()
      assert %Ecto.Changeset{} = SDK.change_library(library)
    end
  end
end
