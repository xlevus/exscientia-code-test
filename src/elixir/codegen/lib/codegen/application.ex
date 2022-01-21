defmodule Codegen.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Codegen.Repo,
      # Start the Telemetry supervisor
      CodegenWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Codegen.PubSub},
      # Start the Endpoint (http/https)
      CodegenWeb.Endpoint,
      # Start a worker by calling: Codegen.Worker.start_link(arg)
      # {Codegen.Worker, arg}
      {Finch, name: MyFinch}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Codegen.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CodegenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
