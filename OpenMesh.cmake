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

IF(NOT DEFINED OPENMESH_PATH)
    SET(OPENMESH_PATH ${CMAKE_SOURCE_DIR}/../OpenMesh)
ENDIF()

set(OPENMESH_LIBRARY_PATH ${OPENMESH_ROOT}/build/Build/lib)
set(OPENMESH_INCLUDE_PATH ${OPENMESH_ROOT}/src)
link_directories(${OPENMESH_LIBRARY_PATH})
include_directories(${OPENMESH_INCLUDE_PATH})

set(OPENMESH_CORE_LIB ${OPENMESH_LIBRARY_PATH}/libOpenMeshCore.dylib)
set(OPENMESH_TOOLS_LIB ${OPENMESH_LIBRARY_PATH}/libOpenMeshTools.dylib)
