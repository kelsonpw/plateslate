defmodule PlateslateWeb.Schema.Query.Categories do
  use PlateslateWeb.ConnCase, async: true

  setup do
    Plateslate.Seeds.run()
  end

  describe "categories query" do
    @categories_query """
    {
      categories {
        name
      }
    }
    """

    test "categories field returns categories" do
      conn =
        build_conn()
        |> get("/api", query: @categories_query)

      expected_response = %{
        "data" => %{
          "categories" => [
            %{"name" => "Beverages"},
            %{"name" => "Sandwiches"},
            %{"name" => "Sides"}
          ]
        }
      }

      assert(json_response(conn, 200) == expected_response)
    end
  end

  describe "filter_categories_query" do
    @filter_categories_query """
    query ($term: String) {
      categories(filter: { name: $term }) {
        name
      }
    }
    """

    test "categories field returns categories filtered by name" do
      variables = %{"term" => "Si"}

      conn =
        build_conn()
        |> get("/api", query: @filter_categories_query, variables: variables)

      expected_response = %{
        "data" => %{
          "categories" => [
            %{"name" => "Sides"}
          ]
        }
      }

      assert(json_response(conn, 200) == expected_response)
    end

    test "categories field returns empty categories if filter name does not match" do
      variables = %{"term" => "zxxz"}

      conn =
        build_conn()
        |> get("/api", query: @filter_categories_query, variables: variables)

      expected_response = %{
        "data" => %{
          "categories" => []
        }
      }

      assert(json_response(conn, 200) == expected_response)
    end

    test "categories field returns errors when using invalid search" do
      variables = %{"term" => 123}

      conn =
        build_conn()
        |> get("/api", query: @filter_categories_query, variables: variables)

      assert(%{"errors" => [%{"message" => message}]} = json_response(conn, 200))

      expected_message = """
      Argument "filter" has invalid value {name: $term}.
      In field "name": Expected type "String", found $term.\
      """

      assert(message == expected_message)
    end
  end

  describe "order_categories_query" do
    @order_categories_query """
    query ($order: SortOrder!) {
      categories(order: $order) {
        name
      }
    }
    """

    test "categories field returns categories descending using variables" do
      variables = %{order: "DESC"}

      conn =
        build_conn()
        |> get("/api", query: @order_categories_query, variables: variables)

      assert(
        %{
          "data" => %{
            "categories" => [%{"name" => "Sides"} | _]
          }
        } = json_response(conn, 200)
      )
    end
  end
end
