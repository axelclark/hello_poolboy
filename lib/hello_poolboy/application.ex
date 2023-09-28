defmodule HelloPoolboy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config()),
      {ChromicPDF, chromic_pdf_opts()},
      {OPQ, opq_config()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloPoolboy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp poolboy_config() do
    [
      name: {:local, :worker},
      worker_module: HelloPoolboy.Worker,
      size: 3,
      max_overflow: 0
    ]
  end

  defp chromic_pdf_opts() do
    [session_pool: [timeout: 5000, checkout_timeout: 30_000]]
  end

  defp opq_config() do
    [name: :pdf, workers: 3, timeout: 1000]
  end
end
