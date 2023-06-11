using System.Text;
using BenchmarkDotNet.Attributes;
using BenchmarkDotNet.Jobs;
using forsen;

namespace libs_comparison;

[MemoryDiagnoser]
[SimpleJob, SimpleJob(RuntimeMoniker.NativeAot80)]
public class ComparisonBenchmarks
{
    private byte[][] dataLines = null!;
    private string[] stringLines = null!;

    [GlobalSetup]
    public void AddData()
    {
        stringLines = File.ReadLines("data.txt").Take(1000).ToArray();
        dataLines = stringLines.Select(Encoding.UTF8.GetBytes).ToArray();
    }

    [Benchmark]
    public void MiniTwitchParse()
    {
        foreach (var item in dataLines)
        {
            MiniTwitch.Process(item);
        }
    }

    /* [Benchmark]
    public void TwitchLibParse()
    {
        foreach (string item in stringLines)
        {
            TwitchLib.HandleIrcMessage(TwitchLib.ParseIrcMessage(item));
        }
    } */
}
