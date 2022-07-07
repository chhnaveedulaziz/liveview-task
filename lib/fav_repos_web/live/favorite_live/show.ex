defmodule FavReposWeb.FavoriteLive.Show do
  use FavReposWeb, :live_component

  alias FavRepos.Home

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:fav_repo, Home.get_fav_repo!(id))}
  end

  defp page_title(:show), do: "Show Favorite"
end
