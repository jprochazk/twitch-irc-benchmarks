defmodule TwitchBenchTest do
  use ExUnit.Case

  test "run bench" do
    data = File.read!("data.txt") |> String.split("\n") |> Enum.take(1000)

    Benchee.run(%{
      "parse_irc" => fn -> Enum.map(data, fn line -> Parser.parse_irc(line) end) end
    })
  end
end
