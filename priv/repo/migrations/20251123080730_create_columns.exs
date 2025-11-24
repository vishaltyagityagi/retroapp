defmodule RetroApp.Repo.Migrations.CreateColumns do
  use Ecto.Migration

  def change do
    create table(:columns) do
      add :title, :string
      add :retrospective_id, references(:retrospectives, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:columns, [:retrospective_id])
  end
end
