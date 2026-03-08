import QtQuick 2.6
import Sailfish.Silica 1.0

import QtPositioning 5.3
import QtLocation 5.0
import "../assets"

Page {
    PositionSource { id: positionSource }

    Map {
        id: map
        anchors.fill: parent
        zoomLevel: zoomSlider.value

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

        // ToDo: bind zoomLevel property to slider value



        // ToDo: add binding of the map center to the position coordinate
        Binding {
            target: map
            property: "center"
            value: positionSource.position.coordinate
            when: positionSource.position.coordinate.isValid
        }

        // ToDo: create MouseArea to handle clicks and holds
        MouseArea {
            anchors.top: parent.top
            width: parent.width
            anchors.bottom: slider.top
        }

        Component.onCompleted: center = QtPositioning.coordinate(55.751244, 37.618423)
    }
    // ToDo: add a slider to control zoom level
    Slider {
        id: zoomSlider
        anchors.bottom: parent.bottom
        width: parent.width
        minimumValue: map.minimumZoomLevel
        maximumValue: map.maximumZoomLevel
        valueText: value.toFixed(1)
    }

    // ToDo: add a component corresponding to MapQuickCircle

    // ToDo: add item at the current position

}
