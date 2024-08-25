cmake_minimum_required(VERSION 3.10)
project(video-pi)

find_package(PkgConfig REQUIRED)
pkg_check_modules(deps REQUIRED IMPORTED_TARGET glib-2.0)

add_executable(video-pi-setup src/setup.c)
target_link_libraries(video-pi-setup PkgConfig::deps)
