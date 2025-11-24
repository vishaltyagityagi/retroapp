defmodule RetroApp.Retrospectives.Reply do
  use Ecto.Schema
  import Ecto.Changeset

  schema "replies" do
    field :content, :string
    belongs_to :item, RetroApp.Retrospectives.Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reply, attrs) do
    reply
    |> cast(attrs, [:content, :item_id])
    |> validate_required([:content, :item_id])
  end
end
