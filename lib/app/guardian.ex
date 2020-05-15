defmodule App.Guardian do
  use Guardian, otp_app: :app

  alias App.Repo
  alias App.Auth.User

  @impl Guardian
  def subject_for_token(user = %User{}, _claims) do
    sub = %{id: user.id, passhash: user.password_hash}
    {:ok, Jason.encode!(sub)}
  end

  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  @impl Guardian
  def resource_from_claims(%{"sub" => sub}) do
    with {:ok, id, passhash} <- extract_sub(sub),
         {:ok, user} <- get_user(id),
         :ok <- check_passhash(user, passhash) do
      {:ok, user}
    end
  end

  def resource_from_claims(_), do: {:error, "Unknown resource type"}

  defp extract_sub(sub) do
    case Jason.decode(sub) do
      {:ok, %{"id" => id, "passhash" => passhash}} -> {:ok, id, passhash}
      _ -> {:error, "Unknown resource type"}
    end
  end

  defp get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, "No such user"}
      user -> {:ok, user}
    end
  end

  defp check_passhash(user, passhash) do
    if user.password_hash == passhash,
      do: :ok,
      else: {:error, "Password invalid"}
  end
end
