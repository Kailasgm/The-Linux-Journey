import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "Modules"

ShellRoot {
  id: shell
  property bool commandcenterVisible: false

  PanelWindow {
    anchors { top: true; right: true; left: true }
    implicitHeight: 40
    
    color: "transparent"

    Item {
      id: barContent
      width: parent.width
      clip: true
      height: shell.commandcenterVisible ? 0 : 40

      Behavior on height {
        NumberAnimation { duration: 200; easing.type: Easing.InOutCirc }
      }

      Rectangle {
        anchors.fill: parent
        color: "#070f1a"
      }
      //--------------------------------//
      //--------------LEFT--------------//
      //--------------------------------//
      RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        spacing: 20
        Clock{}
        Wifi{}
        Bluetooth{}
      }
      //--------------------------------//
      //-------------CENTER-------------//
      //--------------------------------//

      RowLayout {
        anchors.centerIn: parent
        spacing: 15
        Workspaces {} //commandcenter:commandcenter
      }

      //--------------------------------//
      //--------------RIGHT-------------//
      //--------------------------------//

      RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        spacing: 20
        Volume{}
        Backlight{}
        Battery{}
        PowerButton{}
      }
    }
  }

  //CommandCenter { 
  //  id:commandcenter 
  //  shellRoot: shell
  //}
}
