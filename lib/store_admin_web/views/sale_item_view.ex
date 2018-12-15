defmodule StoreAdminWeb.SaleItemView do
  use StoreAdminWeb, :view

  def render("sale_item.json", %{sale_item: sale_item}) do
    %{
      id: sale_item.id,
      product_id: sale_item.product_id,
      quantity: sale_item.quantity,
      unit_price: sale_item.unit_price
    }
  end
end
