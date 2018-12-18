defmodule StoreAdminWeb.SaleView do
  use StoreAdminWeb, :view
  alias StoreAdminWeb.{SaleView, SaleItemView}

  def render("index.json", %{sales: sales}) do
    render_many(sales, SaleView, "sale.json")
  end

  def render("show.json", %{sale: sale}) do
    render_one(sale, SaleView, "sale.json")
  end

  def render("sale.json", %{sale: sale}) do
    %{
      id: sale.id,
      customer_identification_number: sale.customer_identification_number,
      total_value: sale.total_value,
      sale_items: render_many(sale.sale_items, SaleItemView, "sale_item.json")
    }
  end

  def render("creation.json", %{sale: sale}) do
    %{
      id: sale.id,
      customer_identification_number: sale.customer_identification_number,
      total_value: sale.total_value,
      sale_items: render_many(sale.sale_items, SaleItemView, "creation.json")
    }
  end
end
