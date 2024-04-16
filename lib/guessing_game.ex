defmodule GuessingGame do
  use Application

  def start(_type, _args) do
    GuessingGame.main()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def main do
    correct = :rand.uniform(11) - 1
    guesses = []

    loop(correct, guesses)
  end

  defp loop(correct, guesses) do
    if guesses != [] do
      IO.inspect(guesses, label: "Previous guesses")
    end

    guess = get_guess()

    if guess in guesses do
      IO.puts("You have already guessed #{guess}. Try another number.")
      loop(correct, guesses)
    else
      updated_guesses = Enum.sort([guess | guesses])

      if guess == correct do
        IO.puts("\n#{guess} is correct. You win!")
      else
        IO.puts("#{guess} is wrong. Try again.")
        loop(correct, updated_guesses)
      end

    end
  end

  defp get_guess do
    guess_input = IO.gets("\nGuess a number between 0 to 10: ") |> String.trim()
    case Integer.parse(guess_input) do
      {number, ""} when number in 0..10 -> number
      _ ->
        IO.puts("Please enter a valid number between 0 and 10.")
        get_guess()
    end
  end
end
