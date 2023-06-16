using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Jobs;
using Feetlicker;
using forsen;
using U8Primitives;

namespace libs_comparison;

[MemoryDiagnoser]
[SimpleJob, SimpleJob(RuntimeMoniker.NativeAot80)]
public class ComparisonBenchmarks
{
    private U8String[] dataLines = null!;
    private string[] utf16Lines = null!;

    [GlobalSetup]
    public void AddData()
    {
        try
        {
            utf16Lines = File.ReadLines("data.txt").Take(1000).ToArray();
        }
        catch (Exception e)
        {
            _ = e;
            utf16Lines = File.ReadLines("../../data.txt").Take(1000).ToArray();
        }
        dataLines = utf16Lines.Select(line => line.ToU8String()).ToArray();
    }

    [Benchmark]
    public void MiniTwitchParse()
    {
        foreach (var line in dataLines)
        {
            MiniTwitch.Process(line);
        }
    }

    [Benchmark]
    public void FeetlickerParse()
    {
        foreach (var line in dataLines)
        {
            _ = Message.Parse(line);
        }
    }

    [Benchmark, IterationCount(5), WarmupCount(5)]
    public void TwitchLibParse()
    {
        foreach (var line in utf16Lines)
        {
            TwitchLib.HandleIrcMessage(TwitchLib.ParseIrcMessage(line));
        }
    }
}
