# twitch-irc-benchmarks

The general outline of the benchmark:
- The first 1000 lines of `data.txt` are read and prepared during setup
- For each benchmark iteration, parse each line in a loop and discard the result

`data.txt` consists of roughly 200 thousand messages. The benchmarks only read the first 1000 lines from this file.

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

## Results

### x86

Benchmarks were run in WSL2 Ubuntu 22.04 on an AMD Ryzen 7950X

| library                                                                                                                         | language                                    | time to parse 1000 lines |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- | ------------------------ |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/13fdd348ca0a25bd7b3b2a11c74733e6c63eacad) (`-F simd` + cheating) | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 173.84 µs ± 0.08 µs      |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/13fdd348ca0a25bd7b3b2a11c74733e6c63eacad) (`-F simd`)            | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 188.91 µs ± 0.21 µs      |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/13fdd348ca0a25bd7b3b2a11c74733e6c63eacad)                        | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 376.32 µs ± 0.82 µs      |
| [neon-sunset/feetlicker](https://github.com/neon-sunset/feetlicker/tree/1cc232e263b3746b08400e7eb6f52af1549a0a98) (+ AOT)       | .NET 8.0.100-preview.5.23303.2              | 381.3 µs ± 0.29 µs       |
| [neon-sunset/feetlicker](https://github.com/neon-sunset/feetlicker/tree/1cc232e263b3746b08400e7eb6f52af1549a0a98)               | .NET 8.0.100-preview.5.23303.2              | 436.3 µs ± 0.31 µs       |
| [rod41732/go-twitch-irc-parser](https://github.com/rod41732/go-twitch-irc-parser/tree/v0.0.3.1)                                 | Go 1.20                                     | 500.389 µs               |
| [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d) (+ AOT)      | .NET 8.0.100-preview.5.23303.2              | 772.0 µs ± 5.27 µs       |
| [^1] [TwitchLib](https://github.com/TwitchLib/TwitchLib) (+ AOT)                                                                | .NET 8.0.100-preview.5.23303.2              | 844.8 µs ± 4.13 µs       |
| [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d)              | .NET 8.0.100-preview.5.23303.2              | 883.4 µs ± 4.78 µs       |
| [MoBlaa/irc_rust](https://github.com/MoBlaa/irc_rust/tree/4ae66fb3176b1d46cec6764f1a76aa6e9673d08b)                             | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 935.84 µs ± 2.17 µs      |
| [^1] [TwitchLib](https://github.com/TwitchLib/TwitchLib)                                                                        | .NET 8.0.100-preview.5.23303.2              | 946.9 µs ± 2.83 µs       |
| [Mm2PL/justgrep](https://github.com/Mm2PL/justgrep/tree/v0.0.6)                                                                 | Go 1.20                                     | 1.395126 ms              |
| [robotty/twitch-irc](https://github.com/robotty/twitch-irc-rs/tree/v5.0.0)                                                      | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 1.7731 ms ± 11.52 µs     |
| [osslate/irc-message](https://github.com/osslate/irc-message/tree/v3.0.1)                                                       | Node.js v20.3.0                             | 3.068 ms                 |
| [gempir/go-twitch-irc](https://github.com/jprochazk/go-twitch-irc/tree/v4.2.0)                                                  | Go 1.20                                     | 3.75188 ms               |
| [KararTY/dank-twitch-irc](https://github.com/KararTY/dank-twitch-irc/tree/v6.0.0)                                               | Node.js v20.3.0                             | 5.743 ms                 |
| [jprochazk/twitch_irc](https://github.com/jprochazk/twitch_irc/tree/0.11.2)                                                     | Node.js v20.3.0                             | 5.855 ms                 |

### arm64

Benchmarks were run with macOS 13.4 running on an M2 MacBook Air 16 GB

| library                                                                                                                         | language                                    | time to parse 1000 lines |
| ------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- | ------------------------ |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/13fdd348ca0a25bd7b3b2a11c74733e6c63eacad) (`-F simd` + cheating) | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 287.02 µs ± 0.06 µs      |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/13fdd348ca0a25bd7b3b2a11c74733e6c63eacad) (`-F simd`)            | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 287.73 µs ± 0.08 µs      |
| [jprochazk/twitch](https://github.com/jprochazk/twitch-rs/tree/13fdd348ca0a25bd7b3b2a11c74733e6c63eacad)                        | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 345.59 µs ± 0.12 µs      |
| [neon-sunset/feetlicker](https://github.com/neon-sunset/feetlicker/tree/1cc232e263b3746b08400e7eb6f52af1549a0a98) (+ AOT)       | .NET 8.0.100-preview.5.23303.2              | 407.1 µs ± 0.45 µs       |
| [neon-sunset/feetlicker](https://github.com/neon-sunset/feetlicker/tree/1cc232e263b3746b08400e7eb6f52af1549a0a98)               | .NET 8.0.100-preview.5.23303.2              | 444.9 µs ± 0.25 µs       |
| [rod41732/go-twitch-irc-parser](https://github.com/rod41732/go-twitch-irc-parser/tree/v0.0.3.1)                                 | Go 1.20                                     | 628.474 µs               |
| [^1] [TwitchLib](https://github.com/TwitchLib/TwitchLib)                                                                        | .NET 8.0.100-preview.5.23303.2              | 858.5 ± 0.69 µs          |
| [^1] [TwitchLib](https://github.com/TwitchLib/TwitchLib) (+ AOT)                                                                | .NET 8.0.100-preview.5.23303.2              | 1.083 ms ± 0.29 µs       |
| [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d) (+ AOT)      | .NET 8.0.100-preview.5.23303.2              | 1.263 ms ± 0.0119 ms     |
| [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d)              | .NET 8.0.100-preview.5.23303.2              | 1.387 ms ± 0.0013 ms     |
| [MoBlaa/irc_rust](https://github.com/MoBlaa/irc_rust/tree/4ae66fb3176b1d46cec6764f1a76aa6e9673d08b)                             | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 1.4808 ms ± 7.71 µs      |
| [Mm2PL/justgrep](https://github.com/Mm2PL/justgrep/tree/v0.0.6)                                                                 | Go 1.20                                     | 1.707313 ms              |
| [robotty/twitch-irc](https://github.com/robotty/twitch-irc-rs/tree/v5.0.0)                                                      | rustc 1.72.0-nightly (101fa903b 2023-06-04) | 2.6460 ms ± 3.58 µs      |
| [osslate/irc-message](https://github.com/osslate/irc-message/tree/v3.0.1)                                                       | Node.js v20.3.0                             | 3.648 ms                 |
| [gempir/go-twitch-irc](https://github.com/jprochazk/go-twitch-irc/tree/v4.2.0)                                                  | Go 1.20                                     | 4.714300 ms              |
| [KararTY/dank-twitch-irc](https://github.com/KararTY/dank-twitch-irc/tree/v6.0.0)                                               | Node.js v20.3.0                             | 5.391 ms                 |
| [jprochazk/twitch_irc](https://github.com/jprochazk/twitch_irc/tree/0.11.2)                                                     | Node.js v20.3.0                             | 5.607 ms                 |


[^1]: `TwitchLib` was previously at least three orders of magnitude slower than anything else,
      and it is important to note that it is still extremely slow in practice, because the
      [message handler method causes the GC to choke and die](https://github.com/jprochazk/twitch-irc-benchmarks/pull/12)

