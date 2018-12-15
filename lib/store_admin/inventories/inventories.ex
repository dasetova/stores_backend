defmodule StoreAdmin.Inventories do
  @moduledoc """
  The Inventories context.
  """

  import Ecto.Query, warn: false
  alias StoreAdmin.Repo
  alias Ecto.Multi

  alias StoreAdmin.Inventories.Store

  @doc """
  Returns the list of stores.

  ## Examples

      iex> list_stores()
      [%Store{}, ...]

  """
  def list_stores do
    from(s in Store, where: is_nil(s.deleted_at))
    |> Repo.all()
  end

  @doc """
  Gets a single store.

  Raises `Ecto.NoResultsError` if the Store does not exist.

  ## Examples

      iex> get_store!(123)
      %Store{}

      iex> get_store!(456)
      ** (Ecto.NoResultsError)

  """
  def get_store(id) do
    case find_store(id) do
      %Store{} = store -> {:ok, store}
      nil -> {:error, "Store not found"}
    end
  end

  defp find_store(id) do
    from(
      s in Store,
      where: is_nil(s.deleted_at)
    )
    |> Repo.get(id)
  end

  @doc """
  Creates a store.

  ## Examples

      iex> create_store(%{field: value})
      {:ok, %Store{}}

      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_store(attrs \\ %{}) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a store.

  ## Examples

      iex> update_store(store, %{field: new_value})
      {:ok, %Store{}}

      iex> update_store(store, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_store(%Store{} = store, attrs) do
    store
    |> Store.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Store. Performs soft-delete

  ## Examples

      iex> delete_store(store)
      {:ok, %Store{}}

      iex> delete_store(store)
      {:error, %Ecto.Changeset{}}

  """
  def delete_store(%Store{} = store) do
    store
    |> Store.delete_changeset()
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking store changes.

  ## Examples

      iex> change_store(store)
      %Ecto.Changeset{source: %Store{}}

  """
  def change_store(%Store{} = store) do
    Store.changeset(store, %{})
  end

  alias StoreAdmin.Inventories.Product

  @doc """
  Returns Store list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products(store_id) do
    from(p in Product, where: p.store_id == ^store_id)
    |> Repo.all()
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product(store_id, product_id) do
    case find_product(store_id, product_id) do
      %Product{} = product -> {:ok, product}
      nil -> {:error, "Product not found"}
    end
  end

  defp find_products(store_id, [_ | _] = product_ids) do
    from(p in Product, where: p.store_id == ^store_id and p.id in ^product_ids)
    |> Repo.all()
  end

  defp find_product(store_id, product_id) do
    from(p in Product, where: p.store_id == ^store_id)
    |> Repo.get(product_id)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end

  alias StoreAdmin.Inventories.Sale

  @doc """
  Returns the list of sales.

  ## Examples

      iex> list_sales()
      [%Sale{}, ...]

  """
  def list_sales(store_id) do
    from(s in Sale, where: s.store_id == ^store_id)
    |> Repo.all()
    |> Repo.preload(:sale_items)
  end

  @doc """
  Gets a single sale.

  Raises `Ecto.NoResultsError` if the Sale does not exist.

  ## Examples

      iex> get_sale!(123)
      %Sale{}

      iex> get_sale!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sale(store_id, sale_id) do
    case find_sale(store_id, sale_id) do
      %Sale{} = sale -> {:ok, sale}
      nil -> {:error, "sale not found"}
    end
  end

  defp find_sale(store_id, sale_id) do
    from(s in Sale, where: s.store_id == ^store_id)
    |> Repo.get(sale_id)
    |> Repo.preload(:sale_items)
  end

  @doc """
  Creates a sale.

  ## Examples

      iex> create_sale(%{field: value})
      {:ok, %Sale{}}

      iex> create_sale(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sale(%{"sale_items" => sale_items} = attrs) do
    Multi.new()
    |> Multi.insert(:sale, prepare_sale_to_insert(sale_items, attrs))
    |> update_products_inventories(attrs)
    |> Repo.transaction()
  end

  defp update_products_inventories(
         multi,
         %{"sale_items" => sale_items, "store_id" => store_id}
       ) do
    Enum.reduce(sale_items, multi, fn item, acc ->
      product_id = Map.get(item, "product_id")
      quantity = Map.get(item, "quantity")

      {:ok, product} = get_product(store_id, product_id)

      product_update_changeset =
        Product.changeset(product, %{
          available_quantity: product.available_quantity - quantity
        })

      acc
      |> Multi.update(String.to_atom("update_product_#{product_id}"), product_update_changeset)
    end)
  end

  defp prepare_sale_to_insert(sale_items, attrs) do
    attrs =
      attrs
      |> Map.put("total_value", calculate_sale_total_value(sale_items))

    Sale.changeset(%Sale{}, attrs)
  end

  defp calculate_sale_total_value([_ | _] = sale_items) do
    IO.inspect(sale_items, label: "AAAH")

    sale_items
    |> Enum.reduce(0, fn %{"quantity" => quantity, "unit_price" => unit_price}, acc ->
      quantity * unit_price + acc
    end)
  end

  defp calculate_sale_total_value([] = _sale_items) do
    0.0
  end

  def validate_sale_products(%{"store_id" => store_id, "sale_items" => sale_items = [_ | _]}) do
    product_ids =
      sale_items
      |> Enum.reduce([], fn %{"product_id" => product_id}, acc ->
        acc ++ [product_id]
      end)

    find_products(store_id, product_ids)
  end

  def validate_sale_products(%{"store_id" => _, "sale_items" => _ = []}) do
    []
  end

  def validate_products_inventory(products, sale_items) do
    Enum.reduce(sale_items, [], fn item, errors ->
      case Enum.find(products, fn product ->
             product.id == Map.get(item, "product_id")
           end) do
        nil ->
          errors ++ ["#{item.product_id} wasnt found in the given products list"]

        product ->
          case product.available_quantity >= Map.get(item, "quantity") do
            true ->
              errors

            false ->
              errors ++
                ["Product with ID: #{product.id} has #{product.available_quantity} in inventory"]
          end
      end
    end)
  end

  @doc """
  Updates a sale.

  ## Examples

      iex> update_sale(sale, %{field: new_value})
      {:ok, %Sale{}}

      iex> update_sale(sale, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sale(%Sale{} = sale, attrs) do
    sale
    |> Sale.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sale.

  ## Examples

      iex> delete_sale(sale)
      {:ok, %Sale{}}

      iex> delete_sale(sale)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sale(%Sale{} = sale) do
    Repo.delete(sale)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sale changes.

  ## Examples

      iex> change_sale(sale)
      %Ecto.Changeset{source: %Sale{}}

  """
  def change_sale(%Sale{} = sale) do
    Sale.changeset(sale, %{})
  end

  alias StoreAdmin.Inventories.SaleItem

  def add_item_to_sale(store_id, sale_id, sale_item_params) do
    case get_sale(store_id, sale_id) do
      {:ok, sale} ->
        Multi.new()
        |> Multi.insert(
          :sale_item,
          SaleItem.changeset(%SaleItem{}, sale_item_params |> Map.put("sale_id", sale_id))
        )
        |> Multi.update(
          :sale_updated,
          Sale.changeset(sale, %{
            total_value:
              sale.total_value +
                Map.get(sale_item_params, "unit_price") * Map.get(sale_item_params, "quantity")
          })
        )
        |> update_products_inventories(%{
          "sale_items" => [sale_item_params],
          "store_id" => store_id
        })
        |> Repo.transaction()

      _ ->
        {:error, "Sale not found"}
    end
  end
end
