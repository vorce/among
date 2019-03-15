defmodule AmongWeb.PageController do
  use AmongWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
