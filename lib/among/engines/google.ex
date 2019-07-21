defmodule Among.Engine.Google do
  @moduledoc """
  Google engine
  Modelled after https://github.com/asciimoo/searx/blob/master/searx/engines/google.py
  """
  alias Among.Dom
  alias Among.Search.Response

  require Logger

  defstruct name: "Google",
            query: "",
            options: []

  defimpl Among.Search, for: Among.Engine.Google do
    def search(data = %Among.Engine.Google{}) do
      Logger.info("Searching for: #{inspect(binding())}")
      Among.Engine.Google.do_search(data.query, data.options)
    end
  end

  @google_hostname "www.google.com"
  @accept "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"

  def do_search(query, _options) do
    # TODO use options for language and stuff
    url = search_url(query)
    headers = [Accept: @accept, "User-agent": user_agent()]

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- HTTPoison.get(url, headers),
         parsed <- Floki.parse(body) do
      total_results = result_count(parsed)
      hits = hits(parsed)

      {:ok, %Response{engine: __MODULE__, total_results: total_results, hits: hits}}
    end
  end

  @result_count_selector "div[id=\"resultStats\"]"
  @whitespace_regex ~r/\s/iu
  def result_count(parsed) do
    count_string =
      case Floki.find(parsed, @result_count_selector) do
        [{"div", _, [result_stat | _]} | _] -> result_stat
        _unknown -> "About -1 results"
      end

    count_string
    |> String.replace("About", "")
    |> String.replace("results", "")
    |> String.replace(@whitespace_regex, "")
    |> String.to_integer()
  end

  @result_hits_selector "div[class=\"g\"]"
  def hits(parsed) do
    parsed
    |> Floki.find(@result_hits_selector)
    |> Enum.reject(fn hit -> Floki.find(hit, "div[class=\"s\"]") == [] end)
    |> Enum.map(&hit_map/1)
  end

  def hit_map(raw_hit) do
    %{
      title: extract_title(raw_hit),
      url: extract_url(raw_hit, "https://#{@google_hostname}"),
      content: extract_content(raw_hit),
      source: "Google"
    }
  end

  @hit_title_selector "h3"
  def extract_title(raw_hit) do
    raw_hit
    |> Floki.find(@hit_title_selector)
    |> List.first()
    |> Dom.extract_text()
  end

  @hit_url_selector "h3 > a"
  def extract_url(raw_hit, base_url) do
    raw_hit
    |> Floki.find(@hit_url_selector)
    |> Floki.attribute("href")
    |> List.first()
    |> unpacked_url()
    |> Dom.fix_url_path(base_url)
  end

  @google_url_parameter "q"
  defp unpacked_url(google_uri) do
    google_uri
    |> URI.parse()
    |> Map.get(:query, "")
    |> URI.decode_query()
    |> Map.get(@google_url_parameter, google_uri)
  end

  @hit_content_selector "span[class=\"st\"]"
  def extract_content(raw_hit) do
    raw_hit
    |> Floki.find(@hit_content_selector)
    |> List.first()
    |> Dom.extract_text()
  end

  def search_url(query) do
    search_path = "/search"
    offset = 0
    query = URI.encode(query)
    lang_short = "en-GB"
    lang = "lang_#{lang_short}"

    "https://#{@google_hostname}#{search_path}" <>
      "?q=#{query}&start=#{offset}&gws_rd=cr&gbv=1&lr=#{lang}&hl=#{lang_short}&ei=x"
  end

  @operating_systems [
    "Windows NT 10; WOW64",
    "X11; Linux x86_64"
  ]

  @agent_versions [
    "61.0.1",
    "61.0",
    "60.0.2",
    "60.0.1",
    "60.0"
  ]

  def user_agent() do
    os = Enum.random(@operating_systems)
    version = Enum.random(@agent_versions)
    "Mozilla/5.0 (#{os}; rv:#{version}) Gecko/20100101 Firefox/#{version}"
  end
end
