# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%App.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias App.Auth

Auth.create_user!(%{email: "admin@app", is_admin: true, name: "Admin", password: "admin123"})
Auth.create_user!(%{email: "user@app", is_admin: false, name: "User", password: "user123"})
