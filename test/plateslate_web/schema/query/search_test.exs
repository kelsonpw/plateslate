defmodule PlateslateWeb.Schema.Query.SearchTest do
  use PlateslateWeb.ConnCase, async: true

  setup do
    Plateslate.Seeds.run()
  end

  describe "search query" do
    @query """
    query Search($term: String!) {
      search(matching: $term) {
        ... on MenuItem {
          name
        }
        ... on Category {
          name
        }
        __typename
      }
    }
    """

    @variables %{term: "e"}

    test "search results a list of menu items and categories" do
      conn =
        build_conn()
        |> get("/api", query: @query, variables: @variables)

      assert(%{"data" => %{"search" => results}} = json_response(conn, 200))

      assert(length(results) > 0)
      assert(Enum.find(results, &(&1["__typename"] == "Category")))
      assert(Enum.find(results, &(&1["__typename"] == "MenuItem")))
    end
  end
end
