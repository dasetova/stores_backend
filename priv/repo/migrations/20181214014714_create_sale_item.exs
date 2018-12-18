defmodule StoreAdmin.Repo.Migrations.CreateSaleItem do
  use Ecto.Migration

  def change do
    create table(:sale_items) do
      add(:quantity, :integer)
      add(:unit_price, :float)
      add(:sale_id, references(:sales, on_delete: :nothing))
      add(:product_id, references(:products, on_delete: :nothing))

      timestamps(type: :timestamptz)
    end
  end
end
