defmodule RetroApp.Repo do
  use Ecto.Repo,
    otp_app: :retro_app,
    adapter: Ecto.Adapters.SQLite3
end
