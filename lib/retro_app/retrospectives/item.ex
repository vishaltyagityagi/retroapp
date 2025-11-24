defmodule RetroApp.Retrospectives.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :content, :string
    field :vote_count, :integer, default: 0
    field :dislike_count, :integer, default: 0
    belongs_to :column, RetroApp.Retrospectives.Column
    has_many :action_items, RetroApp.Retrospectives.ActionItem
    has_many :replies, RetroApp.Retrospectives.Reply

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:content, :vote_count, :dislike_count, :column_id])
    |> validate_required([:content, :vote_count, :column_id])
  end
end
