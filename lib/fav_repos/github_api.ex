defmodule FavRepos.GitHubApi do

  alias FavRepos.HTTP

  @base_url "https://api.github.com/search/repositories"
  @expected_fields ~w(name full_name description private html_url)
  @sort "stargazers"
  @order "asc"
  @per_page "2"


end
