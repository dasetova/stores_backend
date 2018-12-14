defmodule StoreAdmin.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add(:name, :string)
      add(:description, :string)
      add(:available_quantity, :integer)
      add(:unit_price, :float)
      add(:store_id, references(:stores, on_delete: :nothing))

      timestamps(type: :timestamptz)
    end
  end
end
