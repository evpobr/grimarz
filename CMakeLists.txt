cmake_minimum_required(VERSION 3.1)

project(grimarz VERSION 1.0.0)

include(GNUInstallDirs)
include(CMakeDependentOption)
include(CPack)

option(GRIMARZ_WITH_EXTERNAL_LZ4 "Use external lz4 library" ON)

if(NOT WIN32)
  message(FATAL_ERROR "Error: only Windows platform is supported.")
endif()

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

if(GRIMARZ_WITH_EXTERNAL_LZ4)
  find_package(LZ4 1.3.1)
endif()

if(NOT TARGET LZ4::LZ4)
  set(GRIMARZ_WITH_EXTERNAL_LZ4 OFF)
  add_library(lz4 STATIC
    grimarz/lz4/lz4.c
    grimarz/lz4/lz4frame.c
    grimarz/lz4/lz4hc.c
    grimarz/lz4/xxhash.c
    grimarz/lz4/lz4.h
    grimarz/lz4/lz4frame.h
    grimarz/lz4/lz4hc.h
    grimarz/lz4/xxhash.h
  )
  target_include_directories(lz4 PUBLIC grimarz/lz4)
  add_library(LZ4::LZ4 ALIAS lz4)
endif()

add_executable(grimarz
  grimarz/ARZFile.h
  grimarz/ARZString.h
  grimarz/main.cpp
)
target_link_libraries(grimarz PRIVATE shlwapi LZ4::LZ4)

install(TARGETS grimarz RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES LICENSE DESTINATION ${CMAKE_INSTALL_DOCDIR})
