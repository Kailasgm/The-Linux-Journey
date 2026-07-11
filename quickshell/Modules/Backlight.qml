import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../Components"
Item {
  id: root
  Layout.alignment:Qt.AlignVCenter
  implicitWidth: rowLayout.implicitWidth
  implicitHeight: rowLayout.implicitHeight

  property int brightness: 0
  property int maxBrightness: 800
  //Run :  ls /sys/class/backlight/    -- to find the backlight 
  //Run:  cat /sys/class/backlight/ur_backlight/max_brightness -- to find the number(maxBrightness)

  readonly property string icon: {
    if (brightness >= 70) return "󰃠"
    if (brightness >= 20) return "󰃟"
    return "󰃞"
  }
  readonly property string bar: {
    const filled = Math.min(10, Math.max(0, Math.round(brightness / 10)))
    return "[ " + "█".repeat(filled) + "░".repeat(10 - filled) + " ]"
  }

  RowLayout {
    id: rowLayout
    anchors.fill: parent
    
    AnimatedText {
      text: root.icon
      color : mouseArea.containsMouse ? "#ff99b3" : "#fc6a8f"
      font { 
        family: "JetBrainsMono Nerd Font"
        pixelSize: 16
        weight: 600 
      }
    }
    AnimatedText {
      text: root.bar
      color : mouseArea.containsMouse ? "#ff99b3" : "#fc6a8f"
      font { 
        family: "JetBrainsMono Nerd Font"
        pixelSize: 14
        weight: 600 
      }
    }
    Item{
      Layout.preferredWidth: 40   
      Layout.preferredHeight: 14

      Text {
        Layout.preferredWidth: 40
        Layout.alignment:Qt.AlignVCenter 
        horizontalAlignment: Text.AlignRight
        text: root.brightness + "%"
        color : mouseArea.containsMouse ? "#ff99b3" : "#fc6a8f"
        font { 
          family: "Liberation Mono"
          pixelSize: 14
          weight: 600 
        }
      }
    }
  }

  MouseArea {
    id:mouseArea
    anchors.fill: parent
    anchors.margins: -4
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onWheel: wheel => {
      if (wheel.angleDelta.y > 0) incProc.running = true
      else decProc.running = true
    }
  }

  Process {
    id: getProc
    command: ["brightnessctl", "-m"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        const parts = this.text.trim().split(",")
        const pctStr = parts.find(p => p.endsWith("%"))
        if (pctStr) root.brightness = parseInt(pctStr.replace("%", ""))
      }
    }
  }

  Process {
    id: incProc
    command: ["brightnessctl", "set", "5%+"]
    onRunningChanged: if (!running) getProc.running = true
  }

  Process {
    id: decProc
    command: ["brightnessctl", "set", "5%-"]
    onRunningChanged: if (!running) getProc.running = true
  }

  FileView {
    id: brightnessWatcher
    path: "/sys/class/backlight/nvidia_wmi_ec_backlight/brightness"  // fill in real path
    watchChanges: true
    onFileChanged: reload()
    onLoaded: {
      const raw = parseInt(text())
      // you'll also need max_brightness to compute %, read once or hardcode
      root.brightness = Math.round((raw / root.maxBrightness) * 100)
    }
  }
}
