cmake_minimum_required(VERSION 3.8.0)
project (hello)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
SET(BUILD_SHARED_LIBS OFF)
SET(CMAKE_EXE_LINKER_FLAGS "-static")

add_executable(hello helloworld.cpp)

# RESTinio dependencies:
# 1. ASIO or Boost::ASIO (goes as headers, vcpkg knows where)
# 2. HTTP parser
# find_package(unofficial-http-parser REQUIRED)
add_subdirectory(nodejs/http_parser)
# 3. fmtlib
#find_package(fmt REQUIRED)
add_subdirectory(fmt)
# RESTinio itself
# find_package(restinio REQUIRED)
add_subdirectory(restinio)

find_package(Threads REQUIRED)

target_link_libraries(hello PRIVATE restinio::restinio Threads::Threads)
