defmodule RetroApp.Repo.Migrations.CreateActionItems do
  use Ecto.Migration

  def change do
    create table(:action_items) do
      add :content, :string
      add :completed, :boolean, default: false, null: false
      add :item_id, references(:items, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:action_items, [:item_id])
  end
end
