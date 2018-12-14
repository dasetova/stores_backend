defmodule StoreAdmin.Inventories.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stores" do
    field(:address, :string)
    field(:deleted_at, :utc_datetime)
    field(:logo, :string)
    field(:name, :string)
    field(:phone, :string)

    has_many(:products, StoreAdmin.Inventories.Product)
    has_many(:sales, StoreAdmin.Inventories.Sale)

    timestamps(type: :utc_datetime)
  end

  @attrs [:name, :address, :phone, :logo, :deleted_at]
  @required_attrs [:name, :address, :phone]

  @doc """
  Changeset use to create and update functions
  """
  def changeset(store, attrs) do
    store
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end

  @doc """
  Changeset use to perform soft delete
  """
  def delete_changeset(store) do
    current_time = DateTime.utc_now()

    store
    |> change(%{deleted_at: current_time})
  end
end
