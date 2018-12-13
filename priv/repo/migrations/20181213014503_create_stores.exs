defmodule StoreAdmin.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add(:name, :string)
      add(:address, :string)
      add(:phone, :string)
      add(:logo, :string)
      add(:deleted_at, :utc_datetime)

      timestamps(type: :timestamptz)
    end
  end
end
