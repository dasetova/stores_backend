defmodule StoreAdminWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use StoreAdminWeb, :controller

  @not_found_errors ["Store not found", "Product not found"]

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(StoreAdminWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, msg}) when msg in @not_found_errors do
    conn
    |> put_status(:not_found)
    |> render(StoreAdminWeb.ErrorView, "404.json")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(StoreAdminWeb.ErrorView, "404.json")
  end
end
