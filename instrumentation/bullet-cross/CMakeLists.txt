project ( Bullet3_Cross NONE )
cmake_minimum_required( VERSION 2.8.11 )

include ( ExternalProject )

set ( CROSSCHAIN "" CACHE STRING "" )
set ( CROSSPRELOAD "" CACHE STRING "" )

ExternalProject_Add ( Bullet3

        CMAKE_GENERATOR "Ninja"
        CMAKE_ARGS
            -DCMAKE_TOOLCHAIN_FILE=${CROSSCHAIN}
            -DCMAKE_BUILD_TYPE=Release
	    -DBUILD_BULLET2_DEMOS=OFF
	    -DBUILD_UNIT_TESTS=OFF
	    -DBUILD_CPU_DEMOS=OFF
	    -DBUILD_EXTRAS=OFF
	    -DUSE_GRAPHICAL_BENCHMARK=OFF
	    -C${CROSSPRELOAD}

        GIT_REPOSITORY "https://github.com/bulletphysics/bullet3.git"
        BINARY_DIR "build"
        )

# Bullet is a real POS, it doesn't install headers or libraries in a sane way
# find . -type f -name *.a -exec cp {} /binary/lib/x86_64-linux-gnu/ \;
# for f in $(find src/ type f -name *.h); do 
#	FILE_PATH=$(echo $f | sed -e 's|src/||g')
#	mkdir -p /binary/include/bullet/$(dirname $FILE_PATH)
#	cp $f /binary/include/bullet/$FILE_PATH
# done
