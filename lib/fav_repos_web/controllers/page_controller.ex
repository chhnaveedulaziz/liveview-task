defmodule FavReposWeb.PageController do
  use FavReposWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
