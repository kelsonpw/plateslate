defmodule PlateslateWeb.Schema.CategoryTypes do
  use Absinthe.Schema.Notation
  alias PlateslateWeb.Resolvers

  @desc "A single category"
  object :category do
    interfaces([:search_result])
    @desc "The MenuItem's ID"
    field :id, :id
    @desc "The MenuItem's name"
    field :name, :string
    @desc "The MenuItem's optional description"
    field :description, :string

    field :items, list_of(:menu_item) do
      resolve(&Resolvers.Menu.items_for_category/3)
    end
  end

  @desc "Filtering options for categories"
  input_object :category_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
  end
end
