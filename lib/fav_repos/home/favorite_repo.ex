defmodule FavRepos.Home.FavoriteRepo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "favorite_repos" do
    field :name, :string
    field :full_name, :string
    field :repo_url, :string
    field :description, :string
    field :private, :boolean

    timestamps()
  end

  @doc false
  def changeset(favorite_repo, attrs) do
    favorite_repo
    |> cast(attrs, [])
    |> validate_required([])
  end
end
