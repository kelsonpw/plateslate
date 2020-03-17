defmodule PlateslateWeb.Schema.Mutation.PlaceOrderTest do
  use PlateslateWeb.ConnCase, async: true

  alias Plateslate.Ordering.Order
  alias Plateslate.Repo
  import Ecto.Query

  setup do
    Plateslate.Seeds.run()

    items =
      Plateslate.Menu.Item
      |> Repo.all()
      |> Enum.take(2)

    {:ok, items: items}
  end

  @query """
  mutation ($input: PlaceOrderInput!) {
    placeOrder(input: $input) {
      order {
        state
        items {
          name
        }
      }
    }
  }
  """

  test "placeOrder field places an order", %{items: items} do
    input = %{
      "customerNumber" => 1,
      "items" =>
        Enum.map(items, fn %{id: id} ->
          %{"menuItemId" => id, "quantity" => 1}
        end)
    }

    conn =
      build_conn()
      |> post("/api", query: @query, variables: %{"input" => input})

    assert(
      json_response(conn, 200) == %{
        "data" => %{
          "placeOrder" => %{
            "order" => %{
              "state" => "created",
              "items" =>
                Enum.map(items, fn %{name: name} ->
                  %{"name" => name}
                end)
            }
          }
        }
      }
    )
  end
end
