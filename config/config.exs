# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :app,
  ecto_repos: [App.Repo]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mCgDJMaW18iD+rfG7ppEpr8CQ4270s8U8YCjyO51+DIcLoLKzaI3tbTT6WujgGfl",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "LDCW7pUv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :app, App.Guardian, issuer: "admin_zone_1"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
