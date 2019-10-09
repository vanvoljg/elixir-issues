defmodule Issues.CLI do
  @moduledoc """
  Parse options passed on the CLI when calling the module
  """

  @default_count 4

  def run(argv) do
    parse_args(argv)
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
end
