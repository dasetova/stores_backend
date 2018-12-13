defmodule StoreAdminWeb.ProductController do
  use StoreAdminWeb, :controller

  alias StoreAdmin.Inventories
  alias StoreAdmin.Inventories.Product

  action_fallback(StoreAdminWeb.FallbackController)

  def index(conn, %{"store_id" => store_id}) do
    products = Inventories.list_products(store_id)
    render(conn, "index.json", products: products)
  end

  def create(conn, %{"store_id" => store_id, "product" => product_params}) do
    with {:ok, %Product{} = product} <-
           Inventories.create_product(Map.put(product_params, "store_id", store_id)) do
      conn
      |> put_status(:created)
      |> render("show.json", product: product)
    end
  end

  def show(conn, %{"store_id" => store_id, "id" => id}) do
    with {:ok, %Product{} = product} <- Inventories.get_product(store_id, id) do
      render(conn, "show.json", product: product)
    end
  end

  def update(conn, %{"store_id" => store_id, "id" => id, "product" => product_params}) do
    with {:ok, %Product{} = product} <- Inventories.get_product(store_id, id) do
      with {:ok, %Product{} = product} <- Inventories.update_product(product, product_params) do
        render(conn, "show.json", product: product)
      end
    end
  end

  def delete(conn, %{"store_id" => store_id, "id" => id}) do
    with {:ok, %Product{} = product} <- Inventories.get_product(store_id, id) do
      with {:ok, %Product{}} <- Inventories.delete_product(product) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
