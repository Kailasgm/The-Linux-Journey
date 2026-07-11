import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import "../Components"
Item{
  id:root
  Layout.alignment:Qt.AlignVCenter
  implicitWidth: rowLayout.implicitWidth
  implicitHeight: rowLayout.implicitHeight

  property bool clicked:false

  property var sink:Pipewire.defaultAudioSink

  readonly property bool ready: sink && sink.ready
  readonly property bool muted: ready && sink.audio.muted
  readonly property int vol: ready ? Math.round((sink.audio.volume) * 100): 0
  readonly property string icon: {
        if (muted) return "󰖁"
        if (vol >= 67) return ""
        if (vol >= 33) return ""
        if (vol > 0)   return ""
        return "󰖁"
  }

  readonly property string bar: {
  const filled = Math.min(10,Math.max(0,Math.round(vol / 10)))

  return "[ "
        + "█".repeat(filled)
        + "░".repeat(10 - filled)
        + " ]"
  }
  readonly property color audioColor:
    muted ? "#f74d7a"
          : vol === 0 ? "#f74d7a"
          : "#a37afa"
  RowLayout{
    id: rowLayout
    anchors.fill: parent        

    AnimatedText{
      text: root.icon
      scale: root.muted
          ? (mouseArea.containsMouse ? 0.77 : 0.7)// Ahh did this because Nerd Font has a spacing Issue 
          : (mouseArea.containsMouse ? 1.07 : 1.0)//Its not pretty but gets the job done 
      color: root.muted
        ? (mouseArea.containsMouse ? "#fa7d9e" : audioColor)
        : (mouseArea.containsMouse ? "#c7adff" : audioColor)

      font{
        family:"DejaVu Sans Mono"
        pixelSize: 30
      }
    }
    AnimatedText{
      text: root.bar
      color: root.muted
             ? (mouseArea.containsMouse ? "#fa7d9e" : audioColor)
             : (mouseArea.containsMouse ? "#c7adff" : audioColor)
      font{
        family:"JetBrainsMono Nerd Font"
        pixelSize:14
        weight:600
      }
    }

    Item{
      Layout.preferredWidth: 40   
      Layout.preferredHeight: 14

      AnimatedText {
        Layout.preferredWidth: 40
        Layout.alignment:Qt.AlignVCenter 
        horizontalAlignment: Text.AlignRight
        text: root.vol + "%"
        color: root.muted
             ? (mouseArea.containsMouse ? "#fa7d9e" : audioColor)
             : (mouseArea.containsMouse ? "#c7adff" : audioColor)
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
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    
    onWheel: wheel => {
        if (wheel.angleDelta.y > 0) {
            sink.audio.volume = Math.min(1.0,sink.audio.volume + 0.05)
        } 
          else {
            sink.audio.volume = Math.max(0.0,sink.audio.volume - 0.05)
        }
    }
    
    onClicked: {
      sink.audio.muted = !sink.audio.muted
    }
  }
   PwObjectTracker {
    objects:[root.sink]
  }
}

