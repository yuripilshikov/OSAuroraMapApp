import QtQuick 2.6
import Sailfish.Silica 1.0

import QtPositioning 5.3
import QtLocation 5.0
import "../assets"

Page {
    PositionSource {
        id: positionSource
        active: true
        updateInterval: 1000
    }

    Map {
        id: map
        anchors.fill: parent

        Plugin {
            id: mapPlugin
            objectName: "mapPlugin"
            name: "webtiles"
            allowExperimental: false
            PluginParameter { name: "webtiles.scheme"; value: "https" }
            PluginParameter { name: "webtiles.host"; value: "tile.openstreetmap.org" }
            PluginParameter { name: "webtiles.path"; value: "/${z}/${x}/${y}.png" }
        }

        plugin: mapPlugin

        // ToDo: enable gesture recognition
        gesture.enabled: true
        // Ошибка: Cannot assign to non-existent property "acceptedGestures"
        //gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture | MapGestureArea.RotationGesture

        gesture.panEnabled: true
        gesture.pinchEnabled: true

        Binding {
            target: map
            property: "center"
            value: positionSource.position.coordinate
            when: positionSource.position.coordinate.isValid && bindingSwitch.checked
        }

        Binding {
            target: map
            property: "zoomLevel"
            value: zoomSlider.value
        }

        MouseArea {
            anchors.top: parent.top
            width: parent.width
            anchors.bottom: parent.bottom

            property var coordinate: map.toCoordinate(Qt.point(mouseX, mouseY))

            onClicked: {
                if(debugSwitch.checked)
                {
                    console.log("Coordinates clicked: " + coordinate.latitude
                                + " " + coordinate.longitude)
                    console.log("Current coordinates: "
                                + positionSource.position.coordinate.latitude
                                + " " + positionSource.position.coordinate.longitude)
                    console.log("Timestamp: " + positionSource.position.timestamp)
                }

                var circle = Qt.createQmlObject("import QtLocation 5.0; MapCircle{}", map);
                circle.center = coordinate;
                circle.radius = 5000.0
                circle.color = "orange"
                circle.border.width = 3
                map.addMapItem(circle)
            }
        }

        Component.onCompleted: {
            center = QtPositioning.coordinate(55.751244, 37.618423)
            console.log("Current coordinates: " + positionSource.position.coordinate.latitude
                        + " " + positionSource.position.coordinate.longitude)
            console.log("Timestamp: " + positionSource.position.timestamp)

            map.addMapItem(footprints)
        }
    }

    Footprints {
        id: footprints
        diameter: Math.min(map.width, map.height) / 8
        coordinate: positionSource.position.coordinate
    }

    // для отладки
    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        visible: debugSwitch.checked

        Label {
            text: "Коорд.: " + positionSource.position.coordinate.latitude.toFixed(4)
                      + " " + positionSource.position.coordinate.longitude.toFixed(4)
        }

        Label {
            text: "Скорость: " + positionSource.position.speed
        }
    }

    Slider {
        id: zoomSlider
        anchors.bottom: parent.bottom
        width: parent.width
        minimumValue: map.minimumZoomLevel
        maximumValue: map.maximumZoomLevel
        valueText: value.toFixed(1)
    }

    // вкл/выкл отладочные моменты
    Switch {
        id: debugSwitch
        anchors.right: parent.right
        anchors.top: parent.top
        icon.source: "image://theme/icon-s-setting"
        checked: false
    }

    // вкл/выкл binding
    Switch {
        id: bindingSwitch
        anchors.left: parent.left
        anchors.top: parent.top
        icon.source: "image://theme/icon-s-attach"
        checked: false
    }

}
