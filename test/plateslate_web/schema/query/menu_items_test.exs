defmodule PlateslateWeb.Schema.Query.MenuItemsTest do
  use PlateslateWeb.ConnCase, async: true

  setup do
    Plateslate.Seeds.run()
  end

  test "menuItems field returns menu items" do
    conn =
      build_conn()
      |> get("/api", query: menu_items_query())

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
    conn =
      build_conn()
      |> get("/api", query: menu_items_query(%{matching: "\"Pav\""}))

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
    conn =
      build_conn()
      |> get("/api", query: menu_items_query(%{matching: "\"ZZZxxx\""}))

    expected_response = %{
      "data" => %{
        "menuItems" => []
      }
    }

    assert(json_response(conn, 200) == expected_response)
  end

  test "menuItems field returns errors when using invalid search value" do
    conn =
      build_conn()
      |> get("/api", query: menu_items_query(%{matching: 123}))

    assert(%{"errors" => [%{"message" => message}]} = json_response(conn, 200))
    assert(message == "Argument \"matching\" has invalid value 123.")
  end

  defp menu_items_query do
    """
    {
      menuItems {
        name
      }
    }
    """
  end

  defp menu_items_query(%{matching: name}) do
    """
    {
      menuItems(matching: #{name}) {
        name
      }
    }
    """
  end
end
