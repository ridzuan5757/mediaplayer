import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root
    height: menuBar.height

    signal closePlayer

    required property MediaPlayer mediaPlayer
    required property VideoOutput videoOutput
    required property MetadataInfo metadataInfo
    required property TracksInfo audioTracksInfo
    required property TracksInfo videoTracksInfo
    required property TracksInfo subtitleTracksInfo

    function loadUrl(url) {
        mediaPlayer.stop()
        mediaPlayer.source = url
        mediaPlayer.play()
    }

    function showOverlay(overlay) {
        closeOverlays()
        overlay.visible = true
    }

    function closeOverlays() {
        metadataInfo.visible = false
    }

    MenuBar {
        id: menuBar
        anchors.left: parent.left
        anchors.right: parent.right

        Menu {
            title: qsTr("&File")
            Action {
                text: qsTr("&Open")
                onTriggered: fileDialog.open()
            }
            Action {
                text: qsTr("&URL")
                onTriggered: urlPopup.open()
            }
            Action {
                text: qsTr("&Exit")
                onTriggered: closePlayer()
            }
        }

        Menu {
            title: qsTr("&View")
            Action {
                text: qsTr("&Metadata")
                onTriggered: showOverlay(metadataInfo)
            }
        }

        Menu {
            title: qsTr("&Tracks")
            Action {
                text: qsTr("&Audio")
                onTriggered: showOverlay(audioTracksInfo)
            }
            Action {
                text: qsTr("&Video")
                onTriggered: showOverlay(videoTracksInfo)
            }
            Action {
                text: qsTr("&Subtitles")
                onTriggered: showOverlay(subtitleTracksInfo)
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
            mediaPlayer.stop()
            mediaPlayer.source = fileDialog.currentFile
            mediaPlayer.play()
        }
    }

    Popup {
        id: urlPopup
        anchors.centerIn: Overlay.overlay
        onOpened: {
            urlPopup.forceActiveFocus()
        }

        RowLayout {
            id: openUrl

            Label {
                text: qsTr("URL:")
            }

            TextInput {
                id: urlText
                focus: true
                Layout.minimumWidth: 400
                wrapMode: TextInput.WrapAnywhere
                Keys.onReturnPressed: {
                    loadUrl(text)
                    urlText.text = ""
                    urlPopup.close()
                }
            }

            Button {
                text: "Load"
                onClicked: {
                    loadUrl(text)
                    urlText.text = ""
                    urlPopup.close()
                }
            }
        }
    }
}
