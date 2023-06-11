import { parseIRCMessage } from "@kararty/dank-twitch-irc";
import Benchmark from "benchmark";
import fs from "fs";
import ircMsg from "irc-message";

const data = fs.readFileSync("../data.txt", "utf-8");
const lines = data.split('\n').slice(0, 1000);

const UNITS = ["s", "ms", "μs", "ns", "ps"];
function hz_to_iter(hz) {
    let n_per_iter = 1 / hz;
    let unit = 0;

    while (n_per_iter < 1) {
        n_per_iter *= 1000;
        unit += 1;
    }

    return `${n_per_iter.toFixed(3)} ${UNITS[unit]}/iter`;
}

const suite = new Benchmark.Suite("Parsing");
suite
    .add("dank-twitch-irc", () => {
        for (let i = 0; i < lines.length; i++) {
            const ircMessage = parseIRCMessage(lines[i]);
        }
    })
    .add("irc-message parse", () => {
        for (let i = 0; i < lines.length; i++) {
            const ircMessage = ircMsg.parse(lines[i]);
        }
    })
    // TODO: make buffered irc-message benchmark
    .on('cycle', (event) => {
        const name = event.target.name;
        const iter = hz_to_iter(event.target.hz);
        const samples = event.target.stats.sample.length;
        console.log(`${name}: ${iter} (${samples} samples)`);
    });

suite.run();
