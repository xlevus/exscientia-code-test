defmodule Codegen.SDK.SchemaFetch do
  def get(url) do
    Finch.build(:get, url)
    |> Finch.request(MyFinch)
    |> get_body()
    |> Jason.decode!()
    |> IO.inspect()
  end

  # Why can't this be an anonymous function?
  defp get_body({:ok, %Finch.Response{body: body}}) do
    body
  end
end
