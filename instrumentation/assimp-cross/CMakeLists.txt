project ( Assimp_Cross NONE )
cmake_minimum_required( VERSION 2.8.11 )

include ( ExternalProject )

set ( CROSSCHAIN "" CACHE STRING "" )
set ( CROSSPRELOAD "" CACHE STRING "" )

ExternalProject_Add ( Assimp

        CMAKE_GENERATOR "Ninja"
        CMAKE_ARGS
            -DCMAKE_TOOLCHAIN_FILE=${CROSSCHAIN}
            -DCMAKE_BUILD_TYPE=Release
	    -DASSIMP_BUILD_ALL_IMPORTERS_BY_DEFAULT=OFF
	    -DASSIMP_BUILD_BLEND_IMPORTER=ON
	    -DASSIMP_BUILD_FBX_IMPORTER=ON
	    -DASSIMP_BUILD_COLLADA_IMPORTER=ON
            -C${CROSSPRELOAD}

        GIT_REPOSITORY "https://github.com/assimp/assimp.git"
        BINARY_DIR "build"
        )
