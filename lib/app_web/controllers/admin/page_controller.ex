defmodule AppWeb.Admin.PageController do
  use AppWeb, :controller

  def index(conn, _), do: render(conn, "index.html")
end
