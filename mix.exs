defmodule Ussd.MixProject do
  use Mix.Project

  @source_url "https://github.com/pessewa/ussd.git"

  def project do
    [
      app: :ussd,
      version: "0.1.2",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      package: package(),
      name: "Ussd",
      description: description(),
      source_url: @source_url,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Ussd.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.6.6"},
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
    ]
  end

  defp description() do
    "Build Ussd (Unstructured Supplementary Service Data) applications with phoenix without breaking a sweat."
  end

  defp package() do
    [
      maintainers: ["Benjamin Manford"],
      files: ~w(lib priv test .formatter.exs mix.exs README* LICENSE),
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
