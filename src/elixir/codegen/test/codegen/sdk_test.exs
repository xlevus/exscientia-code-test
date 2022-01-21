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

  describe "versions" do
    alias Codegen.SDK.Version

    import Codegen.SDKFixtures

    @invalid_attrs %{data_uri: nil, schema: nil}

    test "list_versions/0 returns all versions" do
      version = version_fixture()
      assert SDK.list_versions() == [version]
    end

    test "get_version!/1 returns the version with given id" do
      version = version_fixture()
      assert SDK.get_version!(version.id) == version
    end

    test "create_version/1 with valid data creates a version" do
      valid_attrs = %{data_uri: "some data_uri", schema: %{}}

      assert {:ok, %Version{} = version} = SDK.create_version(valid_attrs)
      assert version.data_uri == "some data_uri"
      assert version.schema == %{}
    end

    test "create_version/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SDK.create_version(@invalid_attrs)
    end

    test "update_version/2 with valid data updates the version" do
      version = version_fixture()
      update_attrs = %{data_uri: "some updated data_uri", schema: %{}}

      assert {:ok, %Version{} = version} = SDK.update_version(version, update_attrs)
      assert version.data_uri == "some updated data_uri"
      assert version.schema == %{}
    end

    test "update_version/2 with invalid data returns error changeset" do
      version = version_fixture()
      assert {:error, %Ecto.Changeset{}} = SDK.update_version(version, @invalid_attrs)
      assert version == SDK.get_version!(version.id)
    end

    test "delete_version/1 deletes the version" do
      version = version_fixture()
      assert {:ok, %Version{}} = SDK.delete_version(version)
      assert_raise Ecto.NoResultsError, fn -> SDK.get_version!(version.id) end
    end

    test "change_version/1 returns a version changeset" do
      version = version_fixture()
      assert %Ecto.Changeset{} = SDK.change_version(version)
    end
  end
end
