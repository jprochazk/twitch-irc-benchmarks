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
| C#       | 192.30 µs ± 0.78 µs           | dotnet 8.0.100-rc.2.23456.6         | [neon-sunset/warpskimmer](https://github.com/neon-sunset/warpskimmer/tree/b926d35901283c5414f3de20dfa748492711deda)       |                                                       |
| Go       | 732.53 µs (not qualified)[^1] | go1.20.6 linux/amd64                | [rod41732/go-twitch-irc-parser](https://github.com/rod41732/go-twitch-irc-parser/tree/v0.0.3.1)                           | See below                                             |
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

[^1]: This version has been present in the initial data before Round 0 and left as is as a reference. Otherwise, its result does not qualify because the implementation does not parse command type and prefix elements (hostmask).

### ARM64
```
Kernel: 23.0.0
OS:     macOS 14.0 23A5337a arm64 
CPU:    Apple M1 Pro
```
| Language | Time to parse 1K lines        | Version                                     | Library                                                                                                                   | Notes                                                 |
| -------- | ----------------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| C#       | 280.10 µs ± 0.38 µs           | dotnet 8.0.100-rc.2.23465.11                | [neon-sunset/warpskimmer](https://github.com/neon-sunset/warpskimmer/tree/b926d35901283c5414f3de20dfa748492711deda)       |                                                       |
| Rust     | 284.23 µs ± 0.30 µs           | rustc 1.72.0 (5680fa18f 2023-08-23)         | [jprochazk/twitch-rs](https://github.com/jprochazk/twitch-rs/tree/6c25b2f1bc5ad34b039bbb73c2bb2c0f599f88c4)               | Additionally parses tag keys to specific enum members |
| Go       | 702.25 µs (not qualified)[^1] | go1.21.1 darwin/arm64                       | [rod41732/go-twitch-irc-parser](https://github.com/rod41732/go-twitch-irc-parser/tree/v0.0.3.1)                           | See below                                             |
| C#       | 724.60 µs ± 0.67 µs           | dotnet 8.0.100-rc.2.23456.6                 | [TwitchLib/TwitchLib.Client](https://github.com/TwitchLib/TwitchLib.Client/tree/5fea08f8a4a91a0c9e5d0ccb17c3143a6992ff3d) |                                                       |
| Java     | 831.32 µs ± 3.77 µs           | openjdk 20.0.2 2023-07-18                   | [twitch4j/twitch4j](https://github.com/twitch4j/twitch4j/commit/33b50b76e42c3c17f9a5d91ac4f96594d223a5ec)                 |                                                       |
| Rust     | 1.329 ms ± 1.00 µs            | rustc 1.72.0 (5680fa18f 2023-08-23)         | [MoBlaa/irc_rust](https://github.com/MoBlaa/irc_rust/tree/4ae66fb3176b1d46cec6764f1a76aa6e9673d08b)                       |                                                       |
| C#       | 1.372 ms ± 1.97 µs            | dotnet 8.0.100-rc.2.23456.6                 | [Foretack/minitwitch](https://github.com/jprochazk/minitwitch-bench/tree/a5d2c7b7f5717ff00e6a2f29fd1c0099ff02a59d)        | Additionally parses emote sets, badges and more       |
| Go       | 1.848 ms                      | go1.21.1 darwin/arm64                       | [Mm2PL/justgrep](https://github.com/Mm2PL/justgrep/tree/v0.0.6)                                                           |                                                       |
| Java     | 2.345 ms ± 9.00 µs            | openjdk 19.0.2 2023-01-17                   | [Gikkman/Java-Twirk](https://github.com/Gikkman/Java-Twirk/tree/0.7.1)                                                    |                                                       |
| Rust     | 2.629 ms ± 2.40 µs            | rustc 1.72.0 (5680fa18f 2023-08-23)         | [robotty/twitch-irc](https://github.com/robotty/twitch-irc-rs/tree/v5.0.0)                                                |                                                       |
| Node.js  | 4.295 ms                      | node v20.6.1                                | [osslate/irc-message](https://github.com/osslate/irc-message/tree/v3.0.1)                                                 |                                                       |
| Go       | 5.079 ms                      | go1.21.1 darwin/arm64                       | [gempir/go-twitch-irc](https://github.com/jprochazk/go-twitch-irc/tree/v4.2.0)                                            |                                                       |
| Node.js  | 6.131 ms                      | node v20.6.1                                | [KararTY/dank-twitch-irc](https://github.com/KararTY/dank-twitch-irc/tree/v6.0.0)                                         |                                                       |
| Node.js  | 6.295 ms                      | node v20.6.1                                | [jprochazk/twitch_irc](https://github.com/jprochazk/twitch_irc/tree/0.11.2)                                               |                                                       |
| Node.js  | 7.651 ms                      | node v20.6.1                                | [twurple/twurple](https://github.com/twurple/twurple/tree/v6.2.1)                                                         |                                                       |