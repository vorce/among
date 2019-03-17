defmodule Among.Engine.StaticTest do
  use ExUnit.Case

  alias Among.Engine.Static

  describe "search" do
    test "returns a list of hits" do
      engine = %Static{}

      assert {:ok, response} = Among.Search.search(engine)
      assert length(response.hits) > 0
      assert response.hits == Among.Engine.Static.response().hits
    end
  end
end
