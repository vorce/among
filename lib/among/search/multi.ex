defmodule Among.Search.Multi do
  @moduledoc """
  Search in multiple engines concurrently
  """

  @doc """
  Searches in all given engines, returns a map of results
  """
  @spec search(engines :: list, options :: Keyword.t()) :: {:ok, Map.t()} | {:error, any}
  def search(engines, options \\ []) do
    combined_result =
      engines
      |> Task.async_stream(&Among.Search.search/1, options)
      |> Enum.reduce(%{results: [], errors: []}, &combine_results/2)

    {:ok, combined_result} |> IO.inspect(label: "combined_results")
  end

  defp combine_results({:ok, {:error, error}}, %{errors: errors} = combined) do
    %{combined | errors: [error | errors]}
  end

  defp combine_results({:ok, {:ok, result}}, %{results: results} = combined) do
    %{combined | results: List.flatten([result.hits | results])}
  end
end
