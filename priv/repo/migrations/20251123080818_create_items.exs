defmodule RetroApp.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :content, :text
      add :vote_count, :integer
      add :column_id, references(:columns, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:items, [:column_id])
  end
end
