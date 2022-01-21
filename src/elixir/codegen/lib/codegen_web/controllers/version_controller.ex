defmodule CodegenWeb.VersionController do
  use CodegenWeb, :controller

  alias Codegen.SDK
  alias Codegen.SDK.Version
  alias Codegen.SDK.SchemaFetch

  action_fallback(CodegenWeb.FallbackController)

  def index(conn, %{"library_id" => library_id}) do
    library = SDK.get_library!(library_id)
    versions = SDK.list_versions(library)
    IO.inspect(versions)
    render(conn, "index.json", versions: versions)
  end

  def create(conn, %{
        "version" => %{"schema_uri" => schema_url} = version_params,
        "library_id" => library_id
      }) do
    library = SDK.get_library!(library_id)

    with {:ok, %Version{} = version} <-
           version_params
           |> Map.put("schema", SchemaFetch.get(schema_url))
           |> Map.put("library", library.id)
           |> SDK.create_version() do
      conn
      |> put_status(:created)
      |> put_resp_header(
        "location",
        Routes.version_path(conn, :show, library_id, version)
      )
      |> render("show.json", version: version)
    end
  end

  def show(conn, %{"id" => id}) do
    version = SDK.get_version!(id)
    render(conn, "show.json", version: version)
  end

  def delete(conn, %{"id" => id}) do
    version = SDK.get_version!(id)

    with {:ok, %Version{}} <- SDK.delete_version(version) do
      send_resp(conn, :no_content, "")
    end
  end
end
