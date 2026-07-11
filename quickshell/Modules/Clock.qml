import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Components"

Item {
  id: root
  Layout.alignment: Qt.AlignVCenter
  implicitWidth: rowLayout.implicitWidth
  implicitHeight: rowLayout.implicitHeight
  property bool clicked: false

  RowLayout {
    id: rowLayout
    anchors.fill: parent

    SystemClock {
      id: clock
      precision: SystemClock.Minutes
    }

    AnimatedText {
      Layout.leftMargin:5
      text: Qt.formatDateTime(clock.date, "[ HH:mm AP ]")
      color: root.clicked ? "#ff7ab4" :(mouseArea.containsMouse ? "#ffb3d4" : "#ff7ab4")
      font {
        family: "JetBrainsMono Nerd Font Propo"
        weight: 900
        pixelSize: 14
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
