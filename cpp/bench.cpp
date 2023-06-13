#include "ircmessage_p.h"
#include <IrcMessage>
#include <QDir>
#include <QFile>
#include <benchmark/benchmark.h>
#include <qbytearrayview.h>
#include <unordered_map>

static QList<QByteArray> readLines() {
  auto dir = QDir(__FILE__);
  dir.cdUp(); // -> actual directory
  dir.cdUp(); // -> repo
  auto file = QFile(dir.filePath("data.txt"));
  auto open = file.open(QFile::ReadOnly | QFile::Text);
  Q_ASSERT_X(open, "IrcBenchmark", "Cannot open data.txt");

  QList<QByteArray> lines;
  while (!file.atEnd() && lines.length() < 1000) {
    lines.append(file.readLine());
  }

  return lines;
}

static void BM_IrcParse(benchmark::State &state) {
  auto lines = readLines();

  for (auto _ : state) {
    for (const auto &arr : lines) {
      auto *msg = Communi::IrcMessage::fromData(arr, nullptr);
      msg->deleteLater();
    }
  }
}

static void BM_IrcMessageDataParse(benchmark::State &state) {
  auto lines = readLines();

  for (auto _ : state) {
    for (const auto &arr : lines) {
      auto msg = Communi::IrcMessageData::fromData(arr);
      ::benchmark::DoNotOptimize(msg);
    }
  }
}

// From ircmessage_p.h
// Uses views over owned arrays
class IrcMessageData2 {
public:
  static IrcMessageData2 fromData(const QByteArray &data);

  QByteArray content;
  QByteArrayView prefix;
  QByteArrayView command;
  std::vector<QByteArrayView> params;
  std::vector<std::pair<QLatin1StringView, QLatin1StringView>> tags;
};

static void BM_IrcMessageData2Parse(benchmark::State &state) {
  auto lines = readLines();

  for (auto _ : state) {
    for (const auto &arr : lines) {
      auto msg = IrcMessageData2::fromData(arr);
      ::benchmark::DoNotOptimize(msg);
    }
  }
}

// Fully parsed
BENCHMARK(BM_IrcParse);
// Just the data
BENCHMARK(BM_IrcMessageDataParse);
// Just the data, but using views
BENCHMARK(BM_IrcMessageData2Parse);

BENCHMARK_MAIN();

IrcMessageData2 IrcMessageData2::fromData(const QByteArray &data) {
  IrcMessageData2 message;
  message.content = data;

  QByteArrayView process = data;

  // parse <tags>
  if (process.startsWith('@')) {
    message.tags.reserve(16);
    process = process.sliced(1);
    auto tags = process.left(process.indexOf(' '));
    for (const auto tag : QLatin1String(tags).tokenize(u';')) {
      const int idx = tag.indexOf('=');
      if (idx != -1)
        message.tags.emplace_back(tag.left(idx), tag.mid(idx + 1));
      else
        message.tags.emplace_back(tag, QLatin1String{});
    }
    process = process.sliced(tags.length() + 1);
  }

  // parse <prefix>
  if (process.startsWith(':')) {
    message.prefix = process.left(process.indexOf(' '));
    process = process.sliced(message.prefix.length() + 1);
  } else {
    // empty (not null)
    message.prefix = QByteArrayLiteral("");
  }

  // parse <command>
  message.command = process.mid(0, process.indexOf(' '));
  process = process.sliced(message.command.length() + 1);

  // parse <params>
  message.params.reserve(2);
  while (!process.isEmpty()) {
    if (process.startsWith(':')) {
      process = process.sliced(1);
      message.params.push_back(process);
      break;
    } else {
      auto param = process.mid(0, process.indexOf(' '));
      process = process.sliced(param.length() + 1);
      message.params.push_back(param);
    }
  }

  return std::move(message);
}
