mkdir output

echo "\nRunning Rust..."
cd rust && cargo bench >> ../results/rust.txt && cd ..

echo "\nRunning .NET..."
cd dotnet/src && dotnet run -c Release >> ../../results/dotnet.txt && cd ../..

echo "\nRunning Java..."
cd jvm && ./gradlew clean && ./gradlew jmh >> ../results/java.txt && cd ..

echo "\nRunning Go..."
cd go && go test -bench=. >> ../results/go.txt && cd ..

echo "\nRunning Node.js..."
cd node && npm i && node bench.js >> ../results/node.txt && cd ..

# TODO: iterate through result files and parse them into a round summary