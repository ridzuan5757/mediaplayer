import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: root
    implicitWidth: 200
    property int selectedTrack: 0

    function read(metadataList) {
        var LanguageKey = 6

        elements.clear()
        elements.append({
                            "language": "No Selected Track",
                            "trackNumber": -1
                        })

        if (!metadataList) {
            return
        }

        medatadataList.forEach(function (metadata, index) {
            var language = metadata.stringValue(LanguageKey)
            var label = language ? metadata.stringValue(
                                       LanguageKey) : "track " + (index + 1)
            elements.append({
                                "language": label,
                                "trackNumber": index
                            })
        })
    }

    ListModel {
        id: elements
    }

    Frame {
        anchors.fill: parent
        padding: 15

        background: Rectangle {
            color: "lightgray"
            opacity: 0.7
        }

        ButtonGroup {
            id: group
        }

        ListView {
            id: tracklist
            visible: elements.count > 0
            anchors.fill: parent
            model: elements
            delegate: RowLayout {
                width: tracklist.width
                RadioButton {
                    checked: model.trackNumber === selectedTrack
                    text: model.language
                    ButtonGroup.group: group
                    onClicked: {
                        selectedTrack = model.trackNumber
                    }
                }
            }
        }

        Text {
            id: metadataNoList
            visible: elements.count === 0
            text: qsTr("No tracks present")
        }
    }
}
