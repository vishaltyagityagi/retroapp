defmodule RetroAppWeb.RetroLive.Show do
  use RetroAppWeb, :live_view

  alias RetroApp.Retrospectives


  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    retro = Retrospectives.get_retrospective_by_slug!(slug)
    if connected?(socket), do: Retrospectives.subscribe(retro.id)

    {:ok, assign(socket, retro: retro)}
  end

  @impl true
  def handle_event("save", %{"item" => item_params}, socket) do
    case Retrospectives.create_item(item_params) do
      {:ok, item} ->
        Retrospectives.broadcast(socket.assigns.retro.id, {:item_created, item})
        {:noreply, push_event(socket, "clear_textarea", %{id: "item-input-#{item.column_id}"})}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not create item")}
    end
  end

  @impl true
  def handle_event("vote", %{"id" => id}, socket) do
    item = Retrospectives.get_item!(id)
    {:ok, updated_item} = Retrospectives.inc_item_votes(item)
    Retrospectives.broadcast(socket.assigns.retro.id, {:item_updated, updated_item})
    {:noreply, socket}
  end

  @impl true
  def handle_event("dislike", %{"id" => id}, socket) do
    item = Retrospectives.get_item!(id)
    {:ok, updated_item} = Retrospectives.inc_item_dislikes(item)
    Retrospectives.broadcast(socket.assigns.retro.id, {:item_updated, updated_item})
    {:noreply, socket}
  end

  @impl true
  def handle_event("save_action_item", %{"action_item" => params}, socket) do
    case Retrospectives.create_action_item(params) do
      {:ok, _action_item} ->
        item = Retrospectives.get_item!(params["item_id"]) |> RetroApp.Repo.preload([:action_items, :replies])
        Retrospectives.broadcast(socket.assigns.retro.id, {:item_updated, item})
        {:noreply, socket}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Could not create action item")}
    end
  end

  @impl true
  def handle_event("save_reply", %{"reply" => params}, socket) do
    case Retrospectives.create_reply(params) do
      {:ok, _reply} ->
        item = Retrospectives.get_item!(params["item_id"]) |> RetroApp.Repo.preload([:action_items, :replies])
        Retrospectives.broadcast(socket.assigns.retro.id, {:item_updated, item})
        {:noreply, socket}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Could not create reply")}
    end
  end

  @impl true
  def handle_info({:item_created, item}, socket) do
    retro = socket.assigns.retro
    columns = Enum.map(retro.columns, fn col ->
      if col.id == item.column_id do
        Map.update!(col, :items, &(&1 ++ [item]))
      else
        col
      end
    end)
    
    {:noreply, assign(socket, retro: %{retro | columns: columns})}
  end

  @impl true
  def handle_info({:item_updated, item}, socket) do
    retro = socket.assigns.retro
    columns = Enum.map(retro.columns, fn col ->
      if col.id == item.column_id do
        items = Enum.map(col.items, fn i -> if i.id == item.id, do: item, else: i end)
        # Sort items by vote count desc?
        # items = Enum.sort_by(items, &(&1.vote_count), :desc)
        %{col | items: items}
      else
        col
      end
    end)
    
    {:noreply, assign(socket, retro: %{retro | columns: columns})}
  end
end
