defmodule Among.Engine.MultiTest do
  use ExUnit.Case

  alias Among.Engine.Multi

  describe "search" do
    test "returns results from many engines" do
      engine = %Multi{
        engines: [
          %Among.Engine.Static{},
          %Among.Engine.Static{}
        ]
      }

      static_response_hits = Among.Engine.Static.response().hits
      total_hits = length(static_response_hits) * length(engine.engines)

      assert {:ok, response} = Among.Search.search(engine)
      assert length(response.hits) == total_hits
      assert response.total_results == total_hits
    end
  end
end
