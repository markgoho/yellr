defmodule Yellr.Command.CreateProject do
  alias Yellr.Validators.CreateProjectRequest
  alias Yellr.Data.Project
  alias Yellr.Repo

  def create_project_from_params(params) do
    cs = CreateProjectRequest.new(params)
    case cs.valid? do
      false -> {:error, cs}
      _ -> create_models_and_queue_events(cs)
    end
  end

  defp create_models_and_queue_events(changeset) do
    create_project_request = Ecto.Changeset.apply_changes(changeset)
    p_cs = Project.changeset(
      %Project{},
      %{
        name: create_project_request.name,
        repository_url: create_project_request.repository_url
      }
    )
    Repo.insert(p_cs)
  end
end
