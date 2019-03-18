defmodule Among.Engine.GoogleTest do
  use ExUnit.Case

  alias Among.Engine.Google

  @full_response_html_tree "test/data/google_response.html"
                           |> File.read!()
                           |> Floki.parse()

  @single_hit_html_tree {"div", [{"class", "g"}],
                         [
                           {"h3", [{"class", "r"}],
                            [
                              {"a",
                               [
                                 {"href",
                                  "/url?q=https://www.hbo.com/game-of-thrones&sa=U&ved=0ahUKEwjc2eGgk4vhAhUhlosKHbm5AAwQFggVMAA&usg=AOvVaw2wV4XmaRgDDVE4eJejDrnR"}
                               ],
                               [
                                 {"b", [], ["Game of Thrones"]},
                                 " - Official Website for the HBO Series - HBO.com"
                               ]}
                            ]},
                           {"div", [{"class", "s"}],
                            [
                              {"div", [{"class", "hJND5c"}, {"style", "margin-bottom:2px"}],
                               [
                                 {"cite", [],
                                  ["https://www.hbo.com/", {"b", [], ["game-of-thrones"]}]},
                                 {"span", [{"class", "A8ul6"}],
                                  [
                                    " - ",
                                    {"a",
                                     [
                                       {"href",
                                        "/url?q=http://webcache.googleusercontent.com/search%3Fq%3Dcache:sIwqDECL5GUJ:https://www.hbo.com/game-of-thrones%252Bgame%2Bof%2Bthrones%26lr%26gbv%3D1%26hl%3Den-GB%26tbs%3Dlr:lang_1en-GB%26ct%3Dclnk&sa=U&ved=0ahUKEwjc2eGgk4vhAhUhlosKHbm5AAwQIAgWMAA&usg=AOvVaw1FhOf7f27I9fr16GP6d7u6"}
                                     ], ["Cached"]}
                                  ]}
                               ]},
                              {"span", [{"class", "st"}],
                               [
                                 "The official website for ",
                                 {"b", [], ["Game of Thrones"]},
                                 " on HBO, featuring full episodes online, ",
                                 {"br", [], []},
                                 "\ninterviews, schedule information and episode guides."
                               ]},
                              {"br", [], []}
                            ]}
                         ]}

  describe "result_count/1" do
    test "returns result count" do
      assert Google.result_count(@full_response_html_tree) == 323_000_000
    end

    test "other format returns -1" do
      # TODO
    end
  end

  describe "hits/1" do
    setup do
      hits = Google.hits(@full_response_html_tree)
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
               url: "https://www.hbo.com/game-of-thrones"
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

  describe "fix_url_path/2" do
    test "adds base_url to relative url" do
      base_url = "https://www.google.com"
      url = "/url?q=https://en.wikipedia.org/wiki/Game_of_Thrones&sa=U&ved=0L1Ou"
      assert Google.fix_url_path(url, base_url) == base_url <> url
    end

    test "adds http to missing protocol url" do
      url = "//example.com"
      assert Google.fix_url_path(url, "") == "http:" <> url
    end
  end

  describe "extract_url/1" do
    test "returns wrapped url" do
      base_url = "https://www.google.com"

      assert Google.extract_url(@single_hit_html_tree, base_url) ==
               "https://www.hbo.com/game-of-thrones"
    end
  end
end
