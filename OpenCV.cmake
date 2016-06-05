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

option(OpenCV_PATH "Path to OpenCV source" ${CMAKE_SOURCE_DIR}/../opencv-3.0.0)

MACRO(cm8kr_setup_opencv_module module_name)
    include_directories(${OpenCV_PATH}/modules/${module_name}/include )
    set(OpenCV_${module_name}_LIB ${OpenCV_LIBRARY_PATH}/libopencv_${module_name}.dylib)

    if(${module_name} STREQUAL "hal")
        set(OpenCV_${module_name}_LIB ${OpenCV_LIBRARY_PATH}/libopencv_${module_name}.a)
    endif()
ENDMACRO()


MESSAGE(STATUS "OpenCV in path: ${OpenCV_PATH}")

set(OpenCV_LIBRARY_PATH ${OpenCV_PATH}/lib)
set(OpenCV_INCLUDE_PATH ${OpenCV_PATH}/include ${OpenCV_PATH})
link_directories(${OpenCV_LIBRARY_PATH})
include_directories(${OpenCV_INCLUDE_PATH})

cm8kr_setup_opencv_module(core)
cm8kr_setup_opencv_module(hal)
