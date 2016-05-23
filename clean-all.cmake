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

add_custom_target(clean-cmake-files
  COMMAND ${CMAKE_COMMAND} -P clean-all.cmake)

# clean-all.cmake
set(cmake_generated ${CMAKE_BINARY_DIR}/CMakeCache.txt
  ${CMAKE_BINARY_DIR}/cmake_install.cmake
  ${CMAKE_BINARY_DIR}/Makefile
  ${CMAKE_BINARY_DIR}/CMakeFiles
)

foreach(file ${cmake_generated})
  if (EXISTS ${file})
    MESSAGE(STATUS ${file})
    #    file(REMOVE_RECURSE ${file})
  endif()
endforeach(file)

add_custom_target(clean-all
     COMMAND ${CMAKE_BUILD_TOOL} clean
     COMMAND ${CMAKE_COMMAND} -P clean-all.cmake
)
