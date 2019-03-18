defmodule Among.Engine.GoogleTest do
  use ExUnit.Case

  alias Among.Engine.Google

  @google_response_html_tree "test/data/google_response.html"
                             |> File.read!()
                             |> Floki.parse()

  describe "result_count/1" do
    test "returns result count" do
      assert Google.result_count(@google_response_html_tree) == 323_000_000
    end

    test "other format returns -1" do
      # TODO
    end
  end

  describe "hits/1" do
    setup do
      hits = Google.hits(@google_response_html_tree)
      {:ok, %{hits: hits}}
    end

    test "returns hits", %{hits: hits} do
      assert length(hits) == 9
    end

    test "first hit values", %{hits: hits} do
      assert hd(hits) == %{
               content:
                 "The official website for  Game of Thrones  on HBO, featuring full episodes online,   \ninterviews, schedule information and episode guides.",
               title: "Game of Thrones  - Official Website for the HBO Series - HBO.com",
               url:
                 "https://www.google.com/url?q=https://www.hbo.com/game-of-thrones&sa=U&ved=0ahUKEwjc2eGgk4vhAhUhlosKHbm5AAwQFggVMAA&usg=AOvVaw2wV4XmaRgDDVE4eJejDrnR"
             }
    end

    test "hits contains required fields", %{hits: hits} do
      Enum.each(hits, fn hit ->
        assert Map.has_key?(hit, :title)
        assert Map.has_key?(hit, :url)
        assert Map.has_key?(hit, :content)
      end)
    end
  end
end
