defmodule Issues.GithubIssues do
  @headers [{"User-Agent", "Jesse vanvoljg@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    issues_url(user, project)
    |> Tesla.get(headers: @headers)
    |> handle_response()
  end

  def issues_url(user, project) do
    "#{@github_url}/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status: status, body: body}}) do
    {
      status |> check_for_error(),
      body |> Jason.decode!()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
