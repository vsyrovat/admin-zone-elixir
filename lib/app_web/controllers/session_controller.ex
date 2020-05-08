defmodule AppWeb.SessionController do
  use AppWeb, :controller
  import AppWeb.Auth

  plug :scrub_params, "session" when action in [:create]

  def new(conn, _), do: render(conn, "new.html")

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You're now logged in!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "See you later!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
