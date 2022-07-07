defmodule FavRepos.HomeTest do
  use FavRepos.DataCase

  alias FavRepos.Home

  describe "favorites" do
    alias FavRepos.Home.Favorite

    import FavRepos.HomeFixtures

    @invalid_attrs %{}

    test "listfav_repos/0 returns all favorites" do
      favorite = favorite_fixture()
      assert Home.listfav_repos() == [favorite]
    end

    test "getfav_repo!/1 returns the favorite with given id" do
      favorite = favorite_fixture()
      assert Home.getfav_repo!(favorite.id) == favorite
    end

    test "createfav_repo/1 with valid data creates a favorite" do
      valid_attrs = %{}

      assert {:ok, %Favorite{} = favorite} = Home.createfav_repo(valid_attrs)
    end

    test "createfav_repo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Home.createfav_repo(@invalid_attrs)
    end

    test "updatefav_repo/2 with valid data updates the favorite" do
      favorite = favorite_fixture()
      update_attrs = %{}

      assert {:ok, %Favorite{} = favorite} = Home.updatefav_repo(favorite, update_attrs)
    end

    test "updatefav_repo/2 with invalid data returns error changeset" do
      favorite = favorite_fixture()
      assert {:error, %Ecto.Changeset{}} = Home.updatefav_repo(favorite, @invalid_attrs)
      assert favorite == Home.getfav_repo!(favorite.id)
    end

    test "deletefav_repo/1 deletes the favorite" do
      favorite = favorite_fixture()
      assert {:ok, %Favorite{}} = Home.deletefav_repo(favorite)
      assert_raise Ecto.NoResultsError, fn -> Home.getfav_repo!(favorite.id) end
    end

    test "changefav_repo/1 returns a favorite changeset" do
      favorite = favorite_fixture()
      assert %Ecto.Changeset{} = Home.changefav_repo(favorite)
    end
  end
end
