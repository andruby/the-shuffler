defmodule Shuffler.Repo do
  use Ecto.Repo, otp_app: :shuffler, adapter: Ecto.Adapters.Postgres
end
