# CMake version 3.25 or newer is required to use CMAKE_MSVC_DEBUG_INFORMATION_FORMAT, 
# for other cases CMake version requirement can be lowered
cmake_minimum_required(VERSION 3.25) 

set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded)
cmake_policy(SET CMP0141 NEW)

project(TestCcache)

# Build Objective-C/C++ sources if a working compiler is available. enable_language() fails
# on missing compiler (OPTIONAL is not honored), hence check first. CMake supports Objective-C
# only with GNU-like compilers, MSVC and clang-cl front-ends are not supported.
if(NOT MSVC)
    include(CheckLanguage)
    check_language(OBJC)
    check_language(OBJCXX)
    if(CMAKE_OBJC_COMPILER)
        enable_language(OBJC)
    endif()
    if(CMAKE_OBJCXX_COMPILER)
        enable_language(OBJCXX)
    endif()
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/..")

set(CCACHE_PROGRAMS "ccache;sccache;buildcache" CACHE STRING _ FORCE)

find_package(ccache)

set(SOURCES
    main.cpp
    module.cpp
)

if(CMAKE_OBJC_COMPILER)
    list(APPEND SOURCES
        module-objc.m
    )
endif()

if(CMAKE_OBJCXX_COMPILER)
    list(APPEND SOURCES
        module-objcpp.mm
    )
endif()

add_executable(${PROJECT_NAME} ${SOURCES})
