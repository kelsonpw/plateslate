defmodule PlateslateWeb.Schema do
  use Absinthe.Schema
  alias PlateslateWeb.Resolvers
  alias __MODULE__.{MenuTypes, CategoryTypes}

  import_types(MenuTypes)
  import_types(CategoryTypes)

  query do
    @desc "The list of available Menu Items!"
    field :menu_items, list_of(:menu_item) do
      arg(:filter, :menu_item_filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end

    field :categories, list_of(:category) do
      arg(:filter, :category_filter)
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.categories/3)
    end

    field :search, list_of(:search_result) do
      arg(:matching, non_null(:string))
      resolve(&Resolvers.Menu.search/3)
    end
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  scalar :date do
    parse(fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
           {:ok, date} <- Date.from_iso8601(value) do
        {:ok, date}
      else
        _ -> :error
      end
    end)

    serialize(&Date.to_iso8601(&1))
  end
end
