# twitch-irc-benchmarks

The general outline of the benchmark:
- The first 1000 lines of `data.txt` are read and prepared during setup
- For each benchmark iteration, parse each line in a loop and discard the result

`data.txt` consists of roughly 200 thousand messages. The benchmarks only read the first 1000 lines from this file.

### Rust

Rust benchmarks use [criterion](https://github.com/bheisler/criterion.rs).

```
$ cd rust && cargo bench
```

`twitch-rs` uses the `simd` feature, which enables the parser implementation which uses SIMD instructions.
It can be disabled by removing the `simd` feature from the `Cargo.toml`.

`twitch-rs` also has support for a tag whitelist. Any tag which is not whitelisted will be ignored.
In the results below, the version of the benchmark using this feature is labelled `cheating`.

### C# .NET

C# benchmarks use [BenchmarkDotNet](https://github.com/dotnet/BenchmarkDotNet).

```
$ cd dotnet && DOTNET_TieredPGO=1 dotnet run -c Release
```

Benchmarks run with both JIT and AOT where possible.

### Go

Go benchmarks use the built-in benchmarking tool.

```
$ cd go && go test -bench=.
```

### Node

Node benchmarks use benchmark.js
```
cd node && npm i && node bench.js
```
### Gleam

Gleam benchmarks use glychee.
You need to run the benchmarks near the actual data.txt file, or else you will get assertion errors.

```
gleam clean && \
gleam build && \
erl -pa ./build/dev/erlang/*/ebin -noshell -eval 'orange_irc@@main:run(benchmark)'
```


## Results

Rows with `*` have a note in [#notes](#notes)

### x86

Benchmarks were run in WSL2 Ubuntu 22.04 on an AMD Ryzen 7950X

| library                                                                                                                         | language                                    | time to parse 1000 lines |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- | ------------------------ |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/f58e4cd5576a174724d371013651f569ad3a973d)                        | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 376.32 µs ± 0.82 µs      |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/f58e4cd5576a174724d371013651f569ad3a973d) (`-F simd`)            | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 188.91 µs ± 0.21 µs      |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/f58e4cd5576a174724d371013651f569ad3a973d) (`-F simd` + cheating) | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 173.84 µs ± 0.08 µs      |
| [robotty/twitch-irc](https://github.com/robotty/twitch-irc-rs/tree/v5.0.0)                                                      | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 1.7731 ms ± 11.52 µs     |
| [MoBlaa/irc_rust](https://github.com/MoBlaa/irc_rust/tree/4ae66fb3176b1d46cec6764f1a76aa6e9673d08b)                             | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 935.84 µs ± 2.17 µs      |
| [Mm2PL/justgrep](https://github.com/Mm2PL/justgrep/tree/v0.0.6)                                                                 | Go 1.20                                     | 1.395126 ms              |
| [gempir/go-twitch-irc](https://github.com/jprochazk/go-twitch-irc/tree/v4.2.0)                                                  | Go 1.20                                     | 3.75188 ms               |
| [rod41732/go-twitch-irc-parser](https://github.com/rod41732/go-twitch-irc-parser/tree/v0.0.3.1)                                 | Go 1.20                                     | 500.389 µs               |
| [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d)              | .NET 8.0.100-preview.4.23260.5              | 883.4 µs ± 4.78 µs       |
| [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d) (+ AOT)      | .NET 8.0.100-preview.4.23260.5              | 772.0 µs ± 5.27 µs       |
| [^2] [TwitchLib](https://github.com/TwitchLib/TwitchLib)                                                                            | .NET 8.0.100-preview.4.23260.5              | 5.8284 s ± 1.823 s       |
| [KararTY/dank-twitch-irc](https://github.com/KararTY/dank-twitch-irc/tree/v6.0.0)                                               | Node.js v20.3.0                             | 5.743 ms                 |
| [osslate/irc-message](https://github.com/osslate/irc-message/tree/v3.0.1)                                                       | Node.js v20.3.0                             | 3.068 ms                 |
| [jprochazk/twitch_irc](https://github.com/jprochazk/twitch_irc/tree/0.11.2)                                                     | Node.js v20.3.0                             | 5.855 ms                 |

### arm64

Benchmarks were run with macOS 13.4 running on an M2 MacBook Air 16 GB

| library                                                                                                                         | language                                    | time to parse 1000 lines |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- | ------------------------ |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/f58e4cd5576a174724d371013651f569ad3a973d)                        | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 590.32 µs ± 0.12 µs      |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/f58e4cd5576a174724d371013651f569ad3a973d) (`-F simd`)            | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 388.17 µs ± 1.33 µs      |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/f58e4cd5576a174724d371013651f569ad3a973d) (`-F simd` + cheating) | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 381.06 µs ± 0.92 µs      |
| [robotty/twitch-irc](https://github.com/robotty/twitch-irc-rs/tree/v5.0.0)                                                      | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 2.6460 ms ± 3.58 µs      |
| [MoBlaa/irc_rust](https://github.com/MoBlaa/irc_rust/tree/4ae66fb3176b1d46cec6764f1a76aa6e9673d08b)                             | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 1.4808 ms ± 7.71 µs      |
| [Mm2PL/justgrep](https://github.com/Mm2PL/justgrep/tree/v0.0.6)                                                                 | Go 1.20                                     | 1.707313 ms              |
| [gempir/go-twitch-irc](https://github.com/jprochazk/go-twitch-irc/tree/v4.2.0)                                                  | Go 1.20                                     | 4.714300 ms              |
| [rod41732/go-twitch-irc-parser](https://github.com/rod41732/go-twitch-irc-parser/tree/v0.0.3.1)                                 | Go 1.20                                     | 628.474 µs               |
| [^1] [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d)             | .NET 8.0.100-preview.4.23260.5              | 1.387 ms ± 0.0013 ms     |
| [^1] [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d) (+ AOT)     | .NET 8.0.100-preview.4.23260.5              | 1.263 ms ± 0.0119 ms     |
| [^2] [TwitchLib](https://github.com/TwitchLib/TwitchLib)                                                                            | .NET 8.0.100-preview.4.23260.5              | 2.387 s ± 0.721 s        |
| [KararTY/dank-twitch-irc](https://github.com/KararTY/dank-twitch-irc/tree/v6.0.0)                                               | Node.js v20.3.0                             | 5.391 ms                 |
| [osslate/irc-message](https://github.com/osslate/irc-message/tree/v3.0.1)                                                       | Node.js v20.3.0                             | 3.648 ms                 |
| [jprochazk/twitch_irc](https://github.com/jprochazk/twitch_irc/tree/0.11.2)                                                     | Node.js v20.3.0                             | 5.607 ms                 |


[^1]: `minitwitch` was not run with `DOTNET_TieredPGO=1` on arm64, because the benchmark segfaults.

[^2]: `TwitchLib` being measured in _seconds_ is not a mistake.

