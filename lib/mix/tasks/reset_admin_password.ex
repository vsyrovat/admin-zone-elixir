defmodule Mix.Tasks.ResetAdminPassword do
  @moduledoc ~S"""
  Reset admin password
  Type new admin password twice
  """

  alias App.Auth
  use Mix.Task

  @min_pass_length 6

  @shortdoc "Reset admin pasword"
  def run(_) do
    pass = password_get("New Admin password:")
    confirmation = password_get("Repeat Admin password:")
    assert_match(pass, confirmation)
    assert_length(pass)

    {:ok, user, _apps} =
      Ecto.Migrator.with_repo(App.Repo, fn _repo ->
        [admin | _] = Auth.find_admins()
        Auth.update_user(admin, %{password: pass})
        admin
      end)

    IO.puts("New password for user #{user.name} succesfully set")
  end

  defp password_get(prompt) do
    Mix.Tasks.Hex.password_get(prompt)
    |> String.replace_trailing("\n", "")
  end

  defp er_ex(msg) do
    IO.puts(IO.ANSI.format([:red, msg]))
    exit(:error)
  end

  defp assert_match(p1, p2) do
    if p1 != p2, do: er_ex("Input mismatch")
  end

  defp assert_length(pass) do
    if String.length(pass) < @min_pass_length,
      do: er_ex("Password should be at least #{@min_pass_length} chars length")
  end
end
