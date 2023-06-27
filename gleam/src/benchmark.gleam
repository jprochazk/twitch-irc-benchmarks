import gleam/int
import gleam/list
import glychee/benchmark
import orange_tmi
import gleam/erlang/file
import gleam/string

pub fn main() {
  benchmark.run(
    [
      benchmark.Function(
        label: "orange_tmi.parse_irc",
        callable: fn(test_data) {
          fn() { list.map(test_data, orange_tmi.parse_irc) }
        },
      ),
    ],
    [
      benchmark.Data(
        label: "First 1000 lines",
        data: {
          let assert Ok(file_content) = file.read("data.txt")
          string.split(file_content, "\n")
          |> list.take(1000)
        },
      ),
    ],
  )
}
