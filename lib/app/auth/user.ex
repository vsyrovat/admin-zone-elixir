defmodule App.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  defmodule Guest do
    defstruct name: nil
  end

  schema "users" do
    field :email, :string
    field :is_admin, :boolean, default: false
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @required ~w(email)a
  @optional ~w(name is_admin)a

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
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
