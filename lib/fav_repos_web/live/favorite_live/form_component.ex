defmodule FavReposWeb.FavoriteLive.FormComponent do
  use FavReposWeb, :live_component

  alias FavRepos.Home

  @impl true
  def update(%{favorite_repos: favorite_repos} = assigns, socket) do
    changeset = Home.change_favorite(favorite_repos)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"favorite_repos" => favorite_params}, socket) do
    changeset =
      socket.assigns.favorite_repos
      |> Home.change_favorite(favorite_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"favorite_repos" => favorite_params}, socket) do
    save_favorite(socket, socket.assigns.action, favorite_params)
  end

  defp save_favorite(socket, :edit, favorite_params) do
    case Home.update_favorite(socket.assigns.favorite_repos, favorite_params) do
      {:ok, _favorite} ->
        {:noreply,
         socket
         |> put_flash(:info, "Favorite updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_favorite(socket, :new, favorite_params) do
    case Home.create_favorite(favorite_params) do
      {:ok, _favorite} ->
        {:noreply,
         socket
         |> put_flash(:info, "Favorite created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
