cmake_minimum_required(VERSION 3.16)

project(GPT_Translator VERSION 0.1 LANGUAGES CXX)


set(CMAKE_AUTOMOC ON) # Meta-Object Compiler
set(CMAKE_AUTORCC ON) # Resource Compiler
set(CMAKE_AUTOUIC ON) # User Interface Compiler

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_PREFIX_PATH "/Users/jg/Qt6/6.5.0/macos/lib/cmake/")



#find_package(Qt6 6.2 COMPONENTS Quick QuickControls2 Concurrent Network REQUIRED)

#find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS Quick Core Gui TextToSpeech Widgets)


set(HEADERS
    src/controller.h
    src/stdafx.h
    src/updater.h
)
set(SOURCES
    "src/main.cpp"
    "src/controller.cpp"
    "src/updater.cpp"
)

set(RESOURCES
    GPT_Translator.qrc
)



IF (CMAKE_SYSTEM_NAME MATCHES "Linux")
	MESSAGE(STATUS "current platform: Linux ")

ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Windows")
	MESSAGE(STATUS "current platform: Windows")
ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Darwin")
	MESSAGE(STATUS "current platform: Darwin")

    set(MACOSX_BUNDLE_ICON_FILE logo.icns)
    # And the following tells CMake where to find and install the file itself.
    set(app_icon_macos "${CMAKE_CURRENT_SOURCE_DIR}/res/logo/logo.icns")
    set_source_files_properties(${app_icon_macos} PROPERTIES
           MACOSX_PACKAGE_LOCATION "Resources")
    
    qt_add_executable(GPT_Translator MACOSX_BUNDLE ${app_icon_macos}
        ${SOURCES} ${HEADERS} ${RESOURCES}
    )

ENDIF()



include_directories("src")

qt_add_qml_module(GPT_Translator
    URI GPT_Translator
    VERSION 1.0
#    QML_FILES qml/main.qml qml/GMenu.qml
)

set_target_properties(GPT_Translator PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER tinyx.me
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)



target_link_libraries(GPT_Translator
    PRIVATE
    Qt6::Quick
    Qt6::Core
    Qt6::Gui
    Qt6::TextToSpeech
    Qt6::Widgets)



install(TARGETS GPT_Translator
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
