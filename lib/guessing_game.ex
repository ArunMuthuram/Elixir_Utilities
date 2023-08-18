defmodule GuessingGame do
  @yes_no_msg "Enter 'Y' for yes and 'N' for no."
  @big_small_msg "Enter 'B' if your number is bigger than my guess or 'S' if your number is smaller than my guess."
  @restart_end_msg "Enter 'Y' to play again and 'N' to exit."

  def start_game() do
    print_game_start_msg()
    get_user_input()
    do_start_game(1, 20, 1)
  end

  defp do_start_game(low, high, guess_attempts) do
    guess = Enum.random(low..high)
    print_guess(guess)
    correct_guess? = get_boolean_user_input("y", "n", get_user_input(), @yes_no_msg)
    process_guess(correct_guess?, low, high, guess, guess_attempts)
  end

  defp process_guess(true, _low, _high, _guess, guess_attempts) do
    print_game_end_msg(guess_attempts)
    restart_game? = get_boolean_user_input("y", "n", get_user_input(), @restart_end_msg)
    process_restart_game_input(restart_game?)
  end

  defp process_guess(false, low, high, guess, guess_attempts) do
    {new_low, new_high} = get_new_range(low, high, guess, get_smaller_bigger_atom())
    do_start_game(new_low, new_high, guess_attempts + 1)
  end

  defp process_restart_game_input(true), do: start_game()
  defp process_restart_game_input(_), do: IO.puts("Thank you for playing!")

  defp get_smaller_bigger_atom() do
    print_smaller_or_bigger_msg()
    num_bigger_than_guess? = get_boolean_user_input("b", "s", get_user_input(), @big_small_msg)
    if num_bigger_than_guess?, do: :bigger, else: :smaller
  end

  defp print_game_start_msg(),
    do:
      IO.puts(
        "Welcome! Please think of a number between 1 and 20 and press enter. I will try to guess it."
      )

  defp print_guess(guess),
    do: IO.puts("My guess is #{guess}.\nIs my guess correct? #{@yes_no_msg}")

  defp print_smaller_or_bigger_msg, do: IO.puts("Ok. #{@big_small_msg}")
  defp print_wrong_input_msg(msg), do: IO.puts("Wrong input! #{msg}")

  defp print_game_end_msg(count),
    do: IO.puts("Yayy! I guessed the number in #{count} turns. #{@restart_end_msg}")

  defp get_boolean_user_input(input1, _input2, input1, _msg), do: true
  defp get_boolean_user_input(_input1, input2, input2, _msg), do: false

  defp get_boolean_user_input(input1, input2, _user_input, msg) do
    print_wrong_input_msg(msg)
    get_boolean_user_input(input1, input2, get_user_input(), msg)
  end

  defp get_user_input, do: IO.gets("") |> String.trim() |> String.downcase()

  defp get_new_range(_low, _high, 20, :bigger), do: {1, 20}
  defp get_new_range(_low, high, guess, :bigger), do: {guess + 1, high}
  defp get_new_range(_low, _high, 1, :smaller), do: {1, 20}
  defp get_new_range(low, _high, guess, :smaller), do: {low, guess - 1}
end
