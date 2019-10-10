defmodule Issues.CLI do
  @moduledoc """
  Parse options passed on the CLI when calling the module
  """

  @default_count 4

  def run(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  `argv` can be -h or --help, which will return :help.

  Otherwise the arguments will be considered, in order:
  username, repository, number of commits (default: 4).

  Returns either a tuple of `{user, project, count}`, or `:help`.
  """
  def parse_args(argv) do
    OptionParser.parse(
      argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal_representation(_) do
    :help
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_descending()
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def sort_descending(issue_list) do
    issue_list
    |> Enum.sort(&(&1["created_at"] >= &2["created_at"]))
  end
end
