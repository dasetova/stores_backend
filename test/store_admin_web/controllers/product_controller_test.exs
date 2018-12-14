defmodule StoreAdminWeb.ProductControllerTest do
  use StoreAdminWeb.ConnCase

  alias StoreAdmin.Inventories
  alias StoreAdmin.Inventories.Product

  @create_attrs %{
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

  def fixture(:product) do
    store = StoreAdminWeb.StoreControllerTest.fixture(:store)

    {:ok, product} =
      @create_attrs
      |> Map.put(:store_id, store.id)
      |> Inventories.create_product()

    product
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, store_product_path(conn, :index, 100))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: product} do
      conn =
        post(conn, store_product_path(conn, :create, product.store_id), product: @create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, store_product_path(conn, :show, product.store_id, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "available_quantity" => 42,
               "description" => "some description",
               "name" => "some name",
               "unit_price" => 120.5
             }
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn =
        post(conn, store_product_path(conn, :create, product.store_id), product: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update product" do
    setup [:create_product]

    test "renders product when data is valid", %{conn: conn, product: %Product{id: id} = product} do
      conn =
        put(
          conn,
          store_product_path(conn, :update, product.store_id, product),
          product: @update_attrs
        )

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, store_product_path(conn, :show, product.store_id, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "available_quantity" => 43,
               "description" => "some updated description",
               "name" => "some updated name",
               "unit_price" => 456.7
             }
    end

    test "renders errors when data is invalid", %{conn: conn, product: product} do
      conn =
        put(
          conn,
          store_product_path(conn, :update, product.store_id, product),
          product: @invalid_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete product" do
    setup [:create_product]

    test "deletes chosen product", %{conn: conn, product: product} do
      conn = delete(conn, store_product_path(conn, :delete, product.store_id, product))
      assert response(conn, 204)
    end
  end

  defp create_product(_) do
    product = fixture(:product)
    {:ok, product: product}
  end
end
