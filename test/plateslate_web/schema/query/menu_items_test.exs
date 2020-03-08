defmodule PlateslateWeb.Schema.Query.MenuItemsTest do
  use PlateslateWeb.ConnCase, async: true

  setup do
    Plateslate.Seeds.run()
  end

  @menu_items_query """
  {
    menuItems {
      name
    }
  }
  """

  @search_menu_items_query """
  query ($term: String) {
    menuItems(matching: $term) {
      name
    }
  }
  """

  test "menuItems field returns menu items" do
    conn =
      build_conn()
      |> get("/api", query: @menu_items_query)

    expected_response = %{
      "data" => %{
        "menuItems" => [
          %{"name" => "Reuben"},
          %{"name" => "Croque Monsieur"},
          %{"name" => "Muffuletta"},
          %{"name" => "Bánh mì"},
          %{"name" => "Vada Pav"},
          %{"name" => "French Fries"},
          %{"name" => "Papadum"},
          %{"name" => "Pasta Salad"},
          %{"name" => "Water"},
          %{"name" => "Soft Drink"},
          %{"name" => "Lemonade"},
          %{"name" => "Masala Chai"},
          %{"name" => "Vanilla Milkshake"},
          %{"name" => "Chocolate Milkshake"}
        ]
      }
    }

    assert(json_response(conn, 200) == expected_response)
  end

  test "menuItems field returns menu items filtered by name" do
    variables = %{"term" => "Pav"}

    conn =
      build_conn()
      |> get("/api", query: @search_menu_items_query, variables: variables)

    expected_response = %{
      "data" => %{
        "menuItems" => [
          %{"name" => "Vada Pav"}
        ]
      }
    }

    assert(json_response(conn, 200) == expected_response)
  end

  test "menuItems field returns empty menu items if filter name does not match" do
    variables = %{"term" => "zzzxxX"}

    conn =
      build_conn()
      |> get("/api", query: @search_menu_items_query, variables: variables)

    expected_response = %{
      "data" => %{
        "menuItems" => []
      }
    }

    assert(json_response(conn, 200) == expected_response)
  end

  test "menuItems field returns errors when using invalid search value" do
    variables = %{"term" => 123}

    conn =
      build_conn()
      |> get("/api", query: @search_menu_items_query, variables: variables)

    assert(%{"errors" => [%{"message" => message}]} = json_response(conn, 200))
    assert(message == "Argument \"matching\" has invalid value $term.")
  end
end
