defmodule Among.DomTest do
  use ExUnit.Case

  alias Among.Dom

  describe "fix_url_path/2" do
    test "adds base_url to relative url" do
      base_url = "https://www.google.com"
      url = "/url?q=https://en.wikipedia.org/wiki/Game_of_Thrones&sa=U&ved=0L1Ou"
      assert Dom.fix_url_path(url, base_url) == base_url <> url
    end

    test "adds http to missing protocol url" do
      url = "//example.com"
      assert Dom.fix_url_path(url, "") == "http:" <> url
    end
  end
end
