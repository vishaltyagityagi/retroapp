defmodule RetroApp.Retrospectives.Retrospective do
  use Ecto.Schema
  import Ecto.Changeset

  schema "retrospectives" do
    field :title, :string
    field :slug, :string
    has_many :columns, RetroApp.Retrospectives.Column

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(retrospective, attrs) do
    retrospective
    |> cast(attrs, [:title, :slug])
    |> validate_required([:title, :slug])
    |> unique_constraint(:slug)
  end
end
