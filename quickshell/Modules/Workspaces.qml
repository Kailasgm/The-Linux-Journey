import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import "../Components"
Item{
  id:root
  Layout.alignment: Qt.AlignCenter
  implicitWidth: rowLayout.implicitWidth
  implicitHeight: rowLayout.implicitHeight
  //property var commandcenter
  RowLayout{
    id:rowLayout
    anchors.fill:parent
    spacing:10 
    Repeater{
      model:Hyprland.workspaces
      Rectangle {
        required property var modelData
        property bool isActive: Hyprland.focusedWorkspace?.id === modelData.id
        width: 22
        height: 25
        color:"#070f1a"
        //font.pixelSize: mouseArearea.containsMouse ? 18 : 16
        //color: mouseArea.containsMouse ? "#c964f5" : "#c964f5"
        AnimatedText{
            anchors.centerIn:parent
            text: isActive ? "" : ""
            color:"#c964f5"
            scale:mouseArea.containsMouse ? 1.2 : 1

            font{
              family:"JetbrainsMono Nerd Font"
              pixelSize:15
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
            //if(isActive){
            //  commandcenter.toggle()
            // }
            //  else{
              Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.modelData.id ) + "})")
          } 
        } 
      }
    }
  }
}
