defmodule FreddieClientTest do
  use ExUnit.Case
  doctest FreddieClient

  test "greets the world" do
    assert FreddieClient.hello() == :world
  end
end
