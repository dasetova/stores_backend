defmodule StoreAdmin.Repo.Migrations.CreateSales do
  use Ecto.Migration

  def change do
    create table(:sales) do
      add(:customer_identification_number, :string)
      add(:total_value, :float)
      add(:store_id, references(:stores, on_delete: :nothing))

      timestamps(type: :timestamptz)
    end
  end
end
