defmodule App.Repo.Migrations.AddPasswordRecoveryKeyToUsers do
  use Ecto.Migration

  def up do
    execute """
    ALTER TABLE users ADD COLUMN password_recovery_key VARCHAR(100) DEFAULT NULL
    """
  end

  def down do
    execute """
    ALTER TABLE users DROP COLUMN password_recovery_key
    """
  end
end
