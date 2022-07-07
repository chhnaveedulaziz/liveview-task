defmodule FavRepos.HomeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FavRepos.Home` context.
  """

  @doc """
  Generate a favorite.
  """
  def favorite_fixture(attrs \\ %{}) do
    {:ok, favorite} =
      attrs
      |> Enum.into(%{})
      |> FavRepos.Home.createfav_repo()

    favorite
  end
end
