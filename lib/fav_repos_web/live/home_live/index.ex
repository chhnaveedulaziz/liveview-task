defmodule FavReposWeb.HomeLive.Index do
  use FavReposWeb, :live_view

  alias FavRepos.Home

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(socket, session, __MODULE__, [:handle_params, :handle_event])
    {:ok, assign(socket, :search_results, [])}
  end

  @impl true
  def handle_event("search", %{"search" => %{"search" => query}}, socket) do
    results = Home.fetch_and_save_github_repos(query)

    socket =
      socket
      |> assign(:search_results, results)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"repo_url" => html_url}, socket) do
    save_fav_repo(html_url, socket)
  end

  defp save_fav_repo(url, socket) do
    %Home.SearchResult{id: search_id} = Home.get_search_result_by_url!(url)
    case Home.create_fav_repo(%{"search_result_id" => search_id, "user_id" => socket.assigns.current_user.id}) do
      {:ok, _fav_repo} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Repo added to favorites successfully"))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
