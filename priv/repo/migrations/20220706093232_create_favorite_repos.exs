defmodule FavRepos.Repo.Migrations.CreateFavoriteRepos do
  use Ecto.Migration

  def change do
    create table(:favorite_repos) do
      add :name, :string, null: false
      add :full_name, :string, null: false
      add :repo_url, :string, null: false
      add :description, :string
      add :private, :boolean

      timestamps()
    end
  end
end
