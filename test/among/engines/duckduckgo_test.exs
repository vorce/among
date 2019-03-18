defmodule Among.Engine.DuckduckgoTest do
  use ExUnit.Case

  alias Among.Engine.Duckduckgo

  @response_html_tree "test/data/duckduckgo_response.html"
                      |> File.read!()
                      |> Floki.parse()

  describe "hits/1" do
    test "returns hits" do
      hits = Duckduckgo.hits(@response_html_tree)
      assert hits != []

      assert List.first(hits) == %{
               url: "https://github.com/elixir-search/searchex",
               content:
                 "Searchex Readme. A full-text search engine written in pure Elixir. Three goals: 1) a simple CLI, 2) a scalable API, and 3) shareable document repos. BEAM, OTP, and GenStage give us the best possible foundation on which to build. Searchex provides a search capability for full-text documents.",
               title: "GitHub - elixir- search/searchex: Search Engine written in ...",
               source: "Duckduckgo"
             }
    end
  end
end
