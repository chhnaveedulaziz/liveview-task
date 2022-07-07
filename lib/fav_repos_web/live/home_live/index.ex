defmodule FavReposWeb.HomeLive.Index do
  use FavReposWeb, :live_view

  alias FavRepos.Home

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    results = Home.fetch_github_repos(search)

    socket =
      socket
      |> assign(:search_results, results)

    {:noreply, socket}
  end
end
