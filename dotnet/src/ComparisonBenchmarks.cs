using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Jobs;
using Warpskimmer;
using U8Primitives;
using TwitchLib.Client.Parsing;

namespace libs_comparison;

[MemoryDiagnoser]
[SimpleJob, SimpleJob(RuntimeMoniker.NativeAot80)]
public class ComparisonBenchmarks
{
    private U8String[] utf8Lines = null!;
    private string[] utf16Lines = null!;

    [GlobalSetup]
    public void AddData()
    {
        try
        {
            utf16Lines = File.ReadLines("data.txt").Take(1000).ToArray();
        }
        catch (FileNotFoundException)
        {
            utf16Lines = File.ReadLines("../../data.txt").Take(1000).ToArray();
        }
        utf8Lines = utf16Lines.Select(U8String.Create).ToArray();
    }

    [Benchmark]
    public void MiniTwitchParse()
    {
        foreach (var line in utf8Lines)
        {
            MiniTwitch.Process(line);
        }
    }

    [Benchmark]
    public void WarpskimmerParse()
    {
        foreach (var line in utf8Lines)
        {
            _ = Message.Parse(line);
        }
    }

    [Benchmark]
    public void TwitchLibParse()
    {
        foreach (var line in utf16Lines)
        {
            _ = IrcParser.ParseMessage(line);
        }
    }
}
