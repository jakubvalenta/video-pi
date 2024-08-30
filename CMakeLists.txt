cmake_minimum_required(VERSION 3.10)
project(video-pi)

find_package(PkgConfig REQUIRED)
pkg_check_modules(deps REQUIRED IMPORTED_TARGET glib-2.0)

add_executable(video-pi-install src/install.c)
target_link_libraries(video-pi-install PkgConfig::deps)

add_executable(video-pi-uninstall src/uninstall.c)
target_link_libraries(video-pi-uninstall PkgConfig::deps)
