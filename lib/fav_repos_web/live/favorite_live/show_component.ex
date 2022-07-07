defmodule FavReposWeb.FavoriteLive.ShowComponent do
  use FavReposWeb, :live_component

  alias FavRepos.Home

  @impl true
  def update(%{fav_repo: fav_repo} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:fav_repo, fav_repo)}
  end

  def handle_event("cancel", _, socket) do
    {:noreply,
     push_redirect(socket, to: Routes.favorite_index_path(socket, :index))}
  end
end
