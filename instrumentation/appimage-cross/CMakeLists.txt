project ( AppImage_Cross NONE )
cmake_minimum_required( VERSION 2.8.11 )

include ( ExternalProject )

set ( CROSS "" CACHE STRING "" )

ExternalProject_Add ( "${CROSS}"

        CMAKE_GENERATOR "Ninja"
        CMAKE_ARGS
            -DCMAKE_CXX_COMPILER=${CROSS}-g++
            -DCMAKE_C_COMPILER=${CROSS}-gcc
            -DALSOFT_EXAMPLES=OFF
            -DALSOFT_TESTS=OFF
            -DALSOFT_UTILS=OFF
            -DCMAKE_BUILD_TYPE=Release

        GIT_REPOSITORY "https://github.com/probonopd/AppImageKit.git"
        BINARY_DIR "build"

        INSTALL_DIR ${CROSS}
        INSTALL_COMMAND true
        )
