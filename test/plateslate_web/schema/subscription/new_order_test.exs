defmodule PlateslateWeb.Schema.Subscription.NewOrderTest do
  use PlateslateWeb.SubscriptionCase

  @subscription """
  subscription {
    newOrder {
      customerNumber
      items {
        name
      }
    }
  }
  """

  @mutation """
  mutation ($input: PlaceOrderInput!) {
    placeOrder(input: $input) {
      order {
        id
      }
    }
  }
  """

  test "new orders can be subscribed to", %{socket: socket} do
    # setup subscription
    ref = push_doc(socket, @subscription)
    assert_reply(ref, :ok, %{subscriptionId: subscription_id})

    # run a mutation to trigger subscription
    order_input = %{
      "customerNumber" => 24,
      "items" => [%{"quantity" => 2, "menuItemId" => menu_item("Reuben").id}]
    }

    ref = push_doc(socket, @mutation, variables: %{"input" => order_input})
    assert_reply(ref, :ok, reply)

    assert(
      %{
        data: %{
          "placeOrder" => %{
            "order" => %{"id" => _}
          }
        }
      } = reply
    )

    # check if we got subscription data back

    expected = %{
      result: %{
        data: %{
          "newOrder" => %{
            "customerNumber" => 24,
            "items" => [%{"name" => "Reuben"}]
          }
        }
      },
      subscriptionId: subscription_id
    }

    assert_push("subscription:data", push)
    assert(expected == push)
  end
end
