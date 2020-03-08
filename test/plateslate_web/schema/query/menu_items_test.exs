defmodule PlateslateWeb.Schema.Query.MenuItemsTest do
  use PlateslateWeb.ConnCase, async: true

  setup do
    Plateslate.Seeds.run()
  end

  test "menuItems field returns menu items" do
    query = """
    {
      menuItems {
        name
      }
    }
    """

    conn = build_conn()
    conn = get(conn, "/api", query: query)

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
    query = """
    {
      menuItems(matching: "Vada Pav") {
        name
      }
    }
    """

    conn = build_conn()
    conn = get(conn, "/api", query: query)

    expected_response = %{
      "data" => %{
        "menuItems" => [
          %{"name" => "Vada Pav"}
        ]
      }
    }

    assert(json_response(conn, 200) == expected_response)
  end
end
