defmodule AppWeb.PageControllerTest do
  use AppWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Admin Zone One"
  end
end
