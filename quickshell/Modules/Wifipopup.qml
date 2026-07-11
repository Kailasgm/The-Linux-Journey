// WifiPopup.qml
import Quickshell
import Quickshell.Networking
import QtQuick
import QtQuick.Layouts

Item {
  id: root
  implicitWidth: 300
  implicitHeight: mainLayout.implicitHeight

  property var wifiDevice: Networking.devices.values
                            .find(d => d.type === DeviceType.Wifi)
  property string connectingTo: ""
  property bool showPassword: false

  ColumnLayout {
    id: mainLayout
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    spacing: 10

    WifiToggle {
      Layout.fillWidth: true
    }

    // Keep the list visible so the user sees feedback while checking profiles
    NetworkList {
      id: networkList
      wifiDevice: root.wifiDevice
      Layout.fillWidth: true
      
      onConnectRequested: (ssid) => {
        root.connectingTo = ssid
        root.showPassword = true
      }
    }

    // Appears naturally right below the list if nmcli demands a password
    PasswordPrompt {
      id: passwordPrompt
      ssid: root.connectingTo 
      visible: root.showPassword
      Layout.fillWidth: true
      
      onCancelled: root.showPassword = false
      onConnected: root.showPassword = false
      
      // If the background process fails or cancels, turn off the prompt visibility here too
      onFailed: root.showPassword = false
    }
  }
}
