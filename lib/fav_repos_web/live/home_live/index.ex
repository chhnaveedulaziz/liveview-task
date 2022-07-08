defmodule FavReposWeb.HomeLive.Index do
  use FavReposWeb, :live_view

  alias FavRepos.Home

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_defaults(session, __MODULE__, [:handle_params, :handle_event])
      |> assign(:search_results, [])
      |> assign(:current_page, nil)
      |> assign(:query, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"search" => %{"search" => query}}, socket) do
    [body: body, total_count: total_count] = Home.fetch_and_save_github_repos(query, 1)

    socket =
      socket
      |> assign(:search_results, body)
      |> assign(:total_count, total_count)
      |> assign(:current_page, 1)
      |> assign(:query, query)

    {:noreply, socket}
  end

  @impl true
  def handle_event("save", %{"repo_url" => html_url}, socket) do
    save_fav_repo(html_url, socket)
  end

  def handle_event("next", _, socket) do
    page = socket.assigns.current_page + 1
    [body: body, total_count: total_count] = Home.fetch_and_save_github_repos(socket.assigns.query, page)

    socket =
      socket
      |> assign(:search_results, body)
      |> assign(:total_count, total_count)
      |> assign(:current_page, page)

    {:noreply, socket}
  end

  def handle_event("previous", _, socket) do
    page = socket.assigns.current_page - 1
    [body: body, total_count: total_count] = Home.fetch_and_save_github_repos(socket.assigns.query, page)

    socket =
      socket
      |> assign(:search_results, body)
      |> assign(:total_count, total_count)
      |> assign(:current_page, page)

    {:noreply, socket}
  end

  defp save_fav_repo(url, socket) do
    %Home.SearchResult{id: search_id} = Home.get_search_result_by_url!(url)
    case Home.create_fav_repo(%{"search_result_id" => search_id, "user_id" => socket.assigns.current_user.id}) do
      {:ok, _fav_repo} ->
        {:noreply,
         socket
         |> put_flash(:info, gettext("Repo added to favorites successfully"))}

      {:error, %Ecto.Changeset{} = changeset} ->
        if Enum.any?(changeset.errors, &unique_constraint_error?/1) do
          {:noreply,
          socket
          |> put_flash(:info, gettext("Repo already added to favorites"))}
        else
          socket
          |> put_flash(:error, "Could not add to favorites")
          |> push_patch(to: Routes.home_index_path(socket, :index))
        end
    end
  end

  defp unique_constraint_error?({:user_id, {_, [constraint: :unique, constraint_name: _]}}), do: true
  defp unique_constraint_error?(_), do: false
end
