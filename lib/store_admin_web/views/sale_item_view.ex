defmodule StoreAdminWeb.SaleItemView do
  use StoreAdminWeb, :view
  alias StoreAdminWeb.{SaleItemView, ProductView}

  def render("show.json", %{sale_item: sale_item}) do
    render_one(sale_item, SaleItemView, "sale_item.json")
  end

  def render("creation.json", %{sale_item: sale_item}) do
    %{
      id: sale_item.id,
      product_id: sale_item.product_id,
      quantity: sale_item.quantity,
      unit_price: sale_item.unit_price
    }
  end

  def render("sale_item.json", %{sale_item: sale_item}) do
    %{
      id: sale_item.id,
      product_id: sale_item.product_id,
      quantity: sale_item.quantity,
      unit_price: sale_item.unit_price,
      product: render_one(sale_item.product, ProductView, "product.json")
    }
  end
end
