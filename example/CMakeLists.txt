# CMake version 3.25 or newer is required to use CMAKE_MSVC_DEBUG_INFORMATION_FORMAT, 
# for other cases CMake version requirement can be lowered
cmake_minimum_required(VERSION 3.25) 

set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded)
cmake_policy(SET CMP0141 NEW)

project(TestCcache)

enable_language(OBJC OBJCXX OPTIONAL)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/..")

set(CCACHE_PROGRAMS "ccache;sccache;buildcache" CACHE STRING _ FORCE)

find_package(ccache)

set(SOURCES
    main.cpp
    module.cpp
)

if(CMAKE_OBJC_COMPILER_WORKS)
    list(APPEND SOURCES
        module-objc.m
    )
endif()

if(CMAKE_OBJCXX_COMPILER_WORKS)
    list(APPEND SOURCES
        module-objcpp.mm
    )
endif()

add_executable(${PROJECT_NAME} ${SOURCES})
