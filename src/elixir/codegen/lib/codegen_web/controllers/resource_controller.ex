defmodule CodegenWeb.ResourceController do
  use CodegenWeb, :controller

  alias Codegen.SDK
  alias Codegen.SDK.Resource

  action_fallback(CodegenWeb.FallbackController)

  def index(conn, %{"library_id" => library_id}) do
    resources = SDK.list_resources()
    render(conn, "index.json", resources: resources)
  end

  def create(conn, %{"resource" => resource_params, "library_id" => library_id}) do
    library = SDK.get_library!(library_id)

    with {:ok, %Resource{} = resource} <- SDK.create_resource(library, resource_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.resource_path(conn, :show, library_id, resource))
      |> render("show.json", resource: resource)
    end
  end

  def show(conn, %{"library_id" => library_id, "id" => id}) do
    resource = SDK.get_resource!(id)
    render(conn, "show.json", resource: resource)
  end

  def update(conn, %{"id" => id, "resource" => resource_params}) do
    resource = SDK.get_resource!(id)

    with {:ok, %Resource{} = resource} <- SDK.update_resource(resource, resource_params) do
      render(conn, "show.json", resource: resource)
    end
  end

  def delete(conn, %{"id" => id}) do
    resource = SDK.get_resource!(id)

    with {:ok, %Resource{}} <- SDK.delete_resource(resource) do
      send_resp(conn, :no_content, "")
    end
  end
end
