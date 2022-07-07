defmodule FavReposWeb.FavoriteLive.Index do
  use FavReposWeb, :live_view

  alias FavRepos.Home
  alias FavRepos.Home.FavRepo

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session, __MODULE__, [:handle_params, :handle_event])
      |> assign(:show_modal, false)

    {:ok, assign(socket, :fav_repos, list_fav_repos(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, gettext("Edit Contact"))
    |> assign(:fav_repo, Home.get_fav_repo!(id))
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :fav_repos, list_fav_repos(socket.assigns.current_user))
  end

  # def handle_event("toggle-modal", %{"fav_repo_id" => id}, socket) do

  # end

  @impl true
  def handle_event("show", %{"fav_repo_id" => id}, socket) do
    socket = assign(socket, :show_modal, true)
    {:noreply,
     push_patch(socket, to: Routes.favorite_index_path(socket, :show, id))}
  end

  @impl true
  def handle_event("remove", %{"fav_repo_id" => id}, socket) do
    socket =
      id
      |> Home.get_fav_repo!()
      |> Home.delete_fav_repo()
      |> case do
        {:ok, _fav_repo} ->
          socket
          |> put_flash(:info, "removed successfully")
          |> push_redirect(to: Routes.favorite_index_path(socket, :index))

        {:error, _changeset} ->
          socket
          |> put_flash(:error, "not removed! something went wrong")
          |> push_patch(to: Routes.favorite_index_path(socket, :index))
      end

    {:noreply, socket}
  end

  defp list_fav_repos(user) do
    Home.list_fav_repos(user)
  end
end
