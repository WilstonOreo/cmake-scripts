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

MACRO(setup_boost major_version minor_version modules)

  SET(BOOST_DIR ${CMAKE_SOURCE_DIR}/../boost_${major_version}_${minor_version}_0 )

  # MacOSX Setup
  IF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    SET(Boost_INCLUDE_DIR ${BOOST_DIR}  )
    SET(Boost_LIBRARY_DIR ${BOOST_DIR}/stage/lib)
  ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")

  # Linux Setup
  IF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    SET(Boost_INCLUDE_DIR ${BOOST_DIR}  )
    SET(Boost_LIBRARY_DIR ${BOOST_DIR}/stage/lib)
  ENDIF(${CMAKE_SYSTEM_NAME} MATCHES "Linux")

  set(Boost_USE_STATIC_LIBS ON)
  find_package(Boost ${major_version}.${minor_version} COMPONENTS ${modules} REQUIRED)

  # Add Boost Include and Link directories
  IF (Boost_FOUND)
    include_directories(${Boost_INCLUDE_DIR})
    link_directories(${Boost_LIBRARY_DIR})
    ADD_DEFINITIONS( "-DHAS_BOOST" )
    # Qt Fix on Ubuntu 12.04 / osx works fine with it as well
    ADD_DEFINITIONS( "-DBOOST_TT_HAS_OPERATOR_HPP_INCLUDED")
    ADD_DEFINITIONS( "-DBOOST_PP_VARIADICS " )
  ENDIF()
ENDMACRO(setup_boost major_version minor_version)
