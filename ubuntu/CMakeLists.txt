project ( Coffee_Snappy NONE )
cmake_minimum_required ( VERSION 3.1 )

include ( ExternalProject )

set ( NATIVE_LIB_ROOT "native-lib" CACHE PATH "" )
set ( SOURCE_DIR "/tmp/Coffee_testing_src" CACHE PATH "" )

set ( PRELOAD_DIR "${SOURCE_DIR}/cmake/Preload" )
set ( TOOLCHAIN_DIR "${SOURCE_DIR}/cmake/Toolchains" )

set ( BUILD_PREFIX_DIR "${CMAKE_BINARY_DIR}" )

set ( UNIFY_DIR "${CMAKE_BINARY_DIR}/unify" )

set ( TOOLCHAIN "native-linux-generic.toolchain.cmake" )
set ( PRELOAD "x86_64-linux-generic.cmake" )

ExternalProject_Add ( NativeLibraryBundle
    GIT_REPOSITORY "https://github.com/hbirchtree/native-library-bundle.git"
    SOURCE_DIR "${NATIVE_LIB_ROOT}"

    CONFIGURE_COMMAND true
    BUILD_COMMAND true
    INSTALL_COMMAND true
    TEST_COMMAND true
    )

function( CREATE_SNAPPY_BUILD ARCH CXX CC )
    set ( PRELOAD_FILE "${PRELOAD_DIR}/${PRELOAD}" )
    set ( TOOLCHAIN_FILE "${TOOLCHAIN_DIR}/${TOOLCHAIN}" )

    set ( BUILD_DIR "${BUILD_PREFIX_DIR}/${ARCH}" )

    ExternalProject_Add ( "${ARCH}"
        DEPENDS NativeLibraryBundle

        CMAKE_GENERATOR "Ninja"
        CMAKE_ARGS
            -DCMAKE_CXX_COMPILER=${CXX}
            -DCMAKE_C_COMPILER=${CC}
            -DNATIVE_LIBRARY_ROOT=${NATIVE_LIB_ROOT}
            -DNATIVE_LIBRARY_DIR=${NATIVE_LIB_ROOT}/Ubuntu
#            -C${PRELOAD_FILE}
            -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
            -DCMAKE_INSTALL_PREFIX=${UNIFY_DIR}/${ARCH}
            -DCOFFEE_BUILD_OPENAL=OFF
            -DCOFFEE_BUILD_SDL2=OFF
            -DCOFFEE_BUILD_GLEAM=OFF
            -DCOFFEE_BUILD_GLEAM_RHI=OFF
            -DCOFFEE_BUILD_OPENSSL=OFF

        SOURCE_DIR "${SOURCE_DIR}"
        BINARY_DIR "${BUILD_DIR}"

        INSTALL_DIR ${UNIFY_DIR}/${ARCH}
        )
endfunction()

create_snappy_build ( "amd64" "g++" "gcc" )
create_snappy_build ( "arm64" "aarch64-linux-gnu-g++-5" "aarch64-linux-gnu-gcc-5" )
create_snappy_build ( "armhf" "arm-linux-gnueabihf-g++-5" "arm-linux-gnueabihf-gcc-5" )
