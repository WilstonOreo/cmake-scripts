# Set debug build mode by default
IF("${CMAKE_BUILD_TYPE}" STREQUAL "")
  SET(CMAKE_BUILD_TYPE "Debug")
ENDIF("${CMAKE_BUILD_TYPE}" STREQUAL "")

MESSAGE(STATUS "Build mode is ${CMAKE_BUILD_TYPE}")

# Get current time
STRING(TIMESTAMP CM8KR_CURRENT_TIME)
STRING(TIMESTAMP CM8KR_YEAR "%Y")

SET(CM8KR_PROJECT_NAME ${PROJECT_NAME})
string(TOUPPER ${PROJECT_NAME} CM8KR_PROJECT_NAME_UPPER)

# On Linux, use clang compiler 3.6 for debugging and GNU for release
IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(CMAKE_EXPORT_COMPILE_COMMANDS "ON")

  IF("${CLANG_VERSION}" STREQUAL "")
    SET(CLANG_VERSION "3.6")
  ENDIF()

  # Use clang for debug mode
  if (${CMAKE_BUILD_TYPE} MATCHES "Debug")
    SET (CMAKE_C_COMPILER "/usr/bin/clang-${CLANG_VERSION}")
    SET (CMAKE_C_FLAGS"-Wall -std=c99")
    SET (CMAKE_C_FLAGS_DEBUG  "-g")
    SET (CMAKE_C_FLAGS_MINSIZEREL "-Os -DNDEBUG")
    SET (CMAKE_C_FLAGS_RELEASE"-O4 -DNDEBUG")
    SET (CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g")

    SET (CMAKE_CXX_COMPILER "/usr/bin/clang++-${CLANG_VERSION}")
    SET (CMAKE_CXX_FLAGS"-Wall")
    SET (CMAKE_CXX_FLAGS_DEBUG  "-g")
    SET (CMAKE_CXX_FLAGS_MINSIZEREL "-Os -DNDEBUG")
    SET (CMAKE_CXX_FLAGS_RELEASE"-O4 -DNDEBUG")
    SET (CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g")

    SET (CMAKE_AR  "/usr/bin/llvm-ar")
    SET (CMAKE_LINKER  "/usr/bin/llvm-ld")
    SET (CMAKE_NM  "/usr/bin/llvm-nm")
    SET (CMAKE_OBJDUMP "/usr/bin/llvm-objdump")
    SET (CMAKE_RANLIB  "/usr/bin/llvm-ranlib")
  endif()

  # Use GCC for release mode
  if (${CMAKE_BUILD_TYPE} MATCHES "Release")
    SET (CMAKE_C_COMPILER "/usr/bin/cc")
    SET (CMAKE_C_FLAGS"-Wall -std=cc99")
    SET (CMAKE_C_FLAGS_DEBUG  "-g")
    SET (CMAKE_C_FLAGS_MINSIZEREL "-Os -DNDEBUG")
    SET (CMAKE_C_FLAGS_RELEASE"-O4 -DNDEBUG")
    SET (CMAKE_C_FLAGS_RELWITHDEBINFO "-O2 -g")

    SET (CMAKE_CXX_COMPILER "/usr/bin/c++")
    SET (CMAKE_CXX_FLAGS"-Wall")
    SET (CMAKE_CXX_FLAGS_DEBUG  "-g")
    SET (CMAKE_CXX_FLAGS_MINSIZEREL "-Os -DNDEBUG")
    SET (CMAKE_CXX_FLAGS_RELEASE"-O4 -DNDEBUG")
    SET (CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O2 -g")

    SET (CMAKE_AR  "/usr/bin/llvm-ar")
    SET (CMAKE_LINKER  "/usr/bin/llvm-ld")
    SET (CMAKE_NM  "/usr/bin/llvm-nm")
    SET (CMAKE_OBJDUMP "/usr/bin/llvm-objdump")
    SET (CMAKE_RANLIB  "/usr/bin/llvm-ranlib")
  endif()
endif()


MESSAGE(STATUS "C++ compiler is ${CMAKE_CXX_COMPILER}")
MESSAGE(STATUS "C compiler is ${CMAKE_C_COMPILER}")

# Get CMake Macro path from current file (nice hack)
if ("${CM8KR_PATH}" STREQUAL "")
  get_filename_component(CM8KR_PATH ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)

  MESSAGE(STATUS "Found cm8kr environment in ${CM8KR_PATH}")

  # Setup build directories
  MESSAGE(STATUS "Setup build directories...")

  # force output into several folders
  SET (CMAKE_LIBRARY_OUTPUT_DIRECTORY
      ${PROJECT_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE} )
  SET (CMAKE_RUNTIME_OUTPUT_DIRECTORY
     ${PROJECT_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE} )
  SET (CMAKE_ARCHIVE_OUTPUT_DIRECTORY
     ${PROJECT_BINARY_DIR}/bin/${CMAKE_BUILD_TYPE} )
  SET(CMAKE_PROJECT_DOC_DIR
     ${PROJECT_BINARY_DIR}/doc )
  SET(CMAKE_CURRENT_BINARY_DIR
    ${PROJECT_BINARY_DIR}/moc  )

  # Set install directory (used for linux at the moment only)
  # to /usr/share/ by default
  IF("${CM8KR_INSTALL_PATH}" STREQUAL "")
    SET(CM8KR_INSTALL_PATH share/${CMAKE_PROJECT_NAME})
  ENDIF()

  # Library source directory
  IF ("${CM8KR_LIBRARY_SOURCE_PATH}" STREQUAL "")
    SET(CM8KR_LIBRARY_SOURCE_PATH ${CMAKE_SOURCE_DIR}/src/lib
      CACHE STRING "Library source path")
  ENDIF()

  # Main app source directory
  IF ("${CM8KR_MAINAPP_SOURCE_PATH}" STREQUAL "")
    SET(CM8KR_MAINAPP_SOURCE_PATH ${CMAKE_SOURCE_DIR}/src/app
      CACHE STRING "Main application source path")
  ENDIF()

  # Set path directory with deployment files (icons etc)
  # to ${CMAKE_SOURCE_DIR}/deployment_files by default
  IF ("${CM8KR_DEPLOYMENT_RESOURCE_PATH}" STREQUAL "")
    SET(CM8KR_DEPLOYMENT_RESOURCE_PATH ${CM8KR_MAINAPP_SOURCE_PATH}/data
      CACHE STRING "Path containing deployment files"
    )
  ENDIF()

  # MacOSX specific setup
  IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
      set( CMAKE_MACOSX_RPATH 1)

      # use, i.e. don't skip the full RPATH for the build tree
      SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

      # when building, don't use the install RPATH already
      # (but later on when installing)
      SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

      SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")

      # add the automatically determined parts of the RPATH
      # which point to directories outside the build tree to the install RPATH
      SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

      # the RPATH to be used when installing, but only if it's not a system directory
      LIST(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_PREFIX}/lib" isSystemDir)
      IF("${isSystemDir}" STREQUAL "-1")
          SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
      ENDIF("${isSystemDir}" STREQUAL "-1")

  ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

endif()

# Import macro for convenient loading of cmake files
# Usage: import(cmakefile1 cmakefile2)
# File extension "cmake" is appended automaticcly
MACRO (cm8kr_import ${ARGN})
    # Cannot use ARGN directly with list() command.
    # Copy to a variable first.
    set (macro_args ${ARGN})

    foreach(module_name ${macro_args})
      if ("${${module_name}_LOADED}" STREQUAL "")
        set(module_filename ${CM8KR_PATH}/${module_name}.cmake)
        set(${module_name}_LOADED YES )
        INCLUDE(${module_filename})
      endif()
    endforeach(module_name)
ENDMACRO()

cm8kr_import(
  base/build_target
  base/compiler_flags
  base/version
  base/add_submodule
)

include_directories(BEFORE
  ${PROJECT_SOURCE_DIR}/include
)
