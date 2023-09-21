defmodule HelloPoolboyTest do
  use ExUnit.Case
  doctest HelloPoolboy

  test "greets the world" do
    assert HelloPoolboy.hello() == :world
  end
end
