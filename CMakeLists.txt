cmake_minimum_required(VERSION 3.16)

project(GPT_Translator VERSION 0.1 LANGUAGES CXX)


set(CMAKE_AUTOMOC ON) # Meta-Object Compiler
set(CMAKE_AUTORCC ON) # Resource Compiler
set(CMAKE_AUTOUIC ON) # User Interface Compiler

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_PREFIX_PATH "/Users/jg/Qt6/6.2.4/macos/lib/cmake/")



#find_package(Qt6 6.2 COMPONENTS Quick QuickControls2 Concurrent Network REQUIRED)

find_package(Qt6 6.2 COMPONENTS Quick REQUIRED)


set(HEADERS
    src/controller.h
    src/stdafx.h
)
set(SOURCES
    "src/main.cpp"
    "src/controller.cpp"
)

set(RESOURCES
    GPT_Translator.qrc
)


qt_add_executable(appGPT_Translator
   ${SOURCES} ${HEADERS} ${RESOURCES}
)

include_directories("src")

qt_add_qml_module(appGPT_Translator
    URI GPT_Translator
    VERSION 1.0
#    QML_FILES qml/main.qml qml/GMenu.qml
)

set_target_properties(appGPT_Translator PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appGPT_Translator
    PRIVATE Qt6::Quick)

#target_link_libraries(appGPT_Translator PRIVATE
#    Qt6::Core
#    Qt6::Quick
#    Qt6::QuickControls2
#    Qt6::Concurrent
#    Qt6::Network
#)

install(TARGETS appGPT_Translator
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
