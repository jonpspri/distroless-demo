cmake_minimum_required(VERSION 3.8.0)
project (hello)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
SET(BUILD_SHARED_LIBS OFF)
SET(CMAKE_EXE_LINKER_FLAGS "-static")

find_package(Boost REQUIRED)
find_package(Threads)

include_directories("${PROJECT_SOURCE_DIR}/crow/include")
add_executable(hello helloworld.cpp)

target_link_libraries(hello PRIVATE Threads::Threads ${Boost_LIBRARIES})
