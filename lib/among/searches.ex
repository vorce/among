defmodule Among.Searches do
  @moduledoc """
  The Searches context.
  """
  # alias Among.Searches.Search

  require Logger

  def search(query) do
    Logger.info("Searching for #{inspect(query)}")
    {:ok, []}
  end
end
