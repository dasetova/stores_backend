defmodule StoreAdmin.InventoriesTest do
  use StoreAdmin.DataCase

  alias StoreAdmin.Inventories

  describe "stores" do
    alias StoreAdmin.Inventories.Store

    @valid_attrs %{
      address: "some address",
      logo: "some logo",
      name: "some name",
      phone: "some phone"
    }
    @update_attrs %{
      address: "some updated address",
      deleted_at: "2011-05-18 15:01:01.000000Z",
      logo: "some updated logo",
      name: "some updated name",
      phone: "some updated phone"
    }
    @invalid_attrs %{address: nil, deleted_at: nil, logo: nil, name: nil, phone: nil}

    def store_fixture(attrs \\ %{}) do
      {:ok, store} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Inventories.create_store()

      store
    end

    test "list_stores/0 returns all stores" do
      store = store_fixture()
      assert Inventories.list_stores() == [store]
    end

    test "get_store!/1 returns the store with given id" do
      store = store_fixture()
      assert Inventories.get_store(store.id) == {:ok, store}
    end

    test "create_store/1 with valid data creates a store" do
      assert {:ok, %Store{} = store} = Inventories.create_store(@valid_attrs)
      assert store.address == "some address"
      assert store.logo == "some logo"
      assert store.name == "some name"
      assert store.phone == "some phone"
    end

    test "create_store/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventories.create_store(@invalid_attrs)
    end

    test "update_store/2 with valid data updates the store" do
      store = store_fixture()
      assert {:ok, store} = Inventories.update_store(store, @update_attrs)
      assert %Store{} = store
      assert store.address == "some updated address"
      assert store.deleted_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert store.logo == "some updated logo"
      assert store.name == "some updated name"
      assert store.phone == "some updated phone"
    end

    test "update_store/2 with invalid data returns error changeset" do
      store = store_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventories.update_store(store, @invalid_attrs)
      assert {:ok, store} == Inventories.get_store(store.id)
    end

    test "delete_store/1 deletes the store" do
      store = store_fixture()
      assert {:ok, %Store{}} = Inventories.delete_store(store)
    end

    test "change_store/1 returns a store changeset" do
      store = store_fixture()
      assert %Ecto.Changeset{} = Inventories.change_store(store)
    end
  end
end
