defmodule StoreAdminWeb.SaleControllerTest do
  use StoreAdminWeb.ConnCase

  alias StoreAdmin.Inventories
  alias StoreAdmin.Inventories.Sale

  @create_attrs %{
    customer_identification_number: "some customer_identification_number",
    total_value: 120.5
  }
  @update_attrs %{
    customer_identification_number: "some updated customer_identification_number",
    total_value: 456.7
  }
  @invalid_attrs %{customer_identification_number: nil, total_value: nil}

  def fixture(:sale) do
    store = StoreAdminWeb.StoreControllerTest.fixture(:store)

    {:ok, sale} =
      @create_attrs
      |> Inventories.create_sale()
      |> Map.put(:store_id, store.id)

    sale
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all sales", %{conn: conn} do
      conn = get(conn, store_sale_path(conn, :index, 1))
      assert json_response(conn, 200) == []
    end
  end

  describe "create sale" do
    setup [:create_sale]

    test "renders sale when data is valid", %{conn: conn, sale: sale} do
      conn = post(conn, store_sale_path(conn, :create, sale.store_id), sale: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, store_sale_path(conn, :show, sale.store_id, id))

      assert json_response(conn, 200) == %{
               "id" => id,
               "customer_identification_number" => "some customer_identification_number",
               "total_value" => 120.5
             }
    end

    test "renders errors when data is invalid", %{conn: conn, sale: sale} do
      conn = post(conn, store_sale_path(conn, :create, sale.store_id), sale: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update sale" do
    setup [:create_sale]

    test "renders sale when data is valid", %{conn: conn, sale: %Sale{id: id} = sale} do
      conn = put(conn, store_sale_path(conn, :update, 1, sale), sale: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, store_sale_path(conn, :show, 1, id))

      assert json_response(conn, 200) == %{
               "id" => id,
               "customer_identification_number" => "some updated customer_identification_number",
               "total_value" => 456.7
             }
    end

    test "renders errors when data is invalid", %{conn: conn, sale: sale} do
      conn = put(conn, store_sale_path(conn, :update, 1, sale), sale: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete sale" do
    setup [:create_sale]

    test "deletes chosen sale", %{conn: conn, sale: sale} do
      conn = delete(conn, store_sale_path(conn, :delete, 1, sale))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, store_sale_path(conn, :show, 1, sale))
      end)
    end
  end

  defp create_sale(_) do
    sale = fixture(:sale)
    {:ok, sale: sale}
  end
end
