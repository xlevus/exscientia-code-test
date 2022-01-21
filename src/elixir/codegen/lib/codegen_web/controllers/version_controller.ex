defmodule CodegenWeb.VersionController do
  use CodegenWeb, :controller

  alias Codegen.SDK
  alias Codegen.SDK.Version

  action_fallback(CodegenWeb.FallbackController)

  def index(conn, _params) do
    versions = SDK.list_versions()
    render(conn, "index.json", versions: versions)
  end

  def create(conn, %{"version" => version_params}) do
    with {:ok, %Version{} = version} <- SDK.create_version(version_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.version_path(conn, :show, version))
      |> render("show.json", version: version)
    end
  end

  def show(conn, %{"id" => id}) do
    version = SDK.get_version!(id)
    render(conn, "show.json", version: version)
  end

  def update(conn, %{"id" => id, "version" => version_params}) do
    version = SDK.get_version!(id)

    with {:ok, %Version{} = version} <- SDK.update_version(version, version_params) do
      render(conn, "show.json", version: version)
    end
  end

  def delete(conn, %{"id" => id}) do
    version = SDK.get_version!(id)

    with {:ok, %Version{}} <- SDK.delete_version(version) do
      send_resp(conn, :no_content, "")
    end
  end
end
