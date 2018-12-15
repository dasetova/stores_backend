defmodule StoreAdminWeb.SaleView do
  use StoreAdminWeb, :view
  alias StoreAdminWeb.SaleView

  def render("index.json", %{sales: sales}) do
    %{data: render_many(sales, SaleView, "sale.json")}
  end

  def render("show.json", %{sale: sale}) do
    %{data: render_one(sale, SaleView, "sale.json")}
  end

  def render("sale.json", %{sale: sale}) do
    %{
      id: sale.id,
      customer_identification_number: sale.customer_identification_number,
      total_value: sale.total_value
    }
  end
end
