defmodule AppWeb.Auth.CheckAdmin do
  import Phoenix.Controller
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user.is_admin do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> put_view(AppWeb.ErrorView)
      |> render("403.html")
      |> halt
    end
  end
end
