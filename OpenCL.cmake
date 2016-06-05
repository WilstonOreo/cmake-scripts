include(FindOpenCL)

if (OpenCL_FOUND)
  MESSAGE(STATUS "Found OpenCL ${OpenCL_VERSION_STRING}")
  include_directories(${OpenCL_INCLUDE_DIRS})
else()
  MESSAGE(WARNING "Counld not find OpenCL!")
endif()
