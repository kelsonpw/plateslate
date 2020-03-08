defmodule PlateslateWeb.Schema do
  use Absinthe.Schema
  alias Plateslate.{Menu, Repo}
  alias PlateslateWeb.Resolvers

  query do
    @desc "The list of available Menu Items!"
    field :menu_items, list_of(:menu_item) do
      arg(:filter, :menu_item_filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  @desc "A single available MenuItem"
  object :menu_item do
    @desc "The MenuItem's ID"
    field :id, :id
    @desc "The MenuItem's name"
    field :name, :string
    @desc "The MenuItem's optional description"
    field :description, :string
    @desc "The MenuItem's price"
    field :price, :float
    @desc "The MenuItem's added_on date"
    field :added_on, :string
  end

  @desc "Filtering options for the menu item list"
  input_object :menu_item_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Matching a category name"
    field :category, :string

    @desc "Matching a tag"
    field :tag, :string

    @desc "Price above a value"
    field :priced_above, :float

    @desc "Price below a value"
    field :priced_below, :float
  end
end
