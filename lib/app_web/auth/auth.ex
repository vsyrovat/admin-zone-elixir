defmodule AppWeb.Auth do
  alias App.Repo
  alias App.Auth.User

  defp login(conn, user) do
    App.Guardian.Plug.sign_in(conn, user)
  end

  def login_by_email_and_pass(conn, email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && User.checkpwd(password, user.password_hash) ->
        {:ok, login(conn, user)}

      user ->
        {:error, :unauthorized, conn}

      true ->
        User.dummy_checkpwd()
        {:error, :no_resource_found, conn}
    end
  end

  def logout(conn) do
    App.Guardian.Plug.sign_out(conn)
  end
end
