defmodule Plateslate.Menu.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plateslate.Menu.Item
  alias Plateslate.Menu.Category

  schema "items" do
    field(:added_on, :date)
    field(:description, :string)
    field(:name, :string)
    field(:price, :decimal)

    belongs_to(:category, Plateslate.Menu.Category)

    many_to_many(:tags, Plateslate.Menu.ItemTag, join_through: "item_taggings")

    timestamps()
  end

  @doc false
  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:name, :description, :price, :added_on])
    |> validate_required([:name, :price])
    |> foreign_key_constraint(:category)
    |> unique_constraint(:name)
    |> cast_assoc(:category, required: false, with: &Category.changeset/2)
  end
end
