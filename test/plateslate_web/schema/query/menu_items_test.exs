defmodule PlateslateWeb.Schema.Query.MenuItemsTest do
  use PlateslateWeb.ConnCase, async: true

  setup do
    Plateslate.Seeds.run()
  end

  describe "menu_items_query" do
    @menu_items_query """
    {
      menuItems {
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
            %{"name" => "Bánh mì"},
            %{"name" => "Chocolate Milkshake"},
            %{"name" => "Croque Monsieur"},
            %{"name" => "French Fries"},
            %{"name" => "Lemonade"},
            %{"name" => "Masala Chai"},
            %{"name" => "Muffuletta"},
            %{"name" => "Papadum"},
            %{"name" => "Pasta Salad"},
            %{"name" => "Reuben"},
            %{"name" => "Soft Drink"},
            %{"name" => "Vada Pav"},
            %{"name" => "Vanilla Milkshake"},
            %{"name" => "Water"}
          ]
        }
      }

      assert(json_response(conn, 200) == expected_response)
    end
  end

  describe "filter_menu_items_query" do
    @search_menu_items_query """
    query ($term: String) {
      menuItems(filter: { name: $term }) {
        name
      }
    }
    """

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
      assert(message == "Argument \"filter\" has invalid value {name: $term}.\nIn field \"name\": Expected type \"String\", found $term.")
    end
  end

  describe "order_menu_items_query" do
    @order_menu_items_query_literal """
    {
      menuItems(order: DESC) {
        name
      }
    }
    """

    test "menuItems field returns items descending using literals" do
      conn =
        build_conn()
        |> get("/api", query: @order_menu_items_query_literal)

      assert(
        %{
          "data" => %{
            "menuItems" => [%{"name" => "Water"} | _]
          }
        } = json_response(conn, 200)
      )
    end

    @order_menu_items_query_variable """
    query ($order: SortOrder!){
      menuItems(order: $order) {
        name
      }
    }
    """

    test "menuItems field returns items descending using variables" do
      variables = %{order: "DESC"}

      conn =
        build_conn()
        |> get("/api", query: @order_menu_items_query_variable, variables: variables)

      assert(
        %{
          "data" => %{
            "menuItems" => [%{"name" => "Water"} | _]
          }
        } = json_response(conn, 200)
      )
    end

    test "menuItems field returns menuItems, filtering with a literal" do
      query = """
      {
        menuItems(filter: { category: "Sandwiches", tag: "Vegetarian"}) {
          name
        }
      }
      """

      conn =
        build_conn()
        |> get("/api", query: query)

      assert(
        %{
          "data" => %{
            "menuItems" => [
              %{"name" => "Vada Pav"}
            ]
          }
        } == json_response(conn, 200)
      )
    end

    test "menuItems field returns menuItems, filtering with a variable" do
      query = """
      query ($filter: MenuItemFilter!) {
        menuItems(filter: $filter) {
          name
        }
      }
      """

      variables = %{filter: %{"tag" => "Vegetarian", "category" => "Sandwiches"}}

      conn =
        build_conn()
        |> get("/api", query: query, variables: variables)

      assert(
        %{
          "data" => %{
            "menuItems" => [
              %{"name" => "Vada Pav"}
            ]
          }
        } == json_response(conn, 200)
      )
    end
  end
end
