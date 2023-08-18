defmodule UtilityRunner do
  def start do
    IO.puts("""
      Welcome to Elixir utility.
      Please enter the respective utility number to run it.
        1 - Guessing game
        2 - File analyzer
        3 - Identicon generator
        0 - Quit
    """)

    user_input_loop(IO.gets("") |> String.trim())
  end

  defp user_input_loop(user_input) do
    case user_input do
      "1" ->
        GuessingGame.start_game()

      "2" ->
        IO.gets("Please enter the path for the file to be analysed\n") |> FileAnalyzer.analyze()

      "3" ->
        IO.gets("Please enter the username/email/id to generate the identicon\n")
        |> Identicon.generate()

      "0" ->
        IO.puts("Utility exited successfully.")

      _ ->
        user_input_loop(IO.gets("Please enter a valid option number.\n") |> String.trim())
    end
  end
end
