defmodule PrngTest do
  use ExUnit.Case, async: true

  test "the truth" do
    list = [1, 2, 3, 4]
    times = 1_000
    IO.puts "testing #{times} times"

    counts = Enum.reduce(0..times, %{}, fn
      (_, acc) -> Map.update(acc, Enum.shuffle(list), 0, fn(x) -> x+1 end)
    end)
    |> Map.values

    assert length(counts) == 24
    # This is expected to fail once every ~20 runs for a good PRNG
    assert Enum.min(counts) > Float.floor(times/24.0 * 0.60)
    assert Enum.max(counts) < Float.ceil(times/24.0 * 1.40)
  end
end
