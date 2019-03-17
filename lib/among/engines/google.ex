defmodule Among.Engine.Google do
  @moduledoc """
  Google engine
  """
  alias Among.Search.Response
  require Logger

  defstruct name: "Google",
            query: "",
            options: []

  defimpl Among.Search, for: Among.Engine.Google do
    def search(data = %Among.Engine.Google{}) do
      Logger.info("Searching for: #{inspect(binding())}")
      Among.Engine.Google.do_search(data.query)
    end
  end

  def do_search(query) do
    {:ok, %Response{engine: __MODULE__}}
  end

  def search_url(query) do
    hostname = "www.google.com"
    search_path = "/search"
    offset = 0
    query = URI.encode(query)
    lang_short = "en-GB"
    lang = "lang_#{lang_short}"

    "https://#{hostname}#{search_path}" <>
      "?q=#{query}&start=#{offset}&gws_rd=cr&gbv=1&lr=#{lang}&hl=#{lang_short}&ei=x"
  end
end
