defmodule FavRepos.HomeTest do
  use FavRepos.DataCase

  alias FavRepos.Home

  describe "favorites" do
    alias FavRepos.Home.Favorite

    import FavRepos.HomeFixtures

    @invalid_attrs %{}

    test "list_favorites/0 returns all favorites" do
      favorite = favorite_fixture()
      assert Home.list_favorites() == [favorite]
    end

    test "get_favorite!/1 returns the favorite with given id" do
      favorite = favorite_fixture()
      assert Home.get_favorite!(favorite.id) == favorite
    end

    test "create_favorite/1 with valid data creates a favorite" do
      valid_attrs = %{}

      assert {:ok, %Favorite{} = favorite} = Home.create_favorite(valid_attrs)
    end

    test "create_favorite/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Home.create_favorite(@invalid_attrs)
    end

    test "update_favorite/2 with valid data updates the favorite" do
      favorite = favorite_fixture()
      update_attrs = %{}

      assert {:ok, %Favorite{} = favorite} = Home.update_favorite(favorite, update_attrs)
    end

    test "update_favorite/2 with invalid data returns error changeset" do
      favorite = favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = Home.update_favorite(favorite, @invalid_attrs)
      assert favorite == Home.get_favorite!(favorite.id)
    end

    test "delete_favorite/1 deletes the favorite" do
      favorite = favorite_fixture()
      assert {:ok, %Favorite{}} = Home.delete_favorite(favorite)
      assert_raise Ecto.NoResultsError, fn -> Home.get_favorite!(favorite.id) end
    end

    test "change_favorite/1 returns a favorite changeset" do
      favorite = favorite_fixture()
      assert %Ecto.Changeset{} = Home.change_favorite(favorite)
    end
  end
end
