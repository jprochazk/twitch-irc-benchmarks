plugins {
    id("me.champeau.jmh").version("0.7.1")
}

repositories {
    mavenCentral()
    maven { setUrl("https://jitpack.io") }
}

jmh {
    resultFormat = "TEXT"
}

dependencies {
    jmh("com.github.twitch4j:twitch4j:1.17.0")
    jmh("com.github.gikkman:Java-Twirk:0.7.1")
}
