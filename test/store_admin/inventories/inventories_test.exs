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

  describe "products" do
    alias StoreAdmin.Inventories.Product

    @valid_attrs %{
      available_quantity: 42,
      description: "some description",
      name: "some name",
      unit_price: 120.5
    }
    @update_attrs %{
      available_quantity: 43,
      description: "some updated description",
      name: "some updated name",
      unit_price: 456.7
    }
    @invalid_attrs %{available_quantity: nil, description: nil, name: nil, unit_price: nil}

    def product_fixture(attrs \\ %{}) do
      store = store_fixture()

      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:store_id, store.id)
        |> Inventories.create_product()

      product
    end

    test "list_products/1 returns all products of the given store_id" do
      product = product_fixture()
      assert Inventories.list_products(product.store_id) == [product]
    end

    test "get_product/2 returns the product with given store_id and product_id" do
      product = product_fixture()
      assert Inventories.get_product(product.store_id, product.id) == {:ok, product}
    end

    test "create_product/1 with valid data creates a product" do
      store = store_fixture()

      assert {:ok, %Product{} = product} =
               @valid_attrs
               |> Map.put(:store_id, store.id)
               |> Inventories.create_product()

      assert product.available_quantity == 42
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.unit_price == 120.5
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventories.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      assert {:ok, product} = Inventories.update_product(product, @update_attrs)
      assert %Product{} = product
      assert product.available_quantity == 43
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.unit_price == 456.7
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventories.update_product(product, @invalid_attrs)
      assert {:ok, product} == Inventories.get_product(product.store_id, product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Inventories.delete_product(product)
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Inventories.change_product(product)
    end
  end

  describe "sales" do
    @valid_attrs %{
      customer_identification_number: "some customer_identification_number",
      total_value: 120.5
    }

    def sale_fixture() do
      {:ok, %{sale: sale}} =
        prepare_sale()
        |> Inventories.create_sale()

      sale
    end

    defp prepare_sale() do
      %{product: product, sale_item: sale_item} = sale_item_fixture()

      @valid_attrs
      |> Map.put(:store_id, product.store_id)
      |> change_atom_map_to_string()
      |> Map.put("sale_items", [change_atom_map_to_string(sale_item)])
    end

    defp change_atom_map_to_string(atom_key_map) do
      for {key, val} <- atom_key_map, into: %{}, do: {Atom.to_string(key), val}
    end

    test "change_sale/1 returns a sale changeset" do
      sale = sale_fixture()
      assert %Ecto.Changeset{} = Inventories.change_sale(sale)
    end
  end

  @valid_attrs %{
    quantity: 1,
    unit_price: 12000.0
  }
  def sale_item_fixture(attrs \\ %{}) do
    product = product_fixture()

    sale_item =
      attrs
      |> Enum.into(@valid_attrs)
      |> Map.put(:product_id, product.id)

    %{product: product, sale_item: sale_item}
  end
end
