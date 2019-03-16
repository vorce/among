defmodule AmongWeb.PageControllerTest do
  use AmongWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Search"
  end
end
