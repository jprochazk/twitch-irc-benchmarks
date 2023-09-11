# twitch-irc-benchmarks

The general outline of the benchmark:
- The first 1000 lines of `data.txt` are read and prepared during setup
- For each benchmark iteration, parse each line in a loop and discard the result

`data.txt` consists of roughly 200 thousand messages. The benchmarks only read the first 1000 lines from this file.

## Rules

A parsed Twitch IRCv3 message should be represented by a type that exposes the following eagerly-evaluated members:
- Tags (a collection of string key-value pairs)
- Prefix (string values of user and host or nickname, user and host)
- Command (an enum member or a specific type bound to respective command type)
- Channel (a string value of the channel the message originates from)
- Parameters (a string value or a collection of string values representing message arguments)

More specific types which conform to the API defined by the rules are allowed. For example:
- Custom tag collection type which still represents a collection of key-value like tags
- Strongly types tags where key is represented by a specific enum value
- More specific root Message type bound to a specific command type, which logically preserves message+command type information

## Round 0 Results

### X86_64

```
Kernel: 5.15.90.1-microsoft-standard-WSL2
OS:     Ubuntu 22.04.3 LTS on Windows 10 x86_64 
CPU:    AMD Ryzen 7 5800X (16)
```

| Language | Time to parse 1K lines        | Version                             | Library                                                                                                                   | Notes                                                 |
| -------- | ----------------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| Rust     | 186.88 µs ± 0.80 µs           | rustc 1.72.0 (5680fa18f 2023-08-23) | [jprochazk/twitch-rs](https://github.com/jprochazk/twitch-rs/tree/6c25b2f1bc5ad34b039bbb73c2bb2c0f599f88c4)               | Additionally parses tag keys to specific enum members |
| C#       | 192.30 µs ± 0.78 µs           | dotnet 8.0.100-rc.2.23456.6         | [neon-sunset/warpskimmer](https://github.com/neon-sunset/warpskimmer/tree/4d8589d2f573b31e82527507f7f4d70210b2cb31)       |                                                       |
| Go       | 732.53 µs (not qualified[^1]) | go1.20.6 linux/amd64              | [rod41732/go-twitch-irc-parser](https://github.com/rod41732/go-twitch-irc-parser/tree/v0.0.3.1)                             | See below                                             |
| Java     | 776.88 µs ± 6.38 µs           | openjdk 19.0.2 2023-01-17           | [twitch4j/twitch4j](https://github.com/twitch4j/twitch4j/commit/33b50b76e42c3c17f9a5d91ac4f96594d223a5ec)                 |                                                       |
| C#       | 777.20 µs ± 6.58 µs           | dotnet 8.0.100-rc.2.23456.6         | [TwitchLib/TwitchLib.Client](https://github.com/TwitchLib/TwitchLib.Client/tree/5fea08f8a4a91a0c9e5d0ccb17c3143a6992ff3d) |                                                       |
| C#       | 1.158 ms ± 2.01 µs            | dotnet 8.0.100-rc.2.23456.6         | [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d)        | Additionally parses emote sets, badges and more       |
| Rust     | 1.193 ms ± 4 µs               | rustc 1.72.0 (5680fa18f 2023-08-23) | [MoBlaa/irc_rust](https://github.com/MoBlaa/irc_rust/tree/4ae66fb3176b1d46cec6764f1a76aa6e9673d08b)                       |                                                       |
| Go       | 1.657 ms                      | go1.20.6 linux/amd64                | [Mm2PL/justgrep](https://github.com/Mm2PL/justgrep/tree/v0.0.6)                                                           |                                                       |
| Rust     | 2.293 ms ± 15 µs              | rustc 1.72.0 (5680fa18f 2023-08-23) | [robotty/twitch-irc](https://github.com/robotty/twitch-irc-rs/tree/v5.0.0)                                                |                                                       |
| Java     | 2.506 ms ± 6.383 µs           | openjdk 19.0.2 2023-01-17           | [Gikkman/Java-Twirk](https://github.com/Gikkman/Java-Twirk/tree/0.7.1)                                                    |                                                       |
| Node.js  | 4.318 ms                      | node v20.6.1                        | [osslate/irc-message](https://github.com/osslate/irc-message/tree/v3.0.1)                                                 |                                                       |
| Go       | 5.218 ms                      | go1.20.6 linux/amd64                | [gempir/go-twitch-irc](https://github.com/jprochazk/go-twitch-irc/tree/v4.2.0)                                            |                                                       |
| Node.js  | 7.510 ms                      | node v20.6.1                        | [KararTY/dank-twitch-irc](https://github.com/KararTY/dank-twitch-irc/tree/v6.0.0)                                         |                                                       |
| Node.js  | 7.832 ms                      | node v20.6.1                        | [jprochazk/twitch_irc](https://github.com/jprochazk/twitch_irc/tree/0.11.2)                                               |                                                       |
| Node.js  | 8.084 ms                      | node v20.6.1                        | [twurple/twurple](https://github.com/twurple/twurple/tree/v6.2.1)                                                         |                                                       |

[^1]: Because this version has been present in the initial data before Round 0, it is left as is. Otherwise, it does not parse command type and prefix elements (hostmask) does not qualify as a result.

### Rust

[Install Rust](https://www.rust-lang.org/tools/install) (rustup is *highly* recommended)

Rust benchmarks use [criterion](https://github.com/bheisler/criterion.rs).

```
$ cd rust && cargo bench
```

`twitch-rs` uses the `simd` feature, which enables the parser implementation which uses SIMD instructions.
It can be disabled by removing the `simd` feature from the `Cargo.toml`.

`twitch-rs` also has support for a tag whitelist. Any tag which is not whitelisted will be ignored.
In the results below, the version of the benchmark using this feature is labelled `cheating`.

### C# .NET

[Install .NET](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) (on unix, I recommend [dotnet-install scripts](https://dotnet.microsoft.com/en-us/download/dotnet/scripts))

C# benchmarks use [BenchmarkDotNet](https://github.com/dotnet/BenchmarkDotNet).

```
$ cd dotnet/src && dotnet run -c Release
```

Benchmarks run with both JIT and AOT where possible.

### Go

[Install Go](https://go.dev/doc/install) (on unix, I recommend [golang-tools-install-script](https://github.com/canha/golang-tools-install-script))

Go benchmarks use the built-in benchmarking tool.

```
$ cd go && go test -bench=.
```

### Node

[Install Node](https://nodejs.org/en/download) (on unix, I recommend [nvm](https://github.com/nvm-sh/nvm))

Node benchmarks use benchmark.js
```
cd node && npm i && node bench.js
```
### Gleam

To run the `gleam` benchmark, you need to install:
- Erlang
- Gleam
- Elixir
- Rebar3

Gleam benchmarks use glychee.

```
$ cd gleam && gleam run
```

### Java

[Install JDK](https://adoptium.net/temurin/releases/?version=20) (on unix, I recommend [Temurin packages](https://adoptium.net/installation/linux/))

JVM benchmarks use [Java Microbenchmark Harness (JMH)](https://openjdk.org/projects/code-tools/jmh).

```
$ cd jvm && ./gradlew jmh
```

### License

Licensed under either of

- Apache License, Version 2.0
  ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license
  ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.
