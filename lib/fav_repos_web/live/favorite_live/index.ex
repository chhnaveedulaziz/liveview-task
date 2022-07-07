defmodule FavReposWeb.FavoriteLive.Index do
  use FavReposWeb, :live_view

  alias FavRepos.Home
  alias FavRepos.Home.FavoriteRepo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :favorite_repos, list_favorites())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Favorite")
    |> assign(:favorite_repos, Home.get_favorite!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Favorite")
    |> assign(:favorite_repos, %FavoriteRepo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Favorites")
    |> assign(:favorite_repos, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    favorite_repos = Home.get_favorite!(id)
    {:ok, _} = Home.delete_favorite(favorite_repos)

    {:noreply, assign(socket, :favorite_repos, list_favorites())}
  end

  defp list_favorites do
    Home.list_favorites()
  end
end
