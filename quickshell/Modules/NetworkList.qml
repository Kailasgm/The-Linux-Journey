// WifiPopup/NetworkList.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: parent.width
  implicitHeight: listCol.implicitHeight

  property var wifiDevice
  signal connectRequested(string ssid)

  property var networks: []

  Component.onCompleted: scanProc.running = true

  Process {
    id: scanProc
    command: ["nmcli", "-t", "-f", "IN-USE,SSID,SIGNAL,SECURITY", "dev", "wifi", "list"]
    stdout: StdioCollector {
      onStreamFinished: {
        const lines = this.text.trim().split("\n")
        root.networks = lines.map(line => {
          const parts = line.split(":")
          return {
            active: parts[0] === "*",
            ssid: parts[1],
            signal: parseInt(parts[2]),
            secured: parts[3] !== ""
          }
        }).filter(n => n.ssid !== "")
      }
    }
  }

  ColumnLayout {
    id: listCol
    width: parent.width
    spacing: 2

    Repeater {
      model: root.networks
      delegate: Rectangle {
        required property var modelData
        width: listCol.width
        height: 36
        color: modelData.active ? "#512996" : (mouseArea.containsMouse ? "#1a1a2e" : "transparent")
        radius: 6

        RowLayout {
          anchors.fill: parent
          anchors.margins: 10

          Text {
            text: modelData.active ? "󰤨 " + modelData.ssid
                : modelData.signal >= 75 ? "󰤨 " + modelData.ssid
                : modelData.signal >= 50 ? "󰤥 " + modelData.ssid
                : modelData.signal >= 25 ? "󰤢 " + modelData.ssid
                : "󰤟 " + modelData.ssid
            color: modelData.active ? "#3baaff" : "#ffffff"
            font { family: "JetBrainsMono Nerd Font"; pixelSize: 13 }
            Layout.fillWidth: true
          }

          Text {
            visible: modelData.secured
            text: "󰌾"
            color: "#888888"
            font { family: "JetBrainsMono Nerd Font"; pixelSize: 13 }
          }

          Text {
            visible: modelData.active
            text: "✓"
            color: "#3baaff"
            font { pixelSize: 13 }
          }
        }

        MouseArea {
          id: mouseArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (!modelData.active)
              root.connectRequested(modelData.ssid)
          }
        }
      }
    }

    // refresh button
    Rectangle {
      Layout.fillWidth: true
      height: 30
      color: "transparent"
      radius: 6

      Text {
        anchors.centerIn: parent
        text: "󰑓 Refresh"
        color: refreshArea.containsMouse ?"#FFFFFF" : "#888888"
        font { family: "JetBrainsMono Nerd Font"; pixelSize: 12 }
      }

      MouseArea {
        id: refreshArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          scanProc.running = true
        }
      }
    }
  }
}
