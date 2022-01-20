defmodule CodegenWeb.LibraryController do
  use CodegenWeb, :controller

  alias Codegen.SDK
  alias Codegen.SDK.Library

  def index(conn, _params) do
    libraries = SDK.list_libraries()
    render(conn, "index.html", libraries: libraries)
  end

  def new(conn, _params) do
    changeset = SDK.change_library(%Library{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"library" => library_params}) do
    case SDK.create_library(library_params) do
      {:ok, library} ->
        conn
        |> put_flash(:info, "Library created successfully.")
        |> redirect(to: Routes.library_path(conn, :show, library))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    library = SDK.get_library!(id)
    render(conn, "show.html", library: library)
  end

  def edit(conn, %{"id" => id}) do
    library = SDK.get_library!(id)
    changeset = SDK.change_library(library)
    render(conn, "edit.html", library: library, changeset: changeset)
  end

  def update(conn, %{"id" => id, "library" => library_params}) do
    library = SDK.get_library!(id)

    case SDK.update_library(library, library_params) do
      {:ok, library} ->
        conn
        |> put_flash(:info, "Library updated successfully.")
        |> redirect(to: Routes.library_path(conn, :show, library))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", library: library, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    library = SDK.get_library!(id)
    {:ok, _library} = SDK.delete_library(library)

    conn
    |> put_flash(:info, "Library deleted successfully.")
    |> redirect(to: Routes.library_path(conn, :index))
  end
end
