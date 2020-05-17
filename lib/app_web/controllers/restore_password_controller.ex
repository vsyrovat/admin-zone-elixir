defmodule AppWeb.RestorePasswordController do
  use AppWeb, :controller

  alias App.Auth

  def index(conn, _params), do: render(conn, "index.html")

  def create(conn, %{"restore_password_request" => %{"email" => email}}) do
    case Auth.find_user_by_email(email) do
      nil ->
        render(conn, "create_fail.html")

      user ->
        Auth.email_password_recovery(conn, user)
        render(conn, "create_ok.html")
    end
  end

  def restore(conn, %{"userid" => userid, "key" => key}) do
    user = Auth.get_user!(userid)
    render(conn, "restore.html", user: user, key: key)
  end

  def do_recover(conn, %{
        "form" => %{
          "user_id" => user_id,
          "key" => key,
          "new_password" => password,
          "new_password_repeat" => password_repeat
        }
      }) do
    user = Auth.get_user!(user_id)
    unless user.password_recovery_key == key, do: raise("Key mismatch")
    unless password == password_repeat, do: raise("New password mismatch")
    {:ok, _} = Auth.update_user(user, %{password: password, password_recovery_key: nil})
    render(conn, "do_recover_success.html")
  end
end
