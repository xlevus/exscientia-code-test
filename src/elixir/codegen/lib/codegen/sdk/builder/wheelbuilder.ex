defmodule Codegen.SDK.Builder.Wheelbuilder do
  alias Codegen.SDK.Builder.Dataclass
  alias Codegen.SDK.Builder.Render

  def generate_package(library, resources) do
    pkg_name = Macro.underscore(library.name)

    tmpdir =
      Temp.path!()
      |> IO.inspect()

    srcdir = Path.join(tmpdir, pkg_name)

    try do
      File.mkdir_p!(srcdir)
      write_srcfiles(srcdir, resources)
      write_setuppy(tmpdir, pkg_name, "1.0.0")

      distdir = Path.join(tmpdir, "dist")

      System.cmd("python", [
        Path.join(tmpdir, "setup.py"),
        "bdist",
        "-b",
        Path.join(tmpdir, "bdist"),
        "-d",
        distdir
      ])

      fname = File.ls!(distdir) |> hd()

      {fname, distdir |> Path.join(fname) |> File.read!()}
    rescue
      e -> reraise(e, __STACKTRACE__)
    after
      # File.rm_rf(tmpdir)
    end
  end

  defp write_srcfiles(srcpath, [resource | remainder]) do
    {ctx, _} = Dataclass.build(resource.name, resource.schema)
    filename = ~s|#{Macro.underscore(resource.name)}.py|
    source = Render.build_python(ctx, resource.uri)

    srcpath
    |> Path.join(filename)
    |> File.open!([:write])
    |> IO.write(source)

    write_srcfiles(srcpath, remainder)
  end

  defp write_srcfiles(srcpath, []) do
    srcpath
    |> Path.join("__init__.py")
    |> File.open!([:write])
    |> IO.write("")
  end

  defp write_setuppy(tempdir, name, version) do
    source = Render.build_setuppy(name, version)

    tempdir
    |> Path.join("setup.py")
    |> File.open!([:write])
    |> IO.write(source)
  end
end
