defmodule Codegen.SDK.SchemaFetch do
  def get(nil) do
    %{}
  end

  def get(url) do
    Finch.build(:get, url)
    |> Finch.request(MyFinch)
    |> case do
      {:ok, response} -> response.body
    end
    |> Jason.decode!()
  end
end
