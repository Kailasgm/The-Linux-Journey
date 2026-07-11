import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Item {
  id: root
  width: parent.width
  implicitHeight: col.implicitHeight

  property string ssid: ""
  property bool needsPassword: false

  signal cancelled()
  signal connected()
  signal failed(string reason)

  onSsidChanged: {
    if (ssid !== "") {
      needsPassword = false
      checkProfileProc.command = ["nmcli", "-g", "NAME", "connection", "show"]
      checkProfileProc.running = true
    }
  }

  ColumnLayout {
    id: col
    width: parent.width
    spacing: 10
    visible: root.needsPassword

    Text {
      text: "Connect to: " + root.ssid
      color: "#ffffff"
      font { family: "Liberation Mono"; pixelSize: 13; weight: 600 }
    }

    Rectangle {
      Layout.fillWidth: true
      height: 40
      color: "#1a1a2e"
      radius: 6
      border.color: passInput.activeFocus ? "#996ffc" : "#121f33"
      border.width: 1

      TextInput {
        id: passInput
        // Anchor to all sides with explicit margins to enforce the bounded area
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        
        // Vertical center alignment ensures text sits correctly inside the box
        verticalAlignment: TextInput.AlignVCenter
        
        // Crucial: keeps text within the bounds of the input rectangle when long
        clip: true 
        
        color: "#ffffff"
        font { family: "Liberation Mono"; pixelSize: 13 }
        echoMode: TextInput.Password
        focus: root.needsPassword
      }
    }

    RowLayout {
      width: parent.width
      spacing: 8

      Rectangle {
        Layout.fillWidth: true
        height: 32
        color: cancelArea.containsMouse ? "#3a1a1a" : "#1a1a1a"
        radius: 6

        Text {
          anchors.centerIn: parent
          text: "Cancel"
          color: "#f74d7a"
          font { family: "Liberation Mono"; pixelSize: 13 }
        }

        MouseArea {
          id: cancelArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            passInput.text = ""
            root.cancelled()
          }
        }
      }

      Rectangle {
        Layout.fillWidth: true
        height: 32
        color: connectArea.containsMouse ? "#1a3a1a" : "#1a1a1a"
        radius: 6

        Text {
          anchors.centerIn: parent
          text: "Connect"
          color: "#73ff00"
          font { family: "Liberation Mono"; pixelSize: 13 }
        }

        MouseArea {
          id: connectArea
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (passInput.text.trim().length > 0) {
              connectProc.command = ["nmcli", "dev", "wifi", "connect", root.ssid, "password", passInput.text]
            } else {
              connectProc.command = ["nmcli", "connection", "up", "id", root.ssid]
            }
            connectProc.running = true
          }
        }
      }
    }
  }

  Process {
    id: checkProfileProc
    
    stdout: StdioCollector {
      onStreamFinished: {
        var profiles = this.text.split("\n");
        if (profiles.map(p => p.trim()).indexOf(root.ssid.trim()) !== -1) {
          connectProc.command = ["nmcli", "connection", "up", "id", root.ssid]
          connectProc.running = true
        } else {
          root.needsPassword = true
        }
      }
    }
  }

  Process {
    id: connectProc

    onExited: (code) => {
      passInput.text = ""
      if (code === 0) {
        root.connected()
      } else {
        if (!root.needsPassword) {
          root.needsPassword = true
        } else {
          root.failed("Exit code " + code)
        }
      }
    }
  }
}
