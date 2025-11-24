defmodule RetroApp.RetrospectivesTest do
  use RetroApp.DataCase

  alias RetroApp.Retrospectives

  describe "retrospectives" do
    alias RetroApp.Retrospectives.Retrospective

    import RetroApp.RetrospectivesFixtures

    @invalid_attrs %{title: nil, slug: nil}

    test "list_retrospectives/0 returns all retrospectives" do
      retrospective = retrospective_fixture()
      assert Retrospectives.list_retrospectives() == [retrospective]
    end

    test "get_retrospective!/1 returns the retrospective with given id" do
      retrospective = retrospective_fixture()
      assert Retrospectives.get_retrospective!(retrospective.id) == retrospective
    end

    test "create_retrospective/1 with valid data creates a retrospective" do
      valid_attrs = %{title: "some title", slug: "some slug"}

      assert {:ok, %Retrospective{} = retrospective} = Retrospectives.create_retrospective(valid_attrs)
      assert retrospective.title == "some title"
      assert retrospective.slug == "some slug"
    end

    test "create_retrospective/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retrospectives.create_retrospective(@invalid_attrs)
    end

    test "update_retrospective/2 with valid data updates the retrospective" do
      retrospective = retrospective_fixture()
      update_attrs = %{title: "some updated title", slug: "some updated slug"}

      assert {:ok, %Retrospective{} = retrospective} = Retrospectives.update_retrospective(retrospective, update_attrs)
      assert retrospective.title == "some updated title"
      assert retrospective.slug == "some updated slug"
    end

    test "update_retrospective/2 with invalid data returns error changeset" do
      retrospective = retrospective_fixture()
      assert {:error, %Ecto.Changeset{}} = Retrospectives.update_retrospective(retrospective, @invalid_attrs)
      assert retrospective == Retrospectives.get_retrospective!(retrospective.id)
    end

    test "delete_retrospective/1 deletes the retrospective" do
      retrospective = retrospective_fixture()
      assert {:ok, %Retrospective{}} = Retrospectives.delete_retrospective(retrospective)
      assert_raise Ecto.NoResultsError, fn -> Retrospectives.get_retrospective!(retrospective.id) end
    end

    test "change_retrospective/1 returns a retrospective changeset" do
      retrospective = retrospective_fixture()
      assert %Ecto.Changeset{} = Retrospectives.change_retrospective(retrospective)
    end
  end

  describe "columns" do
    alias RetroApp.Retrospectives.Column

    import RetroApp.RetrospectivesFixtures

    @invalid_attrs %{title: nil}

    test "list_columns/0 returns all columns" do
      column = column_fixture()
      assert Retrospectives.list_columns() == [column]
    end

    test "get_column!/1 returns the column with given id" do
      column = column_fixture()
      assert Retrospectives.get_column!(column.id) == column
    end

    test "create_column/1 with valid data creates a column" do
      retrospective = retrospective_fixture()
      valid_attrs = %{title: "some title", retrospective_id: retrospective.id}

      assert {:ok, %Column{} = column} = Retrospectives.create_column(valid_attrs)
      assert column.title == "some title"
    end

    test "create_column/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retrospectives.create_column(@invalid_attrs)
    end

    test "update_column/2 with valid data updates the column" do
      column = column_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Column{} = column} = Retrospectives.update_column(column, update_attrs)
      assert column.title == "some updated title"
    end

    test "update_column/2 with invalid data returns error changeset" do
      column = column_fixture()
      assert {:error, %Ecto.Changeset{}} = Retrospectives.update_column(column, @invalid_attrs)
      assert column == Retrospectives.get_column!(column.id)
    end

    test "delete_column/1 deletes the column" do
      column = column_fixture()
      assert {:ok, %Column{}} = Retrospectives.delete_column(column)
      assert_raise Ecto.NoResultsError, fn -> Retrospectives.get_column!(column.id) end
    end

    test "change_column/1 returns a column changeset" do
      column = column_fixture()
      assert %Ecto.Changeset{} = Retrospectives.change_column(column)
    end
  end

  describe "items" do
    alias RetroApp.Retrospectives.Item

    import RetroApp.RetrospectivesFixtures

    @invalid_attrs %{content: nil, vote_count: nil}

    test "list_items/0 returns all items" do
      item = item_fixture()
      item = Retrospectives.get_item!(item.id)
      assert Retrospectives.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      item = Retrospectives.get_item!(item.id)
      assert Retrospectives.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      column = column_fixture()
      valid_attrs = %{content: "some content", vote_count: 42, column_id: column.id}

      assert {:ok, %Item{} = item} = Retrospectives.create_item(valid_attrs)
      assert item.content == "some content"
      assert item.vote_count == 42
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retrospectives.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      update_attrs = %{content: "some updated content", vote_count: 43}

      assert {:ok, %Item{} = item} = Retrospectives.update_item(item, update_attrs)
      assert item.content == "some updated content"
      assert item.vote_count == 43
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      item = Retrospectives.get_item!(item.id)
      assert {:error, %Ecto.Changeset{}} = Retrospectives.update_item(item, @invalid_attrs)
      assert item == Retrospectives.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Retrospectives.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Retrospectives.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Retrospectives.change_item(item)
    end
  end

  describe "action_items" do
    alias RetroApp.Retrospectives.ActionItem

    import RetroApp.RetrospectivesFixtures

    @invalid_attrs %{content: nil, completed: nil}

    test "list_action_items/0 returns all action_items" do
      action_item = action_item_fixture()
      assert Retrospectives.list_action_items() == [action_item]
    end

    test "get_action_item!/1 returns the action_item with given id" do
      action_item = action_item_fixture()
      assert Retrospectives.get_action_item!(action_item.id) == action_item
    end

    test "create_action_item/1 with valid data creates a action_item" do
      item = item_fixture()
      valid_attrs = %{content: "some content", completed: true, item_id: item.id}

      assert {:ok, %ActionItem{} = action_item} = Retrospectives.create_action_item(valid_attrs)
      assert action_item.content == "some content"
      assert action_item.completed == true
    end

    test "create_action_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retrospectives.create_action_item(@invalid_attrs)
    end

    test "update_action_item/2 with valid data updates the action_item" do
      action_item = action_item_fixture()
      update_attrs = %{content: "some updated content", completed: false}

      assert {:ok, %ActionItem{} = action_item} = Retrospectives.update_action_item(action_item, update_attrs)
      assert action_item.content == "some updated content"
      assert action_item.completed == false
    end

    test "update_action_item/2 with invalid data returns error changeset" do
      action_item = action_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Retrospectives.update_action_item(action_item, @invalid_attrs)
      assert action_item == Retrospectives.get_action_item!(action_item.id)
    end

    test "delete_action_item/1 deletes the action_item" do
      action_item = action_item_fixture()
      assert {:ok, %ActionItem{}} = Retrospectives.delete_action_item(action_item)
      assert_raise Ecto.NoResultsError, fn -> Retrospectives.get_action_item!(action_item.id) end
    end

    test "change_action_item/1 returns a action_item changeset" do
      action_item = action_item_fixture()
      assert %Ecto.Changeset{} = Retrospectives.change_action_item(action_item)
    end
  end

  describe "replies" do
    alias RetroApp.Retrospectives.Reply

    import RetroApp.RetrospectivesFixtures

    @invalid_attrs %{content: nil}

    test "list_replies/0 returns all replies" do
      reply = reply_fixture()
      assert Retrospectives.list_replies() == [reply]
    end

    test "get_reply!/1 returns the reply with given id" do
      reply = reply_fixture()
      assert Retrospectives.get_reply!(reply.id) == reply
    end

    test "create_reply/1 with valid data creates a reply" do
      item = item_fixture()
      valid_attrs = %{content: "some content", item_id: item.id}

      assert {:ok, %Reply{} = reply} = Retrospectives.create_reply(valid_attrs)
      assert reply.content == "some content"
    end

    test "create_reply/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Retrospectives.create_reply(@invalid_attrs)
    end

    test "update_reply/2 with valid data updates the reply" do
      reply = reply_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Reply{} = reply} = Retrospectives.update_reply(reply, update_attrs)
      assert reply.content == "some updated content"
    end

    test "update_reply/2 with invalid data returns error changeset" do
      reply = reply_fixture()
      assert {:error, %Ecto.Changeset{}} = Retrospectives.update_reply(reply, @invalid_attrs)
      assert reply == Retrospectives.get_reply!(reply.id)
    end

    test "delete_reply/1 deletes the reply" do
      reply = reply_fixture()
      assert {:ok, %Reply{}} = Retrospectives.delete_reply(reply)
      assert_raise Ecto.NoResultsError, fn -> Retrospectives.get_reply!(reply.id) end
    end

    test "change_reply/1 returns a reply changeset" do
      reply = reply_fixture()
      assert %Ecto.Changeset{} = Retrospectives.change_reply(reply)
    end
  end
end
