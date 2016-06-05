################################################################################
# This file is part of cm8kr.
#
# Copyright (c) 2016, CR8TR GmbH
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES,  INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

# Option macro for option variables with default arguments
MACRO(cm8kr_option VAR DESCRIPTION DEFAULT)
  # CMake option() macro when default value is ON or OFF
  if (("${DEFAULT}" STREQUAL "ON") OR ("${DEFAULT}" STREQUAL "OFF"))
    option(${VAR} ${DESCRIPTION} ${DEFAULT})
    return()
  endif()

  if ("${${VAR}}" STREQUAL "")
    SET(${VAR} ${DEFAULT} CACHE STRING ${DESCRIPTION})
    SET(${VAR} ${DEFAULT})
  else()
    SET(${VAR} ${${VAR}} CACHE STRING ${DESCRIPTION})
    SET(${VAR} "${${VAR}}")
  endif()
ENDMACRO()

# Import macro for convenient loading of cmake files
# Usage: cm8kr_import(cmakefile1 cmakefile2)
# File extension "cmake" is appended automatically
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


cm8kr_option(CM8KR_PATH
  "Directory with cm8kr environment" "")

# Set debug build mode by default
cm8kr_option(CMAKE_BUILD_TYPE
  "Debug or Release build type" "Debug")


# Set install directory (used for linux at the moment only)
# to /usr/share/ by default
cm8kr_option(CM8KR_INSTALL_PATH
  "Install directory"
  share/${CMAKE_PROJECT_NAME})

# Library source directory of project
cm8kr_option(CM8KR_LIBRARY_SOURCE_PATH
  "Library source directory of project"
  ${CMAKE_SOURCE_DIR}/src/lib )

  # Main application source directory
cm8kr_option(CM8KR_MAINAPP_SOURCE_PATH
  "Main application source path"
  ${CMAKE_SOURCE_DIR}/src/app )

# Set path directory with deployment files (icons etc)
# to ${CMAKE_SOURCE_DIR}/deployment_files by default
cm8kr_option(CM8KR_DEPLOYMENT_RESOURCE_PATH
  "Path containing deployment resource files"
  ${CM8KR_MAINAPP_SOURCE_PATH}/data
)



# when building, don't use the install RPATH already
# (but later on when installing)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

# don't add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH FALSE)


# Get CMake Macro path from current file (nice hack)
if ("${CM8KR_PATH}" STREQUAL "")
  get_filename_component(CM8KR_PATH ${CMAKE_CURRENT_LIST_FILE} DIRECTORY)
endif()

MESSAGE(STATUS "Found cm8kr environment in ${CM8KR_PATH}")


MESSAGE(STATUS "Build mode is ${CMAKE_BUILD_TYPE}")

# Get current time
STRING(TIMESTAMP CM8KR_CURRENT_TIME)
STRING(TIMESTAMP CM8KR_YEAR "%Y")

SET(CM8KR_PROJECT_NAME ${PROJECT_NAME})
string(TOUPPER ${PROJECT_NAME} CM8KR_PROJECT_NAME_UPPER)

cm8kr_import(
  base/compiler
  base/include_path
  base/build_target
  base/version
  base/add_submodule
)

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


# Include build cmake for including exported symbols
if(EXISTS ${abs_module_path}/build.cmake)
  include(${abs_module_path}/build.cmake)
endif()
