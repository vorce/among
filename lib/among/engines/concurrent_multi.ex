defmodule Among.Engine.ConcurrentMulti do
  @moduledoc """
  Search in multiple engines concurrently
  """
  alias Among.Search.Response
  alias Among.Engine.Multi

  require Logger

  defstruct name: "ConcurrentMulti",
            query: "",
            engines: [],
            options: []

  defimpl Among.Search, for: Among.Engine.ConcurrentMulti do
    def search(data = %Among.Engine.ConcurrentMulti{}) do
      Logger.info("Searching for: #{inspect(binding())}")
      Among.Engine.ConcurrentMulti.do_search(data.engines, data.options)
    end
  end

  @doc """
  Searches in all given engines, returns a Response struct
  """
  @spec do_search(engines :: list, options :: Keyword.t()) :: {:ok, Response.t()} | {:error, any}
  def do_search(engines, options \\ []) do
    combined_response =
      engines
      |> Task.async_stream(&Among.Search.search/1, options)
      |> Enum.reduce(%Response{engine: __MODULE__}, &combine_unwrapped/2)

    {:ok, combined_response}
  end

  # Because async_stream wraps in tuple.
  defp combine_unwrapped({:ok, result}, response), do: Multi.combine_responses(result, response)
end
