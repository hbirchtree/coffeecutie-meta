project ( Coffee_Android NONE )
cmake_minimum_required ( VERSION 3.1 )

include ( ExternalProject )

option ( GENERATE_ONLY OFF "Generate preloads and stop" )

set ( ANDROID_NDK "/home/coffee/android-ndk-linux" CACHE PATH "" )
set ( ANDROID_SDK "/home/coffee/android-sdk-linux" CACHE PATH "" )

set ( PRELOAD_DIRECTORY "${CMAKE_BINARY_DIR}/preloads" )

set ( BUILD_PREFIX_DIR "${CMAKE_BINARY_DIR}" )
set ( SOURCE_DIR "/tmp/Coffee_testing_src" CACHE PATH "" )

set ( DEPLOY_COMBINE_DIR "${BUILD_PREFIX_DIR}/deploy_combine" )

set ( TOOLCHAIN_FILE "${SOURCE_DIR}/cmake/Toolchains/all-android.toolchain.cmake" )
set ( NATIVE_LIB_ROOT "/tmp/Coffee_NativeLibs" CACHE PATH "" )

# Download native libraries for Android
if(NOT GENERATE_ONLY)
    ExternalProject_Add ( NativeLibraryBundle
        GIT_REPOSITORY "https://github.com/hbirchtree/native-library-bundle.git"
        SOURCE_DIR "${NATIVE_LIB_ROOT}"

        CONFIGURE_COMMAND true
        BUILD_COMMAND true
        INSTALL_COMMAND true
        TEST_COMMAND true
        )
endif()

execute_process ( COMMAND ${CMAKE_COMMAND} -E make_directory "${DEPLOY_COMBINE_DIR}" )

function( CREATE_ANDROID_BUILD PRE_NAME API_LEVEL ABI )
    set ( ANDROID_ABI "${ABI}" )
    set ( ANDROID_API_LEVEL ${API_LEVEL} )

    set ( PRELOAD_FILE "${PRELOAD_DIRECTORY}/${PRE_NAME}.cmake" )

    configure_file ( "${PRELOAD_TEMPLATE}" "${PRELOAD_FILE}" @ONLY )

    if(NOT GENERATE_ONLY)
        set ( BUILD_DIR "${BUILD_PREFIX_DIR}/${PRE_NAME}" )

        set ( DEPLOY_API_DIR "${DEPLOY_COMBINE_DIR}/${API_LEVEL}" )
        set ( DEPLOY_TARGET_DIR "${BUILD_DIR}/deploy" )

        execute_process ( COMMAND ${CMAKE_COMMAND} -E make_directory
            "${DEPLOY_API_DIR}" )
        execute_process ( COMMAND ${CMAKE_COMMAND} -E make_directory
            "${DEPLOY_TARGET_DIR}" )

        execute_process ( COMMAND ${CMAKE_COMMAND} -E create_symlink
            "${DEPLOY_API_DIR}" "${DEPLOY_TARGET_DIR}/android-apk" )

        ExternalProject_Add ( "${PRE_NAME}"

            DEPENDS NativeLibraryBundle

            CMAKE_GENERATOR "Ninja"
            CMAKE_ARGS
                -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
                -C${PRELOAD_FILE}
                -DCMAKE_INSTALL_PREFIX=${BUILD_PREFIX_DIR}/out/${API_LEVEL}
                -DNATIVE_LIBRARY_ROOT=${NATIVE_LIB_ROOT}
                -DNATIVE_LIBRARY_DIR=${NATIVE_LIB_ROOT}/Android

            SOURCE_DIR "${SOURCE_DIR}"
            BINARY_DIR "${BUILD_DIR}"

            INSTALL_DIR "${BUILD_PREFIX_DIR}/out/${PRE_NAME}"
            )
    endif()
endfunction()

# First, we generate preloads for the subprojects
set ( PRELOAD_TEMPLATE "${CMAKE_SOURCE_DIR}/android_preload_temp.cmake.in" )

####################################

## Android ARM Gingerbread
#create_android_build ( "armv7a_gingerbread" 12 "armeabi-v7a" )

# Android ARM Gingerbread
#create_android_build ( "armv7a_neon_gingerbread" 12 "armeabi-v7a with NEON" )

# Android x86 Gingerbread
#create_android_build ( "x86_gingerbread" 12 "x86" )

####################################

# Android ARMv5
create_android_build ( "armeabi_latest" 21 "armeabi" )

# Android ARMv7A
create_android_build ( "armv7a_neon_latest" 21 "armeabi-v7a with NEON" )

# Android x86
create_android_build ( "x86_latest" 21 "x86" )

# Android x86_64
create_android_build ( "x86-64_latest" 21 "x86_64" )

# Android MIPS
create_android_build ( "mips_kitkat" 19 "mips" )

# Android MIPS64
create_android_build ( "mips64_kitkat" 19 "mips64" )

####################################

# Android ARMv8A-64 Lollipop
create_android_build ( "arm64_lollipop" 21 "arm64-v8a" )

# Android ARMv8A-64 Nougat
#create_android_build ( "arm64_nougat" 24 "arm64-v8a" )

