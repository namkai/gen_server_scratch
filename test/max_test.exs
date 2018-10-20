defmodule MaxTest do
  use ExUnit.Case
  doctest Max

  test "greets the world" do
    assert Max.hello() == :world
  end
end
