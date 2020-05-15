defmodule Mix.Tasks.CheckAdminPassword do
  use Mix.Task
  alias App.Auth.User
  alias App.Auth

  def run(_) do
    opts = [mode: :temporary, log: false, log_sql: false]
    {:ok, admins, _apps} = Ecto.Migrator.with_repo(App.Repo, fn _repo -> Auth.find_admins() end, opts)

    pass = password_get("Type Admin password for check:")

    for user <- admins do
      msg = if password_valid?(user, pass), do: "MATCH", else: "DOES NOT match"
      IO.puts(user.name <> ": password " <> msg)
    end
  end

  defp password_get(prompt) do
    Mix.Tasks.Hex.password_get(prompt)
    |> String.replace_trailing("\n", "")
  end

  defp password_valid?(%User{} = user, pass) do
    User.checkpwd(pass, user.password_hash)
  end
end
