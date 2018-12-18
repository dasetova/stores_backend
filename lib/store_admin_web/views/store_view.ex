defmodule StoreAdminWeb.StoreView do
  use StoreAdminWeb, :view
  alias StoreAdminWeb.StoreView

  def render("index.json", %{stores: stores}) do
    render_many(stores, StoreView, "store.json")
  end

  def render("show.json", %{store: store}) do
    render_one(store, StoreView, "store.json")
  end

  def render("store.json", %{store: store}) do
    %{
      id: store.id,
      name: store.name,
      address: store.address,
      phone: store.phone,
      logo: store.logo,
      deleted_at: store.deleted_at
    }
  end
end
