import Quickshell
import QtQuick
import QtQuick.Layouts

Item{
  id:root
  width: parent.width
  height:parent.height
  Rectangle{
    anchors.centerIn:parent
    height:350
    width:500
    color:"#070f1a"
    border.width:2
    border.color:"#30c964f5"
    radius:20
    ColumnLayout{
      anchors.fill:parent
      anchors.margins:20
      spacing:15
      Text{
        text:"WI-FI"
        color:"#c964f5"
        font{
          family:"JetBrainsMono Nerd Font"
          pixelSize:18
        }
      }
    }
  }
}

