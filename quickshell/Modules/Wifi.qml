import Quickshell
import Quickshell.Networking
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../Components"

Item {
  id: root
  Layout.alignment: Qt.AlignVCenter
  implicitWidth: rowLayout.implicitWidth
  implicitHeight: rowLayout.implicitHeight

  property bool clicked: false

  property var wifiDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi)
  property var active: wifiDevice ? wifiDevice.networks.values.find(n => n.connected) : null

  readonly property real signal: active ? active.signalStrength : 0

  readonly property string icon: {
    if (!Networking.wifiEnabled) return "󰤭"
    if (!active) return "󰤩"

    if (signal >= 0.75) return "󰤨"
    if (signal >= 0.50) return "󰤥"
    if (signal >= 0.25) return "󰤢"

    return "󰤟"
  }

  RowLayout {
    id: rowLayout
    anchors.fill: parent
    
    AnimatedText {
      text: "[ " + root.icon
      color: root.clicked ? "#996ffc" : (mouseArea.containsMouse ? "#c1a6ff" : "#996ffc")
      font {
        family: "JetBrainsMono Nerd Font"
        pixelSize: 14
        weight: 1000
      }
    }
    
    AnimatedText {
      text: {
        if (!Networking.wifiEnabled) return "Off"
        if (!root.active) return "Disconnected"

        return root.active.name
      }
      
      color: root.clicked ? "#8f84e3" : (mouseArea.containsMouse ? "#c1a6ff" : "#8f84e3")
      font {
        family: "JetBrainsMono"
        pixelSize: 12
        weight: 1000
      }
    }

    AnimatedText {
      text: " ]"
      color: root.clicked ? "#996ffc" : (mouseArea.containsMouse ? "#c1a6ff" : "#996ffc")
      font {
        family: "JetBrainsMono Nerd Font"
        weight: 1000
        pixelSize: 14
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    onClicked: (mouse) => {
      if (mouse.button === Qt.RightButton) {
        impalaProc.running = true
        root.clicked = true
        resetTimer.restart()
        
      } 
      else if (mouse.button === Qt.LeftButton) {
        Networking.wifiEnabled = !Networking.wifiEnabled 
        root.clicked = true
        resetTimer.restart()
      }
    }
  }
  Process {
    id:impalaProc
    command: ["ghostty" ,"-e", "impala"]
  }

  Timer {
    id: resetTimer
    interval: 100
    onTriggered: root.clicked = false
  }
}

