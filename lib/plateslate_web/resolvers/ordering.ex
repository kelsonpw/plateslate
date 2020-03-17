defmodule PlateslateWeb.Resolvers.Ordering do
  alias Plateslate.Ordering

  def place_order(_, %{input: place_order_input}, _) do
    case Ordering.create_order(place_order_input) do
      {:ok, order} -> {:ok, %{order: order}}
      {:error, changeset} -> {:ok, %{errors: transform_errors(changeset)}}
    end
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn {key, value} ->
      %{key: key, message: value}
    end)
  end

  defp format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end