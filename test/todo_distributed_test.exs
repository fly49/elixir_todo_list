defmodule TodoDistributedTest do
  use ExUnit.Case
  doctest TodoDistributed

  test "greets the world" do
    assert TodoDistributed.hello() == :world
  end
end
