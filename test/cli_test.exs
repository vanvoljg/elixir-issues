defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI

  test "run calls parse_args" do
    assert run([]) === :help
  end

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
end
