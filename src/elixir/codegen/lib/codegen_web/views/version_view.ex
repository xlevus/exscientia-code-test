defmodule CodegenWeb.VersionView do
  use CodegenWeb, :view
  alias CodegenWeb.VersionView

  def render("index.json", %{versions: versions}) do
    %{data: render_many(versions, VersionView, "version.json")}
  end

  def render("show.json", %{version: version}) do
    %{data: render_one(version, VersionView, "version.json")}
  end

  def render("version.json", %{version: version}) do
    %{
      schema: version.schema,
      data_uri: version.data_uri,
      version: version.version
    }
  end
end
