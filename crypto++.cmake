
if(NOT DEFINED cryptopp_DIRECTORY)
  set(cryptopp_DIRECTORY ${CMAKE_SOURCE_DIR}/../cryptopp )
endif()

link_directories(${cryptopp_DIRECTORY})
include_directories(${cryptopp_DIRECTORY})

set(cryptopp_LIBRARIES cryptopp)
