if(LZ4_INCLUDE_DIR AND LZ4_LIBRARY)
  set(LZ4_FIND_QUIETLY TRUE)
endif()

find_path(LZ4_INCLUDE_DIR lz4.h)
find_library(LZ4_LIBRARY lz4)

if(LZ4_INCLUDE_DIR)
  file(STRINGS "${LZ4_INCLUDE_DIR}/lz4.h" _lz4_version_lines
    REGEX "#define[ \t]+LZ4_VERSION_(MAJOR|MINOR|RELEASE)"
  )
  string(REGEX REPLACE ".*LZ4_VERSION_MAJOR *\([0-9]*\).*" "\\1" _lz4_version_major "${_lz4_version_lines}")
  string(REGEX REPLACE ".*LZ4_VERSION_MINOR *\([0-9]*\).*" "\\1" _lz4_version_minor "${_lz4_version_lines}")
  string(REGEX REPLACE ".*LZ4_VERSION_RELEASE *\([0-9]*\).*" "\\1" _lz4_version_release "${_lz4_version_lines}")
  set(LZ4_VERSION "${_lz4_version_major}.${_lz4_version_minor}.${_lz4_version_release}")
  unset(_lz4_version_major)
  unset(_lz4_version_minor)
  unset(_lz4_version_release)
  unset(_lz4_version_lines)
endif()

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(LZ4
  REQUIRED_VARS LZ4_LIBRARY LZ4_INCLUDE_DIR
  VERSION_VAR LZ4_VERSION
)

if(LZ4_FOUND)
  set(LZ4_LIBRARIES ${LZ4_LIBRARY})
  set(LZ4_INCLUDE_DIRS ${LZ4_INCLUDE_DIR})
endif()

if(NOT TARGET LZ4::LZ4)
  add_library(LZ4::LZ4 UNKNOWN IMPORTED)
  set_target_properties(LZ4::LZ4 PROPERTIES
    IMPORTED_LOCATION "${LZ4_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${LZ4_INCLUDE_DIR}"
  )
endif()

mark_as_advanced(LZ4_INCLUDE_DIR LZ4_LIBRARY)
