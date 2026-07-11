import Quickshell
import QtQuick
import QtQuick.Layouts
import "../Components"
Item{
  id:root
  Layout.alignment: Qt.AlignCenter
  implicitWidth: rowLayout.implicitWidth
  implicitHeight: rowLayout.implicitHeight
  property var commandcenter
  RowLayout{
    id:rowLayout
    anchors.fill:parent
    spacing:10
    Rectangle {
      width: 22
      height: 25
      color:"#070f1a"
      AnimatedText{
          anchors.centerIn:parent
          text: "󰩈" 
          color:"#c964f5"
          scale:mouseArea.containsMouse ? 1.2 : 1

          font{
            family:"JetbrainsMono Nerd Font"
            pixelSize:25
            weight:1000
          }
      }
      MouseArea{
        id:mouseArea
        anchors.fill:parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        //onClicked: modelData.activate()
        onClicked:{
          commandcenter.toggle() 
        }
      } 
    }
  }
}
