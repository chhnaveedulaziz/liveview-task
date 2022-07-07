defmodule FavRepos.GitHubApi do

  alias FavRepos.HTTP

  @base_url "https://api.github.com/search/repositories"
  @expected_fields ~w(name full_name description private html_url)
  @sort "stargazers"
  @order "asc"
  @per_page "2"

  def search_repositories(q) do
    query = "?"<>"q="<>q<>"&sort="<> @sort <> "&order=" <> @order <> "&per_page=" <> @per_page
    url = @base_url <> query
    IO.inspect(url, label: "URL ---------------->")
    response =
      HTTP.get(url)
      |> process_response_body()
  end

  def process_response_body(body) do
    IO.inspect @expected_fields
    body
    |> Poison.decode!
    |> Map.get("items")
    |> Enum.each(fn x -> Map.take(x, @expected_fields) |> IO.inspect() end)
    |> IO.inspect(label: "Results ---------------->")
  end
end
