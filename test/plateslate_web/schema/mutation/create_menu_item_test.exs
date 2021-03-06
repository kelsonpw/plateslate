defmodule PlateslateWeb.Schema.Mutation.CreateMenuTest do
  use PlateslateWeb.ConnCase, async: true

  alias Plateslate.{Repo, Menu}
  import Ecto.Query

  setup do
    Plateslate.Seeds.run()

    category_id =
      from(t in Menu.Category, where: t.name == "Sandwiches")
      |> Repo.one!()
      |> Map.fetch!(:id)
      |> to_string()

    {:ok, category_id: category_id}
  end

  @query """
  mutation ($menuItem: MenuItemInput!) {
    createMenuItem(input: $menuItem) {
      errors {
        key
        message
      }
      menuItem {
        name
        description
        price
      }
    }
  }
  """

  test "createMenuItem field creates an item", %{category_id: category_id} do
    menu_item = %{
      "name" => "French Dip",
      "description" => "Roast beef, caramelized onions, horseradish, ...",
      "price" => "5.75",
      "categoryId" => category_id
    }

    conn =
      build_conn()
      |> post("/api", query: @query, variables: %{"menuItem" => menu_item})

    assert(
      json_response(conn, 200) == %{
        "data" => %{
          "createMenuItem" => %{
            "errors" => nil,
            "menuItem" => %{
              "name" => menu_item["name"],
              "description" => menu_item["description"],
              "price" => menu_item["price"]
            }
          }
        }
      }
    )
  end

  test "creating a menu item with an existing name fails", %{category_id: category_id} do
    menu_item = %{
      "name" => "Reuben",
      "description" => "Roast beef, caramelized onions, horseradish, ...",
      "price" => "5.75",
      "categoryId" => category_id
    }

    conn =
      build_conn()
      |> post("/api", query: @query, variables: %{"menuItem" => menu_item})

    assert(
      json_response(conn, 200) == %{
        "data" => %{
          "createMenuItem" => %{
            "errors" => [%{"key" => "name", "message" => "has already been taken"}],
            "menuItem" => nil
          }
        }
      }
    )
  end

  test "createMenuItem field creates an item with a category" do
    query = """
    mutation ($menuItem: MenuItemInput!) {
      createMenuItem(input: $menuItem) {
        errors {
          key
          message
        }
        menuItem {
          name
          description
          price
          category {
            name
          }
        }
      }
    }
    """

    menu_item = %{
      "name" => "Skittles",
      "description" => "A yummy fruity candy",
      "price" => "1.75",
      "category_name" => "Candy"
    }

    conn =
      build_conn()
      |> post("/api", query: query, variables: %{"menuItem" => menu_item})

    assert(
      json_response(conn, 200) == %{
        "data" => %{
          "createMenuItem" => %{
            "errors" => nil,
            "menuItem" => %{
              "name" => menu_item["name"],
              "description" => menu_item["description"],
              "price" => menu_item["price"],
              "category" => %{
                "name" => "Candy"
              }
            }
          }
        }
      }
    )
  end
end
