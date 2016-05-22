
if ("${CM8KR_PLUGIN_PATH}" STREQUAL "")
  set(CM8KR_PLUGIN_PATH ${CMAKE_SOURCE_DIR}/src/plugins )
endif()

function(cm8kr_build_plugin BUILD_TARGET SOURCE_PATH)
    IF(NOT CM8KR_PLUGIN_OUTPUT_PATH) # If MacOSX,
      SET(CM8KR_PLUGIN_OUTPUT_PATH ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
    ENDIF()

    SET(${BUILD_TARGET}_HEADERS_MOC_PATH ${SOURCE_PATH})

    cm8kr_add_shared_library(${BUILD_TARGET} ${SOURCE_PATH})

    MESSAGE(STATUS "Plugin ${BUILD_TARGET} in ${SOURCE_PATH}")

    target_link_libraries(${BUILD_TARGET} ${CM8KR_PLUGIN_DEFAULT_LIBRARIES})

    set(PLUGIN_OUTPUT_DIR ${CMAKE_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})

    if(CM8KR_PLUGIN_OUTPUT_PATH)
      SET_TARGET_PROPERTIES(${BUILD_TARGET}
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CM8KR_PLUGIN_OUTPUT_PATH}
        LIBRARY_OUTPUT_DIRECTORY ${CM8KR_PLUGIN_OUTPUT_PATH}
      )
    endif()

    if(CM8KR_PLUGIN_EXTENSION)
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
