defmodule GuessingGame.MixProject do
  use Mix.Project

  def project do
    [
      app: :guessing_game,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application, do: []

  defp deps, do: []
end
