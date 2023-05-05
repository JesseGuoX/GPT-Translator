cmake_minimum_required(VERSION 3.16)

project(GPT_Translator VERSION 0.1 LANGUAGES CXX)


set(CMAKE_AUTOMOC ON) # Meta-Object Compiler
set(CMAKE_AUTORCC ON) # Resource Compiler
set(CMAKE_AUTOUIC ON) # User Interface Compiler

set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_definitions(-DAPP_VERSION="${APP_VERSION}")

message(STATUS "APP_VERSION: ${APP_VERSION}")

if(NOT DEFINED CMAKE_PREFIX_PATH)
set(CMAKE_PREFIX_PATH "/Users/jg/Qt6/6.5.0/macos/lib/cmake/")
endif()



find_package(Qt6 REQUIRED COMPONENTS Quick TextToSpeech)
if(Qt6_VERSION_MAJOR EQUAL 6 AND Qt6_VERSION_MINOR GREATER_EQUAL 5)
    qt6_policy(SET QTP0001 OLD)
endif()


set(HEADERS
    src/controller.h
    src/stdafx.h
    src/updater.h
    src/hotkey.h
)
set(SOURCES
    src/main.cpp
    src/controller.cpp
    src/updater.cpp
    src/hotkey.cpp
)

set(RESOURCES
    GPT_Translator.qrc
)

add_subdirectory(lib/)


IF (CMAKE_SYSTEM_NAME MATCHES "Linux")
	MESSAGE(STATUS "current platform: Linux ")
    find_package(X11 REQUIRED)

    qt_add_executable(GPT_Translator
        ${SOURCES} ${HEADERS} ${RESOURCES}
    )
ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Windows")
	MESSAGE(STATUS "current platform: Windows")

    # set(CMAKE_EXE_LINKER_FLAGS "-static") use target_link_libraries instead
    set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/res/logo/logo.rc")
    qt_add_executable(GPT_Translator ${app_icon_resource_windows}
        ${SOURCES} ${HEADERS} ${RESOURCES}
    )

    set_target_properties(GPT_Translator PROPERTIES
        MACOSX_BUNDLE_GUI_IDENTIFIER tinyx.me
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
    )
ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Darwin")
	MESSAGE(STATUS "current platform: Darwin")
    find_library( APP_SERVICES_LIBRARY ApplicationServices )

    set(MACOSX_BUNDLE_ICON_FILE logo.icns)
    # And the following tells CMake where to find and install the file itself.
    set(app_icon_macos "${CMAKE_CURRENT_SOURCE_DIR}/res/logo/logo.icns")
    set_source_files_properties(${app_icon_macos} PROPERTIES
           MACOSX_PACKAGE_LOCATION "Resources")
    
    qt_add_executable(GPT_Translator MACOSX_BUNDLE ${app_icon_macos}
        ${SOURCES} ${HEADERS} ${RESOURCES}
    )

    set_target_properties(GPT_Translator PROPERTIES
        MACOSX_BUNDLE_GUI_IDENTIFIER tinyx.me
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
    )

ENDIF()



include_directories("src")


IF (CMAKE_SYSTEM_NAME MATCHES "Windows")
    if(DEFINED IS_MINGW)
    target_link_libraries(GPT_Translator
        PRIVATE
        Qt6::Quick
        Qt6::TextToSpeech
        qhotkey
        user32
        )
    else()
    target_link_libraries(GPT_Translator
        PRIVATE
        Qt6::Quick
        Qt6::TextToSpeech
        qhotkey
        user32
        )
    endif()
ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Linux")
    target_include_directories(send_ctrl_c_project PRIVATE ${X11_INCLUDE_DIR})

    target_link_libraries(GPT_Translator
        PRIVATE
        Qt6::Quick
        Qt6::TextToSpeech
        qhotkey
        ${X11_LIBRARIES}
        )

ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Darwin")
    target_link_libraries(GPT_Translator
        PRIVATE
        Qt6::Quick
        Qt6::TextToSpeech
        qhotkey
        ${APP_SERVICES_LIBRARY}
        )
ENDIF()

install(TARGETS GPT_Translator
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
