defmodule StoreAdmin.Inventories.SaleItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sale_items" do
    field(:quantity, :integer)
    field(:unit_price, :float)

    belongs_to(:sale, StoreAdmin.Inventories.Sale)
    belongs_to(:product, StoreAdmin.Inventories.Product)

    timestamps(type: :utc_datetime)
  end

  @attrs [:quantity, :unit_price, :sale_id, :product_id]
  @require_attrs [:quantity, :unit_price, :product_id]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    IO.inspect(params, label: "Changeset")

    struct
    |> cast(params, @attrs)
    |> validate_required(@require_attrs)
    |> assoc_constraint(:product)
  end
end
