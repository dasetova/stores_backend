defmodule StoreAdminWeb.SaleController do
  use StoreAdminWeb, :controller

  alias StoreAdmin.Inventories
  alias StoreAdmin.Inventories.Sale

  action_fallback(StoreAdminWeb.FallbackController)

  def index(conn, _params) do
    sales = Inventories.list_sales()
    render(conn, "index.json", sales: sales)
  end

  @doc """
  Validates sale_items as a list with values
  Validates products before insert.
  If the products validations is diferent with the received then is a bad params request
  """
  def create(conn, %{
        "store_id" => store_id,
        "sale" => %{"sale_items" => sale_items = [_ | _]} = sale_params
      }) do
    sale_params = sale_params |> Map.put("store_id", store_id)

    case Inventories.validate_sale_products(sale_params) do
      [] ->
        conn
        |> send_bad_params("Products sended doesn't belongs to the store")

      [_ | _] = validation when length(validation) <> length(sale_items) ->
        conn
        |> send_bad_params("One or more products doesn't belongs to store")

      _ ->
        with {:ok, %Sale{} = sale} <- Inventories.create_sale(sale_params) do
          conn
          |> put_status(:created)
          |> put_resp_header("location", store_sale_path(conn, :show, sale.store_id, sale))
          |> render("show.json", sale: sale)
        end
    end
  end

  def create(conn, _) do
    conn
    |> send_bad_params("sale_items must be present and have at least one row")
  end

  defp send_bad_params(conn, msg) do
    conn
    |> put_status(:bad_request)
    |> render(StoreAdminWeb.ErrorView, "400.json", %{
      msg: msg
    })
  end

  def show(conn, %{"store_id" => store_id, "id" => id}) do
    with {:ok, %Sale{} = sale} <- Inventories.get_sale(store_id, id) do
      render(conn, "show.json", sale: sale)
    end
  end

  def delete(conn, %{"store_id" => store_id, "id" => id}) do
    with {:ok, %Sale{} = sale} <- Inventories.get_sale(store_id, id) do
      with {:ok, %Sale{}} <- Inventories.delete_sale(sale) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
