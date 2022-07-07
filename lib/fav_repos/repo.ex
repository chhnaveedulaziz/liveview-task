defmodule FavRepos.Repo do
  use Ecto.Repo,
    otp_app: :fav_repos,
    adapter: Ecto.Adapters.Postgres
end
