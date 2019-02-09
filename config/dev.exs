use Mix.Config

config :shuffler, Shuffler.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "shuffler_dev",
  username: System.get_env("USER"),
  password: "",
  hostname: "localhost",
  pool_size: 2
