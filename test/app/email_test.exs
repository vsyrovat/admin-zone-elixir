defmodule App.EmailTest do
  use ExUnit.Case
  use AppWeb.ConnCase

  alias App.Auth.User

  test "password recovery email" do
    user = %User{email: "suka@dot.com"}
    conn = get(build_conn(), "/")
    email = App.Email.password_recovery_email(conn, user)

    assert email.to == user.email
    assert email.from == "system@app"
    assert email.html_body =~ "Recover password"
    assert email.text_body =~ "Recover password"
  end
end
