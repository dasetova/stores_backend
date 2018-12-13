defmodule StoreAdmin.Inventories.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field(:available_quantity, :integer)
    field(:description, :string)
    field(:name, :string)
    field(:unit_price, :float)

    belongs_to(:store, StoreAdmin.Inventories.Store)

    timestamps(type: :utc_datetime)
  end

  @attrs [:name, :description, :available_quantity, :unit_price, :store_id]
  @required_attrs @attrs

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
