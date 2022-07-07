defmodule FavRepos.Home do
  @moduledoc """
  The Home context.
  """

  import Ecto.Query, warn: false

  alias FavRepos.Repo
  alias FavRepos.HTTP
  alias FavRepos.GitHubApi
  alias FavRepos.Home.FavRepo
  alias FavRepos.Home.SearchResult

  @github_base_url "https://api.github.com/search/repositories"
  @expected_fields ~w(name full_name description private html_url)
  @sort "stargazers"
  @order "asc"
  @per_page "20"

  @doc """
  Returns the list of search_results.

  ## Examples

      iex> list_search_results()
      [%SearchResult{}, ...]

  """
  def list_search_results do
    Repo.all(SearchResult)
  end

  @doc """
  Gets a single search_result.

  Raises `Ecto.NoResultsError` if the SearchResult does not exist.

  ## Examples

      iex> get_search_result!(123)
      %SearchResult{}

      iex> get_search_result!(456)
      ** (Ecto.NoResultsError)

  """
  def get_search_result!(id), do: Repo.get!(SearchResult, id)

  def get_search_result_by_url!(url), do: Repo.get_by!(SearchResult, [html_url: url])

  @doc """
  Creates a search_result.

  ## Examples

      iex> create_search_result(%{field: value})
      {:ok, %SearchResult{}}

      iex> create_search_result(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_search_result(attrs \\ %{}) do
    %SearchResult{}
    |> SearchResult.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a search_result.

  ## Examples

      iex> update_search_result(search_result, %{field: new_value})
      {:ok, %SearchResult{}}

      iex> update_search_result(search_result, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_search_result(%SearchResult{} = search_result, attrs) do
    search_result
    |> SearchResult.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a search_result.

  ## Examples

      iex> delete_search_result(search_result)
      {:ok, %SearchResult{}}

      iex> delete_search_result(search_result)
      {:error, %Ecto.Changeset{}}

  """
  def delete_search_result(%SearchResult{} = search_result) do
    Repo.delete(search_result)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking search_result changes.

  ## Examples

      iex> change_search_result(search_result)
      %Ecto.Changeset{data: %SearchResult{}}

  """
  def change_search_result(%SearchResult{} = search_result, attrs \\ %{}) do
    SearchResult.changeset(search_result, attrs)
  end

  @doc """
  Returns the list of fav_repos.

  ## Examples

      iex> list_fav_repos()
      [%FavRepo{}, ...]

  """
  def list_fav_repos do
    FavRepo
    |> Repo.all()
    |> Repo.preload([:user, :search_result])
  end

  def list_fav_repos(user) do
    FavRepo
    |> where([repo], repo.user_id == ^user.id)
    |> Repo.all()
    |> Repo.preload([:user, :search_result])
  end

  def count_fav_repos(user) do
    Repo.one(from fav in FavRepo, select: count(fav.id), where: fav.user_id == ^user.id)
  end

  @doc """
  Gets a single fav_repo.

  Raises `Ecto.NoResultsError` if the FavRepo does not exist.

  ## Examples

      iex> get_fav_repo!(123)
      %FavRepo{}

      iex> get_fav_repo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fav_repo!(id), do: Repo.get!(FavRepo, id) |> Repo.preload([:user, :search_result])

  @doc """
  Creates a fav_repo.

  ## Examples

      iex> create_fav_repo(%{field: value})
      {:ok, %FavRepo{}}

      iex> create_fav_repo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fav_repo(attrs \\ %{}) do
    %FavRepo{}
    |> FavRepo.changeset(attrs)
    |> Repo.insert()
    |> IO.inspect()

  end

  @doc """
  Updates a fav_repo.

  ## Examples

      iex> update_fav_repo(fav_repo, %{field: new_value})
      {:ok, %FavRepo{}}

      iex> update_fav_repo(fav_repo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fav_repo(%FavRepo{} = fav_repo, attrs) do
    fav_repo
    |> FavRepo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fav_repo.

  ## Examples

      iex> delete_fav_repo(fav_repo)
      {:ok, %FavRepo{}}

      iex> delete_fav_repo(fav_repo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fav_repo(%FavRepo{} = fav_repo) do
    Repo.delete(fav_repo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fav_repo changes.

  ## Examples

      iex> change_fav_repo(fav_repo)
      %Ecto.Changeset{data: %FavRepo{}}

  """
  def change_fav_repo(%FavRepo{} = fav_repo, attrs \\ %{}) do
    FavRepo.changeset(fav_repo, attrs)
  end

  def fetch_and_save_github_repos(q) do
    [body: body, total_count: total_count] = search_results =
      q
      |> search_repositories()
      |> process_response_body()

    Repo.insert_all(SearchResult, body, on_conflict: :nothing) |> IO.inspect(label: "Inserted")
    search_results
  end

  defp search_repositories(q) do
    query =
      "?" <> "q=" <> q <> "&sort=" <> @sort <> "&order=" <> @order <> "&per_page=" <> @per_page

    url = @github_base_url <> query
    HTTP.get(url)
  end

  defp process_response_body(body) do
    body = Poison.decode!(body)
    total_count = Map.get(body, "total_count")
    results =
      body
      |> Map.get("items")
      |> Enum.map(fn x ->
        Map.take(x, @expected_fields)
        |> convert_map_keys_to_atoms()
        |> Map.merge(%{
          inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
          updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
        })
      end)

    [body: results, total_count: total_count]
  end

  defp convert_map_keys_to_atoms(item) when is_map(item) do
    item
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
  end

  defp convert_map_keys_to_atoms(item), do: item
end
