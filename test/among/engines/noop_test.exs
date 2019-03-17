defmodule Among.Engine.NoopTest do
  use ExUnit.Case

  alias Among.Engine.Noop

  describe "search" do
    test "returns a response" do
      engine = %Noop{}
      assert {:ok, %Among.Search.Response{}} = Among.Search.search(engine)
    end
  end
end
