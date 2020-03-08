defmodule PlateslateWeb.Schema.MenuTypes do
  use Absinthe.Schema.Notation

  @desc "A single available MenuItem"
  object :menu_item do
    interfaces([:search_result])
    @desc "The MenuItem's ID"
    field :id, :id
    @desc "The MenuItem's name"
    field :name, :string
    @desc "The MenuItem's optional description"
    field :description, :string
    @desc "The MenuItem's price"
    field :price, :float
    @desc "The MenuItem's added_on date"
    field :added_on, :date
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

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
  end

  interface :search_result do
    field :name, :string

    resolve_type(fn
      %Plateslate.Menu.Item{}, _ -> :menu_item
      %Plateslate.Menu.Category{}, _ -> :category
      _, _ -> nil
    end)
  end
end
