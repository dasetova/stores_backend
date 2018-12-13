defmodule StoreAdminWeb.StoreController do
  use StoreAdminWeb, :controller

  alias StoreAdmin.Inventories
  alias StoreAdmin.Inventories.Store

  action_fallback(StoreAdminWeb.FallbackController)

  def index(conn, _params) do
    stores = Inventories.list_stores()
    render(conn, "index.json", stores: stores)
  end

  def create(conn, %{"store" => store_params}) do
    with {:ok, %Store{} = store} <- Inventories.create_store(store_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", store_path(conn, :show, store))
      |> render("show.json", store: store)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %Store{} = store} <- Inventories.get_store(id) do
      render(conn, "show.json", store: store)
    end
  end

  def update(conn, %{"id" => id, "store" => store_params}) do
    with {:ok, %Store{} = store} <- Inventories.get_store(id) do
      with {:ok, %Store{} = store} <- Inventories.update_store(store, store_params) do
        render(conn, "show.json", store: store)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Store{} = store} <- Inventories.get_store(id) do
      with {:ok, %Store{}} <- Inventories.delete_store(store) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
