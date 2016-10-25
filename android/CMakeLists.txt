project ( Coffee_Android NONE )
cmake_minimum_required ( VERSION 3.1 )

include ( ExternalProject )

set ( PRELOAD_DIRECTORY "${CMAKE_BINARY_DIR}/preloads" )

set ( BUILD_PREFIX_DIR "${CMAKE_BINARY_DIR}" )
set ( SOURCE_DIR "/tmp/Coffee_testing_src" )

set ( DEPLOY_COMBINE_DIR "${BUILD_PREFIX_DIR}/deploy_combine" )

set ( TOOLCHAIN_FILE "${SOURCE_DIR}/cmake/Toolchains/all-android.toolchain.cmake" )
set ( NATIVE_LIB_ROOT "/tmp/Coffee_NativeLibs" )

# Download native libraries for Android
ExternalProject_Add ( NativeLibraryBundle
    GIT_REPOSITORY "https://github.com/hbirchtree/native-library-bundle.git"
    SOURCE_DIR "${NATIVE_LIB_ROOT}"

    CONFIGURE_COMMAND true
    BUILD_COMMAND true
    INSTALL_COMMAND true
    TEST_COMMAND true
    )

execute_process ( COMMAND ${CMAKE_COMMAND} -E make_directory "${DEPLOY_COMBINE_DIR}" )

function( CREATE_ANDROID_BUILD PRE_NAME API_LEVEL ABI )
    set ( ANDROID_ABI "${ABI}" )
    set ( ANDROID_API_LEVEL ${API_LEVEL} )

    set ( PRELOAD_FILE "${PRELOAD_DIRECTORY}/${PRE_NAME}.cmake" )

    configure_file ( "${PRELOAD_TEMPLATE}" "${PRELOAD_FILE}" @ONLY )

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
            -DNATIVE_LIBRARY_ROOT=${NATIVE_LIB_ROOT}
            -DNATIVE_LIBRARY_DIR=${NATIVE_LIB_ROOT}/Android
            -DANDROID_SDK=/home/coffee/android-sdk-linux
            -DANDROID_NDK=/home/coffee/android-ndk-linux
            -C${PRELOAD_FILE}
            -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
            -DCMAKE_INSTALL_PREFIX=${BUILD_PREFIX_DIR}/out/${API_LEVEL}

        SOURCE_DIR "${SOURCE_DIR}"
        BINARY_DIR "${BUILD_DIR}"

        INSTALL_DIR "${BUILD_PREFIX_DIR}/out/${PRE_NAME}"
        )
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

# Android ARMv7A Kitkat
create_android_build ( "armv7a_neon_kitkat" 19 "armeabi-v7a with NEON" )

# Android x86 Kitkat
create_android_build ( "x86_kitkat" 19 "x86" )

# Android x86_64 Kitkat
create_android_build ( "x86-64_kitkat" 19 "x86_64" )

# Android MIPS Kitkat
create_android_build ( "mips_kitkat" 19 "mips" )

# Android MIPS64 Kitkat
create_android_build ( "mips64_kitkat" 19 "mips64" )

####################################

# Android ARMv8A-64 Lollipop
create_android_build ( "arm64_lollipop" 21 "arm64-v8a" )

# Android ARMv8A-64 Nougat
#create_android_build ( "arm64_nougat" 24 "arm64-v8a" )

