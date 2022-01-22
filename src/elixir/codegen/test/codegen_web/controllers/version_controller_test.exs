defmodule CodegenWeb.VersionControllerTest do
  use CodegenWeb.ConnCase

  import Codegen.SDKFixtures

  alias Codegen.SDK.Version

  @create_attrs %{
    data_uri: "some data_uri",
    schema: %{}
  }
  @update_attrs %{
    data_uri: "some updated data_uri",
    schema: %{}
  }
  @invalid_attrs %{data_uri: nil, schema: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create version" do
    test "renders version when data is valid", %{conn: conn} do
      conn = post(conn, Routes.version_path(conn, :create), version: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.version_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "data_uri" => "some data_uri",
               "schema" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.version_path(conn, :create), version: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update version" do
    setup [:create_version]

    test "renders version when data is valid", %{conn: conn, version: %Version{id: id} = version} do
      conn = put(conn, Routes.version_path(conn, :update, version), version: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.version_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "data_uri" => "some updated data_uri",
               "schema" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, version: version} do
      conn = put(conn, Routes.version_path(conn, :update, version), version: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete version" do
    setup [:create_version]

    test "deletes chosen version", %{conn: conn, version: version} do
      conn = delete(conn, Routes.version_path(conn, :delete, version))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.version_path(conn, :show, version))
      end)
    end
  end

  defp create_version(_) do
    version = version_fixture()
    %{version: version}
  end
end
