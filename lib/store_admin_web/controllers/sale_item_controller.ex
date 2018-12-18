defmodule StoreAdminWeb.SaleItemController do
  use StoreAdminWeb, :controller

  alias StoreAdmin.Inventories
  alias StoreAdmin.Inventories.SaleItem

  action_fallback(StoreAdminWeb.FallbackController)

  def add_item_to_sale(conn, %{
        "store_id" => store_id,
        "sale_id" => sale_id,
        "sale_item" => %{"product_id" => _, "quantity" => _, "unit_price" => _} = sale_item_params
      }) do
    case Inventories.validate_sale_products(%{
           "store_id" => store_id,
           "sale_items" => [sale_item_params]
         }) do
      [] ->
        conn
        |> send_bad_params("Products sended doesn't belongs to the store")

      products ->
        case Inventories.validate_products_inventory(products, [sale_item_params]) do
          [] ->
            with {:ok, %{sale_item: %SaleItem{} = sale_item}} <-
                   Inventories.add_item_to_sale(store_id, sale_id, sale_item_params) do
              conn
              |> put_status(:created)
              |> render("show.json", sale_item: sale_item)
            end

          errors ->
            conn |> send_bad_params(errors)
        end
    end
  end

  def remove_item_from_sale(conn, %{
        "store_id" => store_id,
        "sale_id" => sale_id,
        "sale_item_id" => sale_item_id
      }) do
    with {:ok, %{sale_item_deleted: %SaleItem{}}} <-
           Inventories.remove_item_from_sale(store_id, sale_id, sale_item_id) do
      send_resp(conn, :no_content, "")
    end
  end

  defp send_bad_params(conn, msg) do
    conn
    |> put_status(:bad_request)
    |> render(StoreAdminWeb.ErrorView, "400.json", %{
      msg: msg
    })
  end
end
