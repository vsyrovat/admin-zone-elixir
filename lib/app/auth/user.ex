defmodule App.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :is_admin, :boolean, default: false
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :password_recovery_key, :string

    timestamps()
  end

  @required ~w(email)a
  @optional ~w(name is_admin password_recovery_key)a

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> cast_password(attrs)
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  defp cast_password(changeset, attrs) do
    changeset
    |> cast(attrs, [:password], [])
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        change(changeset, password_hash: Bcrypt.hash_pwd_salt(password), password: nil)

      _ ->
        changeset
    end
  end

  defdelegate checkpwd(pass, hash), to: Bcrypt, as: :verify_pass
  defdelegate dummy_checkpwd(), to: Bcrypt, as: :no_user_verify
end
