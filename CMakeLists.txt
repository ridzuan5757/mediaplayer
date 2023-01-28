cmake_minimum_required(VERSION 3.16)

project(MediaPlayer VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS REQUIRED
    Core
    Quick
    Svg
)
qt_standard_project_setup()

qt_add_executable(appMediaPlayer
    main.cpp
)

set(resource_files
    "main.qml"
    "PlayerMenuBar.qml"
    "TracksInfo.qml"
    "AudioControl.qml"
    "Mute_Icon.svg"
    "Speaker_Icon.svg"
    "PlaybackControl.qml"
    "PlaybackRateControl.qml"
    "PlaybackSeekControl.qml"
    "MetadataInfo.qml"
    "TracksInfo.qml"
)

qt_add_resources(appMediaPlayer
    PREFIX
        "/"
    FILES
        ${resource_files}
)

set_target_properties(appMediaPlayer PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMediaPlayer
    PRIVATE
    Qt6::Quick
    Qt6::Core
    Qt6::Svg
)

install(TARGETS appMediaPlayer
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
