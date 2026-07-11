import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

PanelWindow{
  id:root
  anchors{
    top:true
  }
  property var shellRoot
  visible: false
  color: "transparent"
  exclusiveZone: 1
  implicitHeight: 500
  implicitWidth:600
  function open() {
    visible = true
    grab.active = true
    shellRoot.commandcenterVisible = true

  }

  function close() {
    visible = false
    grab.active = false
    shellRoot.commandcenterVisible = false
  }

  function toggle() {
    if (visible)
        close()
    else
        open()
  }

  HyprlandFocusGrab{
    id:grab 
    windows: [ root ]
    onCleared: {
      root.close()
    }
  }
  Item{
    width: parent.width
    height:parent.height
    Rectangle{
      anchors.fill:parent 
      color:"#070f1a"
      radius:25
      border.width: 3
      border.color: "#c964f5"
      RowLayout{
        anchors.centerIn:parent
        Wifipopup{}
      }
    }
  }
}
