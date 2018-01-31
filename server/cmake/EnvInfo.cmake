set(OS_WINDOWS OFF)
set(OS_POSIX OFF)

if(WIN32 AND NOT CYGWIN)
    set(OS_WINDOWS ON)
    set(SCRIPT_SUFFIX .cmd)
elseif(UNIX)
    set(OS_POSIX ON)
    set(SCRIPT_SUFFIX .sh)
else()
    message(SEND_ERROR "Target OS is not Windows or POSIX" )
endif()

set(CXX_GCC OFF)
set(CXX_CLANG OFF)
set(CXX_MSVC OFF)

if(CMAKE_CXX_COMPILER_ID STREQUAL GNU)
    set(CXX_GCC ON)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL Clang)
    set(CXX_CLANG ON)
elseif(MSVC)
    set(CXX_MSVC ON)
endif()