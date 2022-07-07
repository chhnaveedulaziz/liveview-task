defmodule FavRepos.Home.FavRepo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fav_repos" do
    belongs_to :user, FavRepos.Accounts.User
    belongs_to :search_result, FavRepos.Home.SearchResult

    timestamps()
  end

  @doc false
  def changeset(fav_repo, attrs) do
    fav_repo
    |> cast(attrs, [:user_id, :search_result_id])
    |> validate_required([:user_id, :search_result_id])
  end
end
