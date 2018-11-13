defmodule AnuIoTest do
  use ExUnit.Case
  doctest AnuIo

  test "greets the world" do
    assert AnuIo.hello() == :world
  end
end
