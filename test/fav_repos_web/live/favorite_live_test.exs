defmodule FavReposWeb.FavoriteLiveTest do
  use FavReposWeb.ConnCase

  import Phoenix.LiveViewTest
  import FavRepos.HomeFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_favorite(_) do
    favorite = favorite_fixture()
    %{favorite: favorite}
  end

  describe "Index" do
    setup [:create_favorite]

    test "lists all favorites", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.favorite_index_path(conn, :index))

      assert html =~ "Listing Favorites"
    end

    test "saves new favorite", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.favorite_index_path(conn, :index))

      assert index_live |> element("a", "New Favorite") |> render_click() =~
               "New Favorite"

      assert_patch(index_live, Routes.favorite_index_path(conn, :new))

      assert index_live
             |> form("#favorite-form", favorite: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#favorite-form", favorite: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.favorite_index_path(conn, :index))

      assert html =~ "Favorite created successfully"
    end

    test "updates favorite in listing", %{conn: conn, favorite: favorite} do
      {:ok, index_live, _html} = live(conn, Routes.favorite_index_path(conn, :index))

      assert index_live |> element("#favorite-#{favorite.id} a", "Edit") |> render_click() =~
               "Edit Favorite"

      assert_patch(index_live, Routes.favorite_index_path(conn, :edit, favorite))

      assert index_live
             |> form("#favorite-form", favorite: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#favorite-form", favorite: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.favorite_index_path(conn, :index))

      assert html =~ "Favorite updated successfully"
    end

    test "deletes favorite in listing", %{conn: conn, favorite: favorite} do
      {:ok, index_live, _html} = live(conn, Routes.favorite_index_path(conn, :index))

      assert index_live |> element("#favorite-#{favorite.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#favorite-#{favorite.id}")
    end
  end

  describe "Show" do
    setup [:create_favorite]

    test "displays favorite", %{conn: conn, favorite: favorite} do
      {:ok, _show_live, html} = live(conn, Routes.favorite_show_path(conn, :show, favorite))

      assert html =~ "Show Favorite"
    end

    test "updates favorite within modal", %{conn: conn, favorite: favorite} do
      {:ok, show_live, _html} = live(conn, Routes.favorite_show_path(conn, :show, favorite))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Favorite"

      assert_patch(show_live, Routes.favorite_show_path(conn, :edit, favorite))

      assert show_live
             |> form("#favorite-form", favorite: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#favorite-form", favorite: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.favorite_show_path(conn, :show, favorite))

      assert html =~ "Favorite updated successfully"
    end
  end
end
