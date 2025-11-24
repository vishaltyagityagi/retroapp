defmodule RetroApp.Repo.Migrations.CreateRetrospectives do
  use Ecto.Migration

  def change do
    create table(:retrospectives) do
      add :title, :string
      add :slug, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:retrospectives, [:slug])
  end
end
