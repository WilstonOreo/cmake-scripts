# Setup eigen3

MACRO(setup_eigen)
  IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    INCLUDE_DIRECTORIES(/usr/include/eigen3)
  ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")

  IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    INCLUDE_DIRECTORIES(/usr/local/include/eigen3)
  ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin") 
ENDMACRO(setup_eigen) 
