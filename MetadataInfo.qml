import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Item {
    id: root
    implicitWidth: 200

    function clear() {
        elements.clear()
    }

    function read(metadata) {
        if (metadata) {
            for (var key in metadata.keys()) {
                if (metadata.stringValue(key)) {
                    elements.append({
                                        "name": metadata.metaDataKeyToString(
                                                    key),
                                        "value": metadata.stringValue(key)
                                    })
                }
            }
        }
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

        ListView {
            id: metadataList
            visible: elements.count > 0
            anchors.fill: parent
            model: elements
            delegate: RowLayout {
                width: metadataList.width
                Text {
                    Layout.preferredWidth: 90
                    text: model.name + ":"
                    horizontalAlignment: Text.AlignRight
                }
                Text {
                    Layout.fillWidth: true
                    text: model.value
                    wrapMode: Text.WrapAnywhere
                }
            }
        }

        Text {
            id: metadataNoList
            text: qsTr("No metadata present")
            visible: elements.count === 0
        }
    }
}
