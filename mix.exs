defmodule ElixirUtility.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_utility,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application, do: []

  defp deps,
    do: [
      {:egd, git: "https://github.com/erlang/egd"}
    ]
end
