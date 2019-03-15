# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :among, AmongWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "d9IKM91aXJkRy5MESHxW2EPol2BNSMTPQMiwweiaenbsjUnurDuAmz+WrnogygKX",
  render_errors: [view: AmongWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Among.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
     signing_salt: System.get_env("LIVEVIEW_SECRET_SALT") || "NnR5kT3XBKIdzuACEw590/+0mkfdpkRv"
   ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine],
  json_library: Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
