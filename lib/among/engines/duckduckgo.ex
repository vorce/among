defmodule Among.Engine.Duckduckgo do
  @moduledoc """
  Search in duckduckgo.com

  Modelled after https://github.com/asciimoo/searx/blob/master/searx/engines/duckduckgo.py
  """
  alias Among.Dom
  require Logger

  defstruct name: "Duckduckgo",
            query: "",
            options: []

  defimpl Among.Search, for: Among.Engine.Duckduckgo do
    def search(data = %Among.Engine.Duckduckgo{}) do
      Logger.info("Searching for: #{inspect(binding())}")
      Among.Engine.Duckduckgo.do_search(data.query, data.options)
    end
  end

  @duckduckgo_hostname "duckduckgo.com"

  def do_search(query, options) do
    url = search_url(query)
    headers = []

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url, headers),
         html_tree <- Floki.parse(body) do
      response = %Among.Search.Response{
        hits: hits(html_tree)
      }

      {:ok, response}
    end
  end

  @result_hits_selector "div[class=\"result results_links results_links_deep web-result \"]"
  def hits(html_tree) do
    html_tree
    |> Floki.find(@result_hits_selector)
    |> Enum.map(&hit_map/1)
  end

  defp hit_map(hit_tree) do
    %{
      title: extract_title(hit_tree),
      url: extract_url(hit_tree, "https://#{@duckduckgo_hostname}"),
      content: extract_content(hit_tree),
      source: "Duckduckgo"
    }
  end

  @hit_title_selector "a[class=\"result__a\"]"
  def extract_title(hit_tree) do
    hit_tree
    |> Floki.find(@hit_title_selector)
    |> List.first()
    |> Dom.extract_text()
  end

  @hit_url_selector "a[class=\"result__a\"]"
  def extract_url(hit_tree, base_url) do
    hit_tree
    |> Floki.find(@hit_url_selector)
    |> Floki.attribute("href")
    |> List.first()
    |> unpacked_url()
    |> Dom.fix_url_path(base_url)
  end

  @duckduckgo_url_parameter "uddg"
  defp unpacked_url(uri) do
    uri
    |> URI.parse()
    |> Map.get(:query, "")
    |> URI.decode_query()
    |> Map.get(@duckduckgo_url_parameter, uri)
  end

  @duckduckgo_content_selector "a[class=\"result__snippet\"]"
  def extract_content(hit_tree) do
    hit_tree
    |> Floki.find(@duckduckgo_content_selector)
    |> List.first()
    |> Dom.extract_text()
  end

  def search_url(query) do
    offset = 0
    query = URI.encode(query)
    "https://#{@duckduckgo_hostname}/html?q=#{query}&s=#{offset}&dc=#{offset}"
  end
end
