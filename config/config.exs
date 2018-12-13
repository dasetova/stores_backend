# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :store_admin,
  ecto_repos: [StoreAdmin.Repo]

# Configures the endpoint
config :store_admin, StoreAdminWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hrAsLRHpZ+mam51PnqlEk9zGCUbfAC06Y1nLWphUTWspF9WRW4ubuZ923j66+gm0",
  render_errors: [view: StoreAdminWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: StoreAdmin.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
