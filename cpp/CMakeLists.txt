cmake_minimum_required(VERSION 3.20)

project(twitch-irc-benchmarks VERSION 0.1.0)

set(MAJOR_QT_VERSION 6)
set(BUILD_WITH_QT6 On)
set(CMAKE_CXX_STANDARD 20)

find_package(Qt6 REQUIRED COMPONENTS Core Test)

add_subdirectory(lib/libcommuni EXCLUDE_FROM_ALL)
add_subdirectory(lib/googletest EXCLUDE_FROM_ALL)
add_subdirectory(lib/benchmark EXCLUDE_FROM_ALL)

qt_standard_project_setup()
set(CMAKE_AUTOMOC ON)

qt_add_executable(bench bench.cpp)

target_link_libraries(bench PRIVATE LibCommuni::LibCommuni Qt6::Core benchmark::benchmark)
