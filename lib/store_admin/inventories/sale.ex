defmodule StoreAdmin.Inventories.Sale do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sales" do
    field(:customer_identification_number, :string)
    field(:total_value, :float)
    belongs_to(:store, StoreAdmin.Inventories.Store)
    has_many(:sale_items, StoreAdmin.Inventories.SaleItem)

    timestamps(type: :utc_datetime)
  end

  @attrs [:customer_identification_number, :total_value, :store_id]
  @require_attrs @attrs

  @doc false
  def changeset(sale, attrs) do
    sale
    |> cast(attrs, @attrs)
    |> cast_assoc(
      :sale_items,
      required: true,
      with: &StoreAdmin.Inventories.SaleItem.changeset/2
    )
    |> validate_required(@require_attrs)
  end
end
