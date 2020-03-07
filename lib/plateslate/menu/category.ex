defmodule Plateslate.Menu.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Plateslate.Menu.Category

  schema "categories" do
    field(:description, :string)
    field(:name, :string)

    has_many(:items, Plateslate.Menu.Item)

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:description, :name])
    |> validate_required([:name])
  end
end
