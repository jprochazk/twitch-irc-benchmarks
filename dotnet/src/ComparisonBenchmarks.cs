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
    private U8String[] utf8Lines = null!;
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
        utf8Lines = utf16Lines.Select(line => line.ToU8String()).ToArray();
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
    public void FeetlickerParse()
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
            _ = TwitchLib.ParseIrcMessage(line);
        }
    }
}
