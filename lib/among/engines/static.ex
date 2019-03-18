defmodule Among.Engine.Static do
  @moduledoc """
  Noop engine, returns an empty list
  """
  alias Among.Search.Response
  require Logger

  defstruct name: "Static"

  defimpl Among.Search, for: Among.Engine.Static do
    def search(data = %Among.Engine.Static{}) do
      Logger.info("Searching for: #{inspect(binding())}")
      {:ok, Among.Engine.Static.response()}
    end
  end

  def response() do
    %Response{
      engine: __MODULE__,
      total_results: 3,
      hits: [
        %{
          url: "http://www.google.com",
          title: "Google",
          content: "Stuff here?"
        },
        %{
          url: "https://github.com/vorce/among",
          title: "vorce/among: Meta search engine",
          content: "Meta search engine inspired by searchx."
        },
        %{
          url:
            "https://blog.acolyer.org/2018/06/28/how-_not_-to-structure-your-database-backed-web-applications-a-study-of-performance-bugs-in-the-wild/",
          title:
            "How not to structure your database-backed web applications: a study of performance bugs in the wild",
          content:
            "How not to structure your database-backed web applications: a study of performance bugs in the wild Yang et al., ICSE’18\n\nThis is a fascinating study of the problems people get into when using ORMs to handle persistence concerns in their web applications."
        }
      ]
    }
  end
end
