defmodule Plateslate.Menu.ItemTag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plateslate.Menu.ItemTag

  schema "item_tags" do
    field(:description, :string)
    field(:name, :string, null: false)

    many_to_many(:items, Plateslate.Menu.Item, join_through: "item_taggings")

    timestamps()
  end

  @doc false
  def changeset(%ItemTag{} = item_tag, attrs) do
    item_tag
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
