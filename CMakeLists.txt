cmake_minimum_required(VERSION 3.10)

#### NEED TO MODIFY ###
project(keystone-app-template C CXX ASM)
#### NEED TO MODIFY ###

include(macros.cmake)

include(ExternalProject)
find_package(Git REQUIRED)

if(RISCV32)
  message(STATUS "riscv32")
  set(BITS 32)
else()
  message(STATUS "riscv64")
  set(BITS 64)
endif()

use_riscv_toolchain(${BITS})

# check if SDK has been built and KEYSTONE_SDK_DIR environment variable exists
if (NOT DEFINED ENV{KEYSTONE_SDK_DIR})
  message(FATAL_ERROR "Please set KEYSTONE_SDK_DIR environment variable to an installed SDK path")
endif()

set(KEYSTONE_SDK_DIR $ENV{KEYSTONE_SDK_DIR})

# export include directory
include_directories(AFTER ${KEYSTONE_SDK_DIR}/include)

# set paths to the libraries
set(KEYSTONE_LIB_HOST ${KEYSTONE_SDK_DIR}/lib/libkeystone-host.a)
set(KEYSTONE_LIB_EDGE ${KEYSTONE_SDK_DIR}/lib/libkeystone-edge.a)
set(KEYSTONE_LIB_VERIFIER ${KEYSTONE_SDK_DIR}/lib/libkeystone-verifier.a)
set(KEYSTONE_LIB_EAPP ${KEYSTONE_SDK_DIR}/lib/libkeystone-eapp.a)

# find program "makeself"
find_program(MAKESELF makeself)

#### NEED TO MODIFY ###
# add eapp source files
file(GLOB eapp_src
    "eapp/src/*.c"
)

# add host app source files
file(GLOB host_src
    "host/main.cpp"
)

set(eapp_bin ${PROJECT_NAME}) # eapp name
set(host_bin ${PROJECT_NAME}-host) # host app name
set(package_name "${PROJECT_NAME}.ke") # makeself package name 

# executed command after extracting. this follows the definition in th host app.
set(package_script "${host_bin} ${eapp_bin} eyrie-rt") 
#### NEED TO MODIFY ###

if(RISCV32)
  set(eyrie_plugins "freemem io_syscall linux_syscall env_setup rv32")
else()
  set(eyrie_plugins "freemem io_syscall linux_syscall env_setup")
endif()

#### NEED TO MODIFY ###
# eapp
add_executable(${eapp_bin} ${eapp_src})
target_link_libraries(${eapp_bin} "-static")
target_include_directories(${eapp_bin}
  PUBLIC ${PROJECT_SOURCE_DIR}/eapp/include
)

# host
add_executable(${host_bin} ${host_src})
target_link_libraries(${host_bin} ${KEYSTONE_LIB_HOST} ${KEYSTONE_LIB_EDGE})
#### NEED TO MODIFY ###

# Eyrie runtime
set(eyrie_files_to_copy .options_log eyrie-rt)
add_eyrie_runtime(${eapp_bin}-eyrie
  ${eyrie_plugins}
  ${eyrie_files_to_copy})

# Packaging Target
add_keystone_package(package
  ${package_name}
  ${package_script}
  ${eyrie_files_to_copy} ${eapp_bin} ${host_bin})

add_dependencies(package ${eapp_bin}-eyrie)

