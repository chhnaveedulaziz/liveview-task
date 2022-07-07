defmodule FavRepos.Home do
  @moduledoc """
  The Home context.
  """

  import Ecto.Query, warn: false
  alias FavRepos.Repo
  alias FavRepos.GitHubApi
  alias FavRepos.Home.FavoriteRepo

  @doc """
  Returns the list of favorites.

  ## Examples

      iex> list_favorites()
      [%FavoriteRepo{}, ...]

  """
  def list_favorites do
    Repo.all(FavoriteRepo)
  end

  @doc """
  Gets a single favorite_repo.

  Raises `Ecto.NoResultsError` if the FavoriteRepo does not exist.

  ## Examples

      iex> get_favorite!(123)
      %FavoriteRepo{}

      iex> get_favorite!(456)
      ** (Ecto.NoResultsError)

  """
  def get_favorite!(id), do: Repo.get!(FavoriteRepo, id)

  @doc """
  Creates a favorite_repo.

  ## Examples

      iex> create_favorite(%{field: value})
      {:ok, %FavoriteRepo{}}

      iex> create_favorite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_favorite(attrs \\ %{}) do
    %FavoriteRepo{}
    |> FavoriteRepo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a favorite_repo.

  ## Examples

      iex> update_favorite(favorite_repo, %{field: new_value})
      {:ok, %FavoriteRepo{}}

      iex> update_favorite(favorite_repo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_favorite(%FavoriteRepo{} = favorite_repo, attrs) do
    favorite_repo
    |> FavoriteRepo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a favorite_repo.

  ## Examples

      iex> delete_favorite(favorite_repo)
      {:ok, %FavoriteRepo{}}

      iex> delete_favorite(favorite_repo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_favorite(%FavoriteRepo{} = favorite_repo) do
    Repo.delete(favorite_repo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking favorite_repo changes.

  ## Examples

      iex> change_favorite(favorite_repo)
      %Ecto.Changeset{data: %FavoriteRepo{}}

  """
  def change_favorite(%FavoriteRepo{} = favorite_repo, attrs \\ %{}) do
    FavoriteRepo.changeset(favorite_repo, attrs)
  end

  def fetch_github_repos(q), do: GitHubApi.search_repositories(q)
end
