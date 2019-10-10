defmodule CliTest do
  use ExUnit.Case, async: true
  doctest Issues

  import Issues.CLI, only: [parse_args: 1, sort_descending: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) === :help
    assert parse_args(["--help", "anything"]) === :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) === {"user", "project", 99}
  end

  test "count is default (4) if two values are given" do
    assert parse_args(["user", "project"]) === {"user", "project", 4}
  end

  test ":help returned when no options given" do
    assert parse_args([""]) === :help
  end

  test "sort_descending correctly sorts items" do
    result = sort_descending(create_fake_issue_map(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues === ~w{ c b a }
  end

  defp create_fake_issue_map(list) do
    for value <- list,
        do: %{"created_at" => value, "other_data" => "xxx"}
  end
end
