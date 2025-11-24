defmodule RetroApp.Retrospectives do
  @moduledoc """
  The Retrospectives context.
  """

  import Ecto.Query, warn: false
  alias RetroApp.Repo

  alias RetroApp.Retrospectives.Retrospective

  @doc """
  Returns the list of retrospectives.

  ## Examples

      iex> list_retrospectives()
      [%Retrospective{}, ...]

  """
  def list_retrospectives do
    Repo.all(Retrospective)
  end

  @doc """
  Gets a single retrospective.

  Raises `Ecto.NoResultsError` if the Retrospective does not exist.

  ## Examples

      iex> get_retrospective!(123)
      %Retrospective{}

      iex> get_retrospective!(456)
      ** (Ecto.NoResultsError)

  """
  def get_retrospective!(id), do: Repo.get!(Retrospective, id)

  @doc """
  Creates a retrospective.

  ## Examples

      iex> create_retrospective(%{field: value})
      {:ok, %Retrospective{}}

      iex> create_retrospective(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_retrospective(attrs) do
    %Retrospective{}
    |> Retrospective.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a retrospective.

  ## Examples

      iex> update_retrospective(retrospective, %{field: new_value})
      {:ok, %Retrospective{}}

      iex> update_retrospective(retrospective, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_retrospective(%Retrospective{} = retrospective, attrs) do
    retrospective
    |> Retrospective.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a retrospective.

  ## Examples

      iex> delete_retrospective(retrospective)
      {:ok, %Retrospective{}}

      iex> delete_retrospective(retrospective)
      {:error, %Ecto.Changeset{}}

  """
  def delete_retrospective(%Retrospective{} = retrospective) do
    Repo.delete(retrospective)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking retrospective changes.

  ## Examples

      iex> change_retrospective(retrospective)
      %Ecto.Changeset{data: %Retrospective{}}

  """
  def change_retrospective(%Retrospective{} = retrospective, attrs \\ %{}) do
    Retrospective.changeset(retrospective, attrs)
  end

  alias RetroApp.Retrospectives.Column

  @doc """
  Returns the list of columns.

  ## Examples

      iex> list_columns()
      [%Column{}, ...]

  """
  def list_columns do
    Repo.all(Column)
  end

  @doc """
  Gets a single column.

  Raises `Ecto.NoResultsError` if the Column does not exist.

  ## Examples

      iex> get_column!(123)
      %Column{}

      iex> get_column!(456)
      ** (Ecto.NoResultsError)

  """
  def get_column!(id), do: Repo.get!(Column, id)

  @doc """
  Creates a column.

  ## Examples

      iex> create_column(%{field: value})
      {:ok, %Column{}}

      iex> create_column(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_column(attrs) do
    %Column{}
    |> Column.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a column.

  ## Examples

      iex> update_column(column, %{field: new_value})
      {:ok, %Column{}}

      iex> update_column(column, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_column(%Column{} = column, attrs) do
    column
    |> Column.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a column.

  ## Examples

      iex> delete_column(column)
      {:ok, %Column{}}

      iex> delete_column(column)
      {:error, %Ecto.Changeset{}}

  """
  def delete_column(%Column{} = column) do
    Repo.delete(column)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking column changes.

  ## Examples

      iex> change_column(column)
      %Ecto.Changeset{data: %Column{}}

  """
  def change_column(%Column{} = column, attrs \\ %{}) do
    Column.changeset(column, attrs)
  end

  alias RetroApp.Retrospectives.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, item} -> {:ok, Repo.preload(item, [:action_items, :replies])}
      error -> error
    end
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end
  def get_retrospective_by_slug!(slug) do
    Retrospective
    |> Repo.get_by!(slug: slug)
    |> Repo.preload(columns: [items: [:action_items, :replies]])
  end

  def inc_item_votes(%Item{} = item) do
    {1, _} =
      from(i in Item, where: i.id == ^item.id)
      |> Repo.update_all(inc: [vote_count: 1])

    {:ok, Repo.preload(get_item!(item.id), [:action_items, :replies])}
  end

  def inc_item_dislikes(%Item{} = item) do
    {1, _} =
      from(i in Item, where: i.id == ^item.id)
      |> Repo.update_all(inc: [dislike_count: 1])

    {:ok, Repo.preload(get_item!(item.id), [:action_items, :replies])}
  end

  @topic_prefix "retro:"

  def subscribe(retro_id) do
    Phoenix.PubSub.subscribe(RetroApp.PubSub, @topic_prefix <> to_string(retro_id))
  end

  def broadcast(retro_id, event) do
    Phoenix.PubSub.broadcast(RetroApp.PubSub, @topic_prefix <> to_string(retro_id), event)
  end

  alias RetroApp.Retrospectives.ActionItem

  @doc """
  Returns the list of action_items.

  ## Examples

      iex> list_action_items()
      [%ActionItem{}, ...]

  """
  def list_action_items do
    Repo.all(ActionItem)
  end

  @doc """
  Gets a single action_item.

  Raises `Ecto.NoResultsError` if the Action item does not exist.

  ## Examples

      iex> get_action_item!(123)
      %ActionItem{}

      iex> get_action_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_action_item!(id), do: Repo.get!(ActionItem, id)

  @doc """
  Creates a action_item.

  ## Examples

      iex> create_action_item(%{field: value})
      {:ok, %ActionItem{}}

      iex> create_action_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_action_item(attrs) do
    %ActionItem{}
    |> ActionItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a action_item.

  ## Examples

      iex> update_action_item(action_item, %{field: new_value})
      {:ok, %ActionItem{}}

      iex> update_action_item(action_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_action_item(%ActionItem{} = action_item, attrs) do
    action_item
    |> ActionItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a action_item.

  ## Examples

      iex> delete_action_item(action_item)
      {:ok, %ActionItem{}}

      iex> delete_action_item(action_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_action_item(%ActionItem{} = action_item) do
    Repo.delete(action_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking action_item changes.

  ## Examples

      iex> change_action_item(action_item)
      %Ecto.Changeset{data: %ActionItem{}}

  """
  def change_action_item(%ActionItem{} = action_item, attrs \\ %{}) do
    ActionItem.changeset(action_item, attrs)
  end

  alias RetroApp.Retrospectives.Reply

  @doc """
  Returns the list of replies.

  ## Examples

      iex> list_replies()
      [%Reply{}, ...]

  """
  def list_replies do
    Repo.all(Reply)
  end

  @doc """
  Gets a single reply.

  Raises `Ecto.NoResultsError` if the Reply does not exist.

  ## Examples

      iex> get_reply!(123)
      %Reply{}

      iex> get_reply!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reply!(id), do: Repo.get!(Reply, id)

  @doc """
  Creates a reply.

  ## Examples

      iex> create_reply(%{field: value})
      {:ok, %Reply{}}

      iex> create_reply(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reply(attrs) do
    %Reply{}
    |> Reply.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reply.

  ## Examples

      iex> update_reply(reply, %{field: new_value})
      {:ok, %Reply{}}

      iex> update_reply(reply, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reply(%Reply{} = reply, attrs) do
    reply
    |> Reply.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reply.

  ## Examples

      iex> delete_reply(reply)
      {:ok, %Reply{}}

      iex> delete_reply(reply)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reply(%Reply{} = reply) do
    Repo.delete(reply)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reply changes.

  ## Examples

      iex> change_reply(reply)
      %Ecto.Changeset{data: %Reply{}}

  """
  def change_reply(%Reply{} = reply, attrs \\ %{}) do
    Reply.changeset(reply, attrs)
  end
end
