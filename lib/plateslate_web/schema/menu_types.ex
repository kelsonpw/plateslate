defmodule PlateslateWeb.Schema.MenuTypes do
  use Absinthe.Schema.Notation

  object :menu_item_result do
    field :menu_item, :menu_item
    field :errors, list_of(:input_error)
  end

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
    field :price, :decimal
    @desc "The MenuItem's added_on date"
    field :added_on, :date

    @desc "The MenuItem's category"
    field :category, :category
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
    field :priced_above, :decimal

    @desc "Price below a value"
    field :priced_below, :decimal

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
  end

  @desc "Menu item input for item creation"
  input_object :menu_item_input do
    field :name, non_null(:string)
    field :description, :string
    field :price, non_null(:decimal)
    field :category_id, non_null(:id)
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
