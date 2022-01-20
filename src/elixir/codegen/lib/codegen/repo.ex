defmodule Codegen.Repo do
  use Ecto.Repo,
    otp_app: :codegen,
    adapter: Ecto.Adapters.Postgres
end
