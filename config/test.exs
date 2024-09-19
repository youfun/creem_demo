import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :creem_demo, CreemDemo.Repo,
    database: Path.expand("../creem_demo_test.db", Path.dirname(__ENV__.file)),
    pool_size: 5,
    stacktrace: true,
    show_sensitive_data_on_connection_error: true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :creem_demo, CreemDemoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "DSxy/V34AUe54IyAj57OWKGJXybv5lNab3fnIyMLlER8R01mv8Rhmw9HfRyLHjbS",
  server: false

# In test we don't send emails.
config :creem_demo, CreemDemo.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
