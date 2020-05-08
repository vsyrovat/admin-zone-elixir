defmodule AppWeb.Auth.ErrorHandler do
  import Phoenix.Controller
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    conn
    |> put_flash(:error, "You must be logged in to access this page")
    |> put_status(:forbidden)
    |> put_view(AppWeb.ErrorView)
    |> render("403.html")
    |> halt()
  end

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})
    send_resp(conn, 401, body)
  end
end
