import Config

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
cool_text = System.fetch_env!("COOL_TEXT")
application_port = System.fetch_env!("APP_PORT")

config :hello_elixir, HelloElixirWeb.Endpoint,
  http: [:inet6, port: String.to_integer(application_port)],
  secret_key_base: secret_key_base

config :hello_elixir,
  cool_text: cool_text

config :hello_elixir, HelloElixirWeb.Endpoint, server: true
