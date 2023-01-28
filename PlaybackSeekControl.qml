import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root
    implicitHeight: 20

    required property MediaPlayer mediaPlayer

    RowLayout {
        anchors.fill: parent

        Text {
            id: mediaTime
            Layout.minimumWidth: 50
            Layout.minimumHeight: 18
            horizontalAlignment: Text.AlignRight
            text: {
                var m = Math.floor(mediaPlayer.position / 60000)
                var ms = (mediaPlayer.position / 1000 - m * 60).toFixed(1)
                return `${m}:${ms.padStart(4, 0)}`
            }
        }

        Slider {
            id: mediaSlider
            Layout.fillWidth: true
            enabled: mediaPlayer.seekable
            to: 1.0
            value: mediaPlayer.position / mediaPlayer.duration
            onMoved: mediaPlayer.setPosition(value * mediaPlayer.duration)
        }
    }
}
