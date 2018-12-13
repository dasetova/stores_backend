defmodule StoreAdminWeb.Router do
  use StoreAdminWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", StoreAdminWeb do
    pipe_through(:api)

    resources("/stores", StoreController, except: [:new, :edit]) do
      resources("/products", ProductController, except: [:new, :edit])
    end
  end
end
