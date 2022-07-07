defmodule FavRepos.Home.SearchResult do
  use Ecto.Schema
  import Ecto.Changeset

  schema "search_results" do
    field :name, :string
    field :full_name, :string
    field :html_url, :string
    field :description, :string
    field :private, :boolean

    timestamps()
  end

  @doc false
  def changeset(search_result, attrs) when is_list(attrs) do
    attrs
    |> Enum.map(fn x -> changeset(search_result, x) end)
  end

  @doc false
  def changeset(search_result, attrs) do
    search_result
    |> cast(attrs, [:name, :full_name, :html_url, :private, :description])
    |> validate_required([:name, :full_name, :html_url, :private])
    |> unique_constraint(:html_url)
  end
end
