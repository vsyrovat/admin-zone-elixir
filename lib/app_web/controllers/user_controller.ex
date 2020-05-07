defmodule AppWeb.UserController do
  use AppWeb, :controller

  alias App.Auth

  def index(conn, _params) do
    users = Auth.list_users()
    render(conn, "index.html", users: users)
  end
end
