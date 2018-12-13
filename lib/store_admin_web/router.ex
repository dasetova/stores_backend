defmodule StoreAdminWeb.Router do
  use StoreAdminWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", StoreAdminWeb do
    pipe_through(:api)

    resources("/stores", StoreController)
  end
end
