use Mix.Config

# Configure your database
config :yellr, Yellr.Repo,
  database: "yellr_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :yellr, YellrWeb.Endpoint,
  http: [port: 4002],
  server: false

config :yellr, Oban, repo: Yellr.Repo, crontab: false, queues: false, prune: :disabled

# Print only warnings and errors during test
config :logger, level: :warn