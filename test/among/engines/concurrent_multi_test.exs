defmodule Among.Engine.ConcurrentMultiTest do
  use ExUnit.Case

  alias Among.Engine.ConcurrentMulti

  describe "search" do
    test "returns results from many engines" do
      engine = %ConcurrentMulti{
        engines: [
          %Among.Engine.Static{},
          %Among.Engine.Static{}
        ]
      }

      static_response_hits = Among.Engine.Static.response().hits

      assert {:ok, response} = Among.Search.search(engine)
      assert length(response.hits) == length(static_response_hits) * length(engine.engines)
    end

    test "returns the same hits as the Multi engine" do
      engine = %ConcurrentMulti{
        engines: [
          %Among.Engine.Static{},
          %Among.Engine.Static{}
        ]
      }

      multi_engine = %Among.Engine.Multi{engines: engine.engines}

      {:ok, result} = Among.Search.search(engine)
      {:ok, multi_result} = Among.Search.search(multi_engine)

      assert result.hits == multi_result.hits
    end
  end
end
