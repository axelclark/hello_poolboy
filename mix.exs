defmodule HelloPoolboy.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_poolboy,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HelloPoolboy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poolboy, "~> 1.5.1"},
      {:chromic_pdf, "~> 1.14"},
      {:opq, "~> 4.0"}
    ]
  end
end
