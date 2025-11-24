defmodule RetroApp.Retrospectives.ActionItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "action_items" do
    field :content, :string
    field :completed, :boolean, default: false
    belongs_to :item, RetroApp.Retrospectives.Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(action_item, attrs) do
    action_item
    |> cast(attrs, [:content, :completed, :item_id])
    |> validate_required([:content, :completed, :item_id])
  end
end
