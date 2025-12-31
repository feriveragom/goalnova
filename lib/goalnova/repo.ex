defmodule Goalnova.Repo do
  use Ecto.Repo,
    otp_app: :goalnova,
    adapter: Ecto.Adapters.Postgres
end
