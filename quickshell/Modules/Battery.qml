import Quickshell
import Quickshell.Services.UPower
import QtQuick 
import QtQuick.Layouts
import "../Components"

Item {
  id:root
  Layout.alignment:Qt.AlignVCenter
  implicitWidth: rowLayout.implicitWidth
  implicitHeight: rowLayout.implicitHeight
  property bool clicked: false
  property var battery: UPower.displayDevice
  property bool charging: battery.state === UPowerDeviceState.Charging
  property bool pending: battery.state === UPowerDeviceState.PendingCharge 
  readonly property color batteryColor:
    charging ? "#73ff00"
    : level <= 15 ? "#fc431e"
    : level <= 30 ? "#ff9d00"
    : "#0fb7fa"
  readonly property int level :Math.round(battery.percentage * 100)
  readonly property bool critical: level < 10 && !charging
  readonly property string icon: {
      if (charging)    return "󰂄"
      if (pending)     return "󰂄"
      if (level >= 90) return "󰁹"
      if (level >= 80) return "󰂂"
      if (level >= 70) return "󰂁"
      if (level >= 60) return "󰂀"
      if (level >= 50) return "󰁿"
      if (level >= 40) return "󰁾"
      if (level >= 30) return "󰁽"
      if (level >= 20) return "󰁼"
      if (level >= 10) return "󰁻"

      return "☠︎︎"
    }
  opacity: 1.0
  SequentialAnimation {
      running: root.critical
      loops: Animation.Infinite
      NumberAnimation { 
        target: root
        property: "opacity" 
        to: 0.2
        duration: 400 
      }
      NumberAnimation { 
        target: root
        property: "opacity"
        to: 1.0
        duration: 400 
      }
  }
  readonly property string bar: {
  const filled = Math.round(level / 10)

  return "[ "
        + "█".repeat(filled)
        + "░".repeat(10 - filled)//▮▮▮▮▯▯▯▯█"
        + " ]"
  }
  RowLayout {   
    id: rowLayout
    anchors.fill: parent
    AnimatedText{
      text: root.icon
      color: root.clicked ? batteryColor :( mouseArea.containsMouse ? "#8ad2ff" : batteryColor)
      font{
        family:"DejaVu Sans Mono"
        pixelSize:22
      }
    }
    
    AnimatedText{
      text: root.bar
      color: root.clicked ? batteryColor :( mouseArea.containsMouse ? "#8ad2ff" : batteryColor)
      font{
        family:"JetBrainsMono Nerd Font"
        weight:600
        pixelSize:14
      }
    }

    Item{
      Layout.preferredWidth: 40
      Layout.preferredHeight: 14

      AnimatedText {
        Layout.preferredWidth: 40
        Layout.alignment:Qt.AlignVCenter 
        horizontalAlignment: Text.AlignRight
        text:root.level+"%"
        color: root.clicked ? batteryColor :( mouseArea.containsMouse ? "#8ad2ff" : batteryColor)
        font { 
          family: "Liberation Mono"
          pixelSize: 14
          weight: 600 
        }
      }
    }
  }
  MouseArea {
    id: mouseArea
    anchors.fill: parent
    anchors.margins: -4
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked:{
      root.clicked = true
      resetTimer.restart()
    }
  }
   Timer {
    id: resetTimer
    interval:100
    onTriggered: root.clicked = false
  }
}
