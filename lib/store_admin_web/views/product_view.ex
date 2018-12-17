defmodule StoreAdminWeb.ProductView do
  use StoreAdminWeb, :view
  alias StoreAdminWeb.ProductView

  def render("index.json", %{products: products}) do
    render_many(products, ProductView, "product.json")
  end

  def render("show.json", %{product: product}) do
    render_one(product, ProductView, "product.json")
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name: product.name,
      description: product.description,
      available_quantity: product.available_quantity,
      unit_price: product.unit_price
    }
  end
end
