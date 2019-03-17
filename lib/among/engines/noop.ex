defmodule Among.Engine.Noop do
  @moduledoc """
  Noop engine, returns an empty list
  """
  alias Among.Search.Response
  require Logger

  defstruct name: "Noop",
            query: "",
            options: []

  defimpl Among.Search, for: Among.Engine.Noop do
    def search(data = %Among.Engine.Noop{}) do
      Logger.info("Searching for: #{inspect(binding())}")
      {:ok, %Response{}}
    end
  end
end
