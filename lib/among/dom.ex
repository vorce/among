defmodule Among.Dom do
  @moduledoc """
  Utilities for working with a parsed html tree
  """
  require Logger

  @double_whitespace ~r/\s+/iu

  def extract_text(text) when is_binary(text), do: text

  def extract_text({_tag_name, _attributes, [text]}) when is_binary(text),
    do: extract_text(" #{text}")

  def extract_text({_tag_name, _attributes, []}), do: ""

  def extract_text({_tag_name, _attributes, children}) when is_list(children) do
    children
    |> Enum.map(&extract_text/1)
    |> Enum.join()
    |> String.replace(@double_whitespace, " ")
    |> String.trim()
  end

  # TODO: raise here
  def extract_text(element) do
    # raise("Unable to extract text from: #{inspect(element)}")
    Logger.error("Unable to extract text from: #{inspect(element)}, returning empty")
    ""
  end

  def fix_url_path(url, base_url) do
    cond do
      String.starts_with?(url, "//") ->
        "http:" <> url

      String.starts_with?(url, "/") ->
        base_url <> url

      true ->
        url
    end
  end
end
