use Mix.Config

config :issues, github_url: "https://api.github.com"
config :tesla, adapter: Tesla.Adapter.Mint

#import_config "#{Mix.env()}.exs"
