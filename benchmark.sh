rm -rf output/
mkdir output

echo "\nRunning Rust..."
cd rust && cargo bench >> ../output/rust.txt && cd ..

echo "\nRunning .NET..."
cd dotnet/src && dotnet run -c Release >> ../../output/dotnet.txt && cd ../..

echo "\nRunning Java..."
cd jvm && ./gradlew clean && ./gradlew jmh >> ../output/java.txt && cd ..

echo "\nRunning Go..."
cd go && go test -bench=. >> ../output/go.txt && cd ..

echo "\nRunning Node.js..."
cd node && npm i && node bench.js >> ../output/node.txt && cd ..

# TODO: iterate through result files and parse them into a round summary