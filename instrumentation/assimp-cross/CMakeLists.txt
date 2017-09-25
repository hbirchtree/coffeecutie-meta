project ( Assimp_Cross NONE )
cmake_minimum_required( VERSION 2.8.11 )

include ( ExternalProject )

set ( CROSSCHAIN "" CACHE STRING "" )
set ( CROSSPRELOAD "" CACHE STRING "" )

ExternalProject_Add ( Assimp

        CMAKE_GENERATOR "Ninja"
        CMAKE_ARGS
            -DCMAKE_TOOLCHAIN_FILE=${CROSSCHAIN}
            -DCMAKE_INSTALL_PREFIX=out
            -DCMAKE_BUILD_TYPE=MinSizeRel
	    -DASSIMP_BUILD_ALL_IMPORTERS_BY_DEFAULT=OFF
	    -DASSIMP_BUILD_BLEND_IMPORTER=ON
	    -DASSIMP_BUILD_FBX_IMPORTER=ON
	    -DASSIMP_BUILD_COLLADA_IMPORTER=ON
            -DASSIMP_BUILD_ASSIMP_TOOLS=OFF
            -DASSIMP_BUILD_TESTS=OFF
            -DBUILD_SHARED_LIBS=OFF
            -DBUILD_TESTING=OFF

        GIT_REPOSITORY "https://github.com/assimp/assimp.git"
        BINARY_DIR "build"
        )
