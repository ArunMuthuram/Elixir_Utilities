defmodule Mix.Tasks.RunUtil do
  use Mix.Task

  def run(_) do
    UtilityRunner.start()
  end
end
