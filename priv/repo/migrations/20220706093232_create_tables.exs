defmodule FavRepos.Repo.Migrations.CreateFavoriteRepos do
  use Ecto.Migration

  def change do
    create table(:search_results) do
      add :name, :string, null: false
      add :full_name, :string, null: false
      add :html_url, :string, null: false
      add :description, :string
      add :private, :boolean

      timestamps([:autogenerate])
    end

    create table(:fav_repos) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :search_result_id, references(:search_results, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:search_results, [:html_url])
    create unique_index(:fav_repos, [:user_id, :search_result_id])
  end
end
