defmodule Among.Engine.Multi do
  @moduledoc """
  Search in multiple engines sequentially
  """
  alias Among.Search.Response

  require Logger

  defstruct name: "Multi",
            query: "",
            engines: [],
            options: []

  defimpl Among.Search, for: Among.Engine.Multi do
    def search(data = %Among.Engine.Multi{}) do
      Logger.info("Searching for: #{inspect(binding())}")
      Among.Engine.Multi.do_search(data.engines)
    end
  end

  @doc """
  Searches in all given engines, returns a response struct
  """
  @spec do_search(engines :: list, options :: Keyword.t()) :: {:ok, Response.t()} | {:error, any}
  def do_search(engines, _options \\ []) do
    combined_response =
      engines
      |> Enum.map(&Among.Search.search/1)
      |> Enum.reduce(%Response{engine: __MODULE__}, &combine_responses/2)

    {:ok, combined_response}
  end

  def combine_responses({:error, error}, %{errors: errors} = combined) do
    %Response{combined | errors: [error | errors]}
  end

  def combine_responses({:ok, response}, %{hits: hits} = combined) do
    %Response{combined | hits: List.flatten([response.hits | hits])}
  end
end
