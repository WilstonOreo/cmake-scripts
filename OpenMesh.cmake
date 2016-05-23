
IF(NOT DEFINED OPENMESH_PATH)
    SET(OPENMESH_PATH ${CMAKE_SOURCE_DIR}/../OpenMesh)
ENDIF()

set(OPENMESH_LIBRARY_PATH ${OPENMESH_ROOT}/build/Build/lib)
set(OPENMESH_INCLUDE_PATH ${OPENMESH_ROOT}/src)
link_directories(${OPENMESH_LIBRARY_PATH})
include_directories(${OPENMESH_INCLUDE_PATH})

set(OPENMESH_CORE_LIB ${OPENMESH_LIBRARY_PATH}/libOpenMeshCore.dylib)
set(OPENMESH_TOOLS_LIB ${OPENMESH_LIBRARY_PATH}/libOpenMeshTools.dylib)