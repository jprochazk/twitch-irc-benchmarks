package io.github.jprochazk.irc;

import com.github.twitch4j.chat.util.MessageParser;
import org.openjdk.jmh.annotations.Benchmark;
import org.openjdk.jmh.annotations.BenchmarkMode;
import org.openjdk.jmh.annotations.Mode;
import org.openjdk.jmh.annotations.OutputTimeUnit;
import org.openjdk.jmh.annotations.Param;
import org.openjdk.jmh.annotations.Scope;
import org.openjdk.jmh.annotations.Setup;
import org.openjdk.jmh.annotations.State;
import org.openjdk.jmh.infra.Blackhole;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.concurrent.TimeUnit;

import static java.util.Collections.emptyList;
import static java.util.Collections.emptyMap;

@State(Scope.Thread)
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
public class Benchmarks {

    @Param("1000")
    public int count;

    private String[] messages;

    @Setup
    public void setUp() throws IOException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(getClass().getResourceAsStream("/data.txt")))) {
            this.messages = reader.lines().limit(count).toArray(String[]::new);
        }
    }

    @Benchmark
    public void testTwitch4J(Blackhole bh) {
        final int n = count;
        for (int i = 0; i < n; i++) {
            bh.consume(MessageParser.parse(messages[i], emptyMap(), emptyMap(), emptyList()));
        }
    }

}
