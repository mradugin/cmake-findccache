# About

This CMake module finds the `ccache` executable on the system and routes 
compilation and linking calls via `ccache` executable to speed up recompilation.

Following CMake generators are supported:
- **Xcode**
- **Visual Studio**
- **Ninja** and **Unix Makefiles**

More about [ccache](https://ccache.dev)

`Findccache.cmake` can be easily modified to support [other compiler cache tools](#alternative-compile-cache-tools)

# Usage

Add path where `Findccache.cmake` is located to `CMAKE_MODULE_PATH` variable.
For example, if `Findccache.cmake` is located next to `CMakeLists.txt` file, use:

```cmake
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR})
```

`CMAKE_MODULE_PATH` should be set before calling `find_package()`.

For more information on find package modules see:
https://cmake.org/cmake/help/latest/command/find_package.html

As of time of writing `ccache` does not yet support MSVC `/Zi` flag and requires `/Z7` instead. If possible, it is advised to switch `CMP0141` to `NEW` and set `CMAKE_MSVC_DEBUG_INFORMATION_FORMAT` to `Embedded` in the root `CMakeLists.txt` before first `project()` or `enable_language()` call. If `CMP0141` is set to `OLD`, this script will try the old way of switching debug information format by manipulating `CMAKE_<lang>_FLAGS_<config>`, which is known to be unreliable in some cases.

```cmake

set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded)
cmake_policy(SET CMP0141 NEW)

project(...)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR})
find_package(ccache REQUIRED)

```

For the complete example see [CMakeLists.txt](example/CMakeLists.txt)

# ccache Setup

## On Windows

- Download and install [ccache](https://ccache.dev/download.html)
- Add ccache installation directory to `PATH`

## On MacOS

- `brew install ccache`

## On Ubuntu

- `sudo apt install ccache`

# Further Work

`Findccache.cmake` can be easily extended to find and use other compiler cache programs, like, `sccache` or `buildcache` by adding these to `find_program()` call as shown below:  

`find_program(CCACHE_PROGRAM NAMES ccache sccache buildcache DOC "compiler cache executable")`

# Other Resources

## Alternative Compile Cache Tools

- [sccache](https://github.com/mozilla/sccache)
- [buildcache](https://gitlab.com/bits-n-bites/buildcache)
- [Nuitka/clcache](https://github.com/Nuitka/clcache)
- [frerich/clcache](https://github.com/frerich/clcache) (no longer maintained)

## Useful Links

- https://github.com/frerich/clcache/wiki/Caveats
- https://gitlab.com/bits-n-bites/buildcache/-/blob/master/doc/usage.md?ref_type=heads#using-with-visual-studio--msbuild
- https://prismlauncher.org/wiki/development/build-instructions/
- https://github.com/TheLartians/Ccache.cmake
