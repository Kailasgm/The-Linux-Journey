import QtQuick

Text{
  Behavior on color { ColorAnimation { duration: 100 } }
  Behavior on scale {NumberAnimation{duration:100}}
  scale: mouseArea.containsMouse ? 1.07 : 1.0
}
