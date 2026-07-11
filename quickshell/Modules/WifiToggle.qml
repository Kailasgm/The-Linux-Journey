// WifiPopup/WifiToggle.qml
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts

Item {
  implicitWidth: parent.width
  implicitHeight: 40

  RowLayout {
    anchors.fill: parent
    anchors.margins: 10

    Text {
      text: "WiFi"
      color: "#ff7ab4"
      font { family: "Liberation Mono"; pixelSize: 14; weight: 600 }
      Layout.fillWidth: true
    }

    Rectangle {
      width: 44
      height: 24
      radius: 12
      color: Networking.wifiEnabled ? "#121f33" : "#444444"

      Behavior on color {
        ColorAnimation { duration: 150 }
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
      }

      Rectangle {
        width: 18
        height: 18
        radius: 9
        color: "#3baaff"
        anchors.verticalCenter: parent.verticalCenter
        x: Networking.wifiEnabled ? 23 : 3

        Behavior on x {
          NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
        }
      }
    }
  }
}
