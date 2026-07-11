import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../Components"
Item{
  id:root

  Layout.alignment:Qt.AlignVCenter
  implicitWidth: rowLayout.implicitWidth
  implicitHeight: rowLayout.implicitHeight
  property bool clicked: false

  readonly property color power:"#ffa83d"
  RowLayout{
    id: rowLayout
    anchors.fill: parent 
    AnimatedText{
      Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
      Layout.bottomMargin:3
      text:"⌈"
      color:"#fcbb6a"

      font{
        family:"Cascadia Code"
        weight:700
        pixelSize:18
      }
    }
    AnimatedText{
      Layout.alignment:Qt.AlignVCenter 
      text:"󰐥"
      color: root.clicked ? "#ffa83d" :(mouseArea.containsMouse ? "#ff5959" : "#ffa83d")
      Layout.leftMargin: -3
      transformOrigin: Item.Center
      rotation: mouseArea.containsMouse ? 360: 0
      Layout.rightMargin:-3
      Layout.topMargin:2
      font{
        family:"Cascadia Code"
        weight:1000
        pixelSize:22
      }
      Behavior on rotation{NumberAnimation{duration:300}}
    }
    AnimatedText{
      Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
      Layout.topMargin:3
      Layout.rightMargin:10
      text:"⌋"
      color:"#fcbb6a"
      font{
        family:"Cascadia Code"
        weight:700
        pixelSize:18
      } 
    }
  }
  MouseArea {
    id:mouseArea
    anchors.fill: parent
    anchors.margins: -4
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      wlogoutProc.running=true
      root.clicked = true
      resetTimer.restart()
    }
  }   
  Process {
    id:wlogoutProc
    command: ["wlogout"]
  }
  Timer {
    id: resetTimer
    interval: 100
    onTriggered: root.clicked = false
  }
}

