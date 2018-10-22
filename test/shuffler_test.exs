defmodule ShufflerTest do
  use ExUnit.Case
  doctest Shuffler

  test "greets the world" do
    assert Shuffler.hello() == :world
  end
end
