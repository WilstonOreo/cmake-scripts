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

cm8kr_option(CM8KR_PLUGIN_PATH 
  "Plugin source directory"
  ${CMAKE_SOURCE_DIR}/src/plugins )

cm8kr_option(CM8KR_PLUGIN_OUTPUT_PATH 
  "Plugin binary output path" "" )

cm8kr_option(CM8KR_PLUGIN_EXTENSION
  "Plugin binary file extension" "" )

cm8kr_option(CM8KR_PLUGIN_DEFAULT_LIBRARIES 
  "Plugin default libraries" "")

function(cm8kr_build_plugin BUILD_TARGET SOURCE_PATH)
    IF(NOT CM8KR_PLUGIN_OUTPUT_PATH) # If MacOSX,
      SET(CM8KR_PLUGIN_OUTPUT_PATH ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
    ENDIF()

    SET(${BUILD_TARGET}_HEADERS_MOC_PATH ${SOURCE_PATH})

    cm8kr_add_shared_library(${BUILD_TARGET} ${SOURCE_PATH})

    MESSAGE(STATUS "Plugin ${BUILD_TARGET} in ${SOURCE_PATH}")

    target_link_libraries(${BUILD_TARGET} ${CM8KR_PLUGIN_DEFAULT_LIBRARIES})

    set(PLUGIN_OUTPUT_DIR ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})

    if(NOT "${CM8KR_PLUGIN_OUTPUT_PATH}" STREQUAL "")
      SET_TARGET_PROPERTIES(${BUILD_TARGET}
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CM8KR_PLUGIN_OUTPUT_PATH}
        LIBRARY_OUTPUT_DIRECTORY ${CM8KR_PLUGIN_OUTPUT_PATH}
      )
    endif()

    if(NOT "${CM8KR_PLUGIN_EXTENSION}" STREQUAL "")
      SET_TARGET_PROPERTIES(${BUILD_TARGET}
        PROPERTIES
        SUFFIX ".${CM8KR_PLUGIN_EXTENSION}"
        PREFIX ""
      )
    endif()

    # Make install target for linux in /usr/share/${PROJECT_NAME}/plugins
    IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  	   INSTALL(TARGETS ${BUILD_TARGET} DESTINATION ${CM8KR_INSTALL_PATH}}/plugins)
    ENDIF()

    if(EXISTS ${PLUGIN_DIR}/postbuild.cmake)
        include(${PLUGIN_DIR}/postbuild.cmake)
    endif()
endfunction()

macro(cm8kr_load_plugins PLUGIN_FOLDER)
    file(GLOB plugin_dirs "${PLUGIN_FOLDER}/*")

    get_filename_component(PLUGIN_PREFIX ${PLUGIN_FOLDER} NAME)
    MESSAGE(STATUS ${PLUGIN_PREFIX})

    foreach(plugin_dir ${plugin_dirs})
        get_filename_component(PLUGIN_NAME ${plugin_dir} NAME)
        IF(IS_DIRECTORY ${plugin_dir})
            cm8kr_build_plugin("plugin_${PLUGIN_PREFIX}_${PLUGIN_NAME}" "${plugin_dir}")
        ENDIF()
    endforeach()
endmacro()
