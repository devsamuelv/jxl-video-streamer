cmake_minimum_required(VERSION 3.10.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if(CMAKE_EXPORT_COMPILE_COMMANDS)
  set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES
    ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
endif()

project(jxl-video-streamer VERSION 0.1.0 LANGUAGES C CXX)
add_executable(jxl-video-streamer ${CMAKE_SOURCE_DIR}/src/main.cpp)

# add dependencies
include(cmake/CPM.cmake)

CPMAddPackage(
  NAME asiocmake
  GIT_REPOSITORY "https://github.com/OlivierLDff/asio.cmake"
  GIT_TAG "main"
)

# Link to the created library asio::asio or asio
target_link_libraries(jxl-video-streamer PRIVATE asio::asio)
