plugins {
    id("me.champeau.jmh").version("0.7.1")
}

repositories {
    mavenCentral()
}

jmh {
    resultFormat = "TEXT"
}

dependencies {
    jmh("com.github.twitch4j:twitch4j:1.16.0")
}
