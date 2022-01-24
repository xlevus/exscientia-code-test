defmodule CodegenWeb.ResourceView do
  use CodegenWeb, :view
  alias CodegenWeb.ResourceView

  def render("index.json", %{resources: resources}) do
    %{data: render_many(resources, ResourceView, "resource.json")}
  end

  def render("show.json", %{resource: resource}) do
    %{data: render_one(resource, ResourceView, "resource.json")}
  end

  def render("resource.json", %{resource: resource}) do
    %{
      id: resource.id,
      name: resource.name,
      schema: resource.schema,
      schema_uri: resource.schema_uri,
      uri: resource.uri
    }
  end
end
