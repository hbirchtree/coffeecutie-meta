project ( OpenAL_Cross NONE )
cmake_minimum_required( VERSION 3.1 )

include ( ExternalProject )

set ( CROSS "" CACHE STRING "" )

ExternalProject_Add ( "${CROSS}"

        CMAKE_GENERATOR "Ninja"
        CMAKE_ARGS
            -DCMAKE_CXX_COMPILER=${CROSS}-g++-5
            -DCMAKE_C_COMPILER=${CROSS}-gcc-5
            -DALSOFT_EXAMPLES=OFF
            -DALSOFT_TESTS=OFF
            -DALSOFT_UTILS=OFF

        GIT_REPOSITORY "https://github.com/kcat/openal-soft.git"
        BINARY_DIR "build"

        INSTALL_DIR ${CROSS}
        INSTALL_COMMAND true
        )
