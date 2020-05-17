defmodule AppWeb.EmailController do
  use AppWeb, :controller

  def send(conn, _params) do
    App.Email.test_email()
    |> App.Mailer.deliver_later()

    render(conn, "send.html")
  end
end
