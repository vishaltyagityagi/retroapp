defmodule RetroApp.Repo.Migrations.AddFeaturesToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :dislike_count, :integer, default: 0
    end
  end
end
