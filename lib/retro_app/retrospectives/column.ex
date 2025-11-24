defmodule RetroApp.Retrospectives.Column do
  use Ecto.Schema
  import Ecto.Changeset

  schema "columns" do
    field :title, :string
    belongs_to :retrospective, RetroApp.Retrospectives.Retrospective
    has_many :items, RetroApp.Retrospectives.Item

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(column, attrs) do
    column
    |> cast(attrs, [:title, :retrospective_id])
    |> validate_required([:title, :retrospective_id])
  end
end
