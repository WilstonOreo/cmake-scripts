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

# Set version of the main app
FUNCTION (cm8kr_set_version MINOR MAJOR PATCH)
  set( MAJOR_VERSION ${MINOR} CACHE STRING "Major Version")
  set( MINOR_VERSION ${MAJOR} CACHE STRING "Minor Version")
  set( PATCH_VERSION ${PATCH} CACHE STRING "Patch Version")
  set( VERSION_STRING "${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}" CACHE STRING "Version String")
  add_definitions(-D${CM8KR_PROJECT_NAME_UPPER}_VERSION_STRING="${VERSION_STRING}"
    -D${CM8KR_PROJECT_NAME_UPPER}_MAJOR_VERSION="${MAJOR_VERSION}"
    -D${CM8KR_PROJECT_NAME_UPPER}_MINOR_VERSION="${MINOR_VERSION}"
    -D${CM8KR_PROJECT_NAME_UPPER}_PATCH_VERSION="${PATCH_VERSION}"
  )
  MESSAGE(STATUS "${CMAKE_PROJECT_NAME} ${VERSION_STRING}")
ENDFUNCTION()
