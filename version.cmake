
FUNCTION(get_version_script dir)
  IF(EXISTS "${dir}/generate-version.py") 
    SET(version_script "${dir}/generate-version.py" PARENT_SCOPE)
    include_directories(${dir}/include)
    set(version_script_dir ${dir} PARENT_SCOPE)
  ENDIF(EXISTS "${dir}/generate-version.py") 
ENDFUNCTION(get_version_script)

MACRO(start_version_script define arg)
  #  SET(cmd "${version_script} ${arg}")

  execute_process(COMMAND "/usr/bin/python" ${version_script} ${arg} 
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    OUTPUT_VARIABLE __version_string)
  
  STRING(STRIP "${__version_string}" __version_string)
  ADD_DEFINITIONS(-D${define}=${__version_string})
ENDMACRO(start_version_script define arg)

MACRO(set_version)
  get_version_script("${CMAKE_MACROS_DIR}")

  if(${version_script} EQUAL "")
    MESSAGE(WARNING "generate-version.py is missing, not able to determine build version.")
    return()
  endif(${version_script} EQUAL "")

  start_version_script("__GIT_MAJOR_VERSION__" "--major")
  set(MAJOR_VERSION ${__version_string})
  start_version_script("__GIT_MINOR_VERSION__" "--minor")
  set(MINOR_VERSION ${__version_string})
  start_version_script("__GIT_PATCH_VERSION__" "--patch")
  set(PATCH_VERSION ${__version_string})
  start_version_script("__GIT_BUILD_VERSION_STRING__" "--quote")
  set(BUILD_VERSION ${__version_string})
  UNSET(__version_string)

  execute_process(COMMAND "touch" "${version_script_dir}/include/version.hpp" 
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  MESSAGE(STATUS "Build version is ${BUILD_VERSION}, ${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}") 
ENDMACRO()
