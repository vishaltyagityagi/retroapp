defmodule RetroApp.RetrospectivesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RetroApp.Retrospectives` context.
  """

  @doc """
  Generate a unique retrospective slug.
  """
  def unique_retrospective_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a retrospective.
  """
  def retrospective_fixture(attrs \\ %{}) do
    {:ok, retrospective} =
      attrs
      |> Enum.into(%{
        slug: unique_retrospective_slug(),
        title: "some title"
      })
      |> RetroApp.Retrospectives.create_retrospective()

    retrospective
  end

  @doc """
  Generate a column.
  """
  def column_fixture(attrs \\ %{}) do
    retrospective = retrospective_fixture()

    {:ok, column} =
      attrs
      |> Enum.into(%{
        title: "some title",
        retrospective_id: retrospective.id
      })
      |> RetroApp.Retrospectives.create_column()

    column
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    column = column_fixture()

    {:ok, item} =
      attrs
      |> Enum.into(%{
        content: "some content",
        vote_count: 42,
        column_id: column.id
      })
      |> RetroApp.Retrospectives.create_item()

    item
  end

  @doc """
  Generate a action_item.
  """
  def action_item_fixture(attrs \\ %{}) do
    item = item_fixture()

    {:ok, action_item} =
      attrs
      |> Enum.into(%{
        completed: true,
        content: "some content",
        item_id: item.id
      })
      |> RetroApp.Retrospectives.create_action_item()

    action_item
  end

  @doc """
  Generate a reply.
  """
  def reply_fixture(attrs \\ %{}) do
    item = item_fixture()

    {:ok, reply} =
      attrs
      |> Enum.into(%{
        content: "some content",
        item_id: item.id
      })
      |> RetroApp.Retrospectives.create_reply()

    reply
  end
end
