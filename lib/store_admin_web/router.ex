defmodule StoreAdminWeb.Router do
  use StoreAdminWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", StoreAdminWeb do
    pipe_through(:api)

    resources("/stores", StoreController, except: [:new, :edit]) do
      resources("/products", ProductController, except: [:new, :edit])

      resources("/sales", SaleController, except: [:new, :edit]) do
        post("/sale_items", SaleItemController, :add_item_to_sale)
        delete("/sale_items/:sale_item_id", SaleItemController, :remove_item_from_sale)
      end
    end
  end
end
