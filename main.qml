import QtQuick
import QtQuick.Controls
import QtMultimedia

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Media Player")
    property alias source: mediaPlayer.source

    Popup {
        id: mediaError
        anchors.centerIn: Overlay.overlay
        Text {
            id: mediaErrorText
        }
    }

    MediaPlayer {
        id: mediaPlayer
        videoOutput: videoOutput
        audioOutput: AudioOutput {
            id: audio
            muted: playbackControl.muted
            volume: playbackControl.volume
        }
        onMetaDataChanged: updateMetadata()
        onActiveTracksChanged: updateMetadata()
        onErrorOccurred: {
            mediaErrorText.text = mediaPlayer.errorString
            mediaError.open()
        }
        onTracksChanged: {
            audioTracksInfo.read(mediaPlayer.audioTracks)
            audioTracksInfo.selectedTrack = mediaPlayer.activeAudioTrack

            videoTracksInfo.read(mediaPlayer.activeVideoTrack)
            videoTracksInfo.selectedTrack = mediaPlayer.activeVideoTrack

            subtitleTracksInfo.read(mediaPlayer.subtitleTrack)
            subtitleTracksInfo.selectedTrack = mediaPlayer.activeSubtitleTrack

            updateMetadata()
        }

        function updateMetadata() {
            metadataInfo.clear()
            metadataInfo.read(mediaPlayer.metaData)
            metadataInfo.read(
                        mediaPlayer.audioTracks[mediaPlayer.activeAudioTrack])
            metadataInfo.read(
                        mediaPlayer.videoTracks[mediaPlayer.activeVideoTrack])
        }
    }

    VideoOutput {
        id: videoOutput
        property bool fullScreen: false

        anchors.top: fullScreen ? parent.top : menuBar.bottom
        anchors.bottom: playbackControl.top
        anchors.left: parent.left
        anchors.right: parent.right

        TapHandler {
            onDoubleTapped: {
                parent.fullScreen ? showNormal() : showFullScreen()
                parent.fullScreen = !parent.fullScreen
            }
            onTapped: {
                metadataInfo.visible = false
                audioTracksInfo.visible = false
                videoTracksInfo.visible = false
                subtitleTracksInfo.visible = false
            }
        }
    }

    MetadataInfo {
        id: metadataInfo
        anchors.right: parent.right
        anchors.top: videoOutput.fullScreen ? parent.top : menuBar.bottom
        anchors.bottom: playbackControl.opacity ? playbackControl.bottom : parent.bottom
        visible: false
    }

    TracksInfo {
        id: audioTracksInfo
        anchors.right: parent.right
        anchors.top: videoOutput.fullScreen ? parent.top : menuBar.bottom
        anchors.bottom: playbackControl.opacity ? playbackControl.bottom : parent.bottom
        visible: false
        onSelectedTrackChanged: mediaPlayer.activeAudioTrack = audioTracksInfo.selectedTrack
    }

    TracksInfo {
        id: videoTracksInfo
        anchors.right: parent.right
        anchors.top: videoOutput.fullScreen ? parent.top : menuBar.bottom
        anchors.bottom: playbackControl.opacity ? playbackControl.bottom : parent.bottom
        visible: false
        onSelectedTrackChanged: mediaPlayer.activeVideoTrack = videoTracksInfo.selectedTrack
    }

    TracksInfo {
        id: subtitleTracksInfo
        anchors.right: parent.right
        anchors.top: videoOutput.fullScreen ? parent.top : menuBar.bottom
        anchors.bottom: playbackControl.opacity ? playbackControl.bottom : parent.bottom
        visible: false
        onSelectedTrackChanged: mediaPlayer.activeSubtitleTrack = subtitleTracksInfo.selectedTrack
    }

    PlayerMenuBar {
        id: menuBar
        anchors.left: parent.left
        anchors.right: parent.right
        visible: !videoOutput.fullScreen

        mediaPlayer: mediaPlayer
        videoOutput: videoOutput
        metadataInfo: metadataInfo
        audioTracksInfo: audioTracksInfo
        videoTracksInfo: videoTracksInfo
        subtitleTracksInfo: subtitleTracksInfo

        onClosePlayer: root.close()
    }

    PlaybackControl {
        id: playbackControl
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        mediaPlayer: mediaPlayer
    }
}
