defmodule App.Email do
  alias App.Auth.User

  import Bamboo.Email

  def password_recovery_email(conn, %User{} = user) do
    url = AppWeb.Router.Helpers.restore_password_url(conn, :restore, userid: user.id, key: user.password_recovery_key)

    new_email(
      to: user.email,
      from: "system@app",
      subject: "Password recovery",
      html_body: "<a href='#{url}' target=_blank>Recover password</a>",
      text_body: "Recover password: #{url}"
    )
  end

  def test_email do
    new_email(
      to: "apace@yandex.ru",
      from: "apace@yandex.ru",
      subject: "test mail",
      text_body: "hoho"
    )
  end
end
