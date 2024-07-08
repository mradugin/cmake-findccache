cmake_minimum_required(VERSION 3.27)

set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded)
cmake_policy(SET CMP0141 NEW)

project(TestCcache)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/..")

find_package(ccache)

add_executable(${PROJECT_NAME} main.cpp)
