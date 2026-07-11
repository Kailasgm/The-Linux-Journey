import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../Components"

Item{
  id:root
  Layout.alignment:Qt.AlignVCenter
  implicitWidth: rowLayout.implicitWidth
  implicitHeight: rowLayout.implicitHeight

  property bool clicked: false

  readonly property var adapter: Bluetooth.defaultAdapter
  readonly property bool enabled: adapter && adapter.enabled
  readonly property var connectedDevice: adapter ? adapter.devices.values.find(d => d.connected) : null
  readonly property bool hasConnection: !! connectedDevice
  readonly property string icon : {
    if (!enabled) return"󰂲"
    if (!hasConnection) return ""
    return "󰂱"
  }
  readonly property string deviceTypeIcon: {
    if (!hasConnection) return ""
    const t = connectedDevice.icon
    if (t.includes("headset") || t.includes("headphone")) return "󰋋"  // earbuds/headphones glyph
    if (t.includes("mouse"))    return "󰍽"
    if (t.includes("keyboard")) return "󰌌"
    if (t.includes("phone"))    return "󰄜"
    return "󰂱" // generic connected fallback
  }
  RowLayout{
    id: rowLayout
    anchors.fill: parent

    AnimatedText{
      text:"[ "
      color:root.clicked ?  "#13b3f2" : (mouseArea.containsMouse ? "#77d7fc" : "#13b3f2")
      font{
        family:"JetBrainsMono Nerd Font"
        pixelSize:14
        weight:1000
      }
    }

    AnimatedText{
      text:root.icon
      Layout.leftMargin:-3
      color:root.clicked ?  "#13b3f2" : (mouseArea.containsMouse ? "#77d7fc" : "#13b3f2")
      font{
        family:"JetBrainsMono Nerd Font"
        pixelSize:15
        weight:1000
      }
    }
    AnimatedText{
      visible: root.hasConnection
      text: root.hasConnection ? root.connectedDevice.name : ""
      color: "#c0a3f0"
      font{
        family: "DejaVu Sans Mono"
        pixelSize: 11
        weight:1000
      }
    }
    AnimatedText{     
      text:root.deviceTypeIcon
      color: "#ababab"
      font{
        family: "JetBrainsMono Nerd Font"
        pixelSize: 11
        weight: mouseArea.containsMouse ? 1000 : 200
      }
    }
    AnimatedText{
      text:"]"
      Layout.leftMargin:-1
      color:root.clicked ?  "#13b3f2" : (mouseArea.containsMouse ? "#77d7fc" : "#13b3f2")
      font{
        family:"JetBrainsMono Nerd Font"
        pixelSize:14
        weight:1000
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
        if (root.adapter) root.adapter.enabled = !root.adapter.enabled
        root.clicked = true
        resetTimer.restart()
      }
    }
  }
  Process {
    id:impalaProc
    command: ["blueman-manager"]
  }
  Timer{
    id:resetTimer
    interval:100
    onTriggered:root.clicked=false
  } 
}
