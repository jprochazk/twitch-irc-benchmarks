using BenchmarkDotNet.Configs;
using BenchmarkDotNet.Jobs;
using BenchmarkDotNet.Running;
using BenchmarkDotNet.Toolchains.InProcess.NoEmit;
using libs_comparison;
using Microsoft.Extensions.DependencyInjection;

BenchmarkRunner.Run<ComparisonBenchmarks>();
