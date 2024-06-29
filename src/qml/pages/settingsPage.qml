import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.2
import "../controls"

Item {

    function urlToPath(urlString) {
        var s
        if (urlString.startsWith("file:///")) {
            var k = urlString.charAt(9) === ':' ? 8 : 7
            s = urlString.substring(k)
        } else {
            s = urlString
        }
        return decodeURIComponent(s);
    }

    Rectangle {
        id: settingsRect
        color: "#2c313c"
        anchors.fill: parent

        Rectangle {
            id: settingsContent
            width: 721
            height: 406
            color: "#00ffffff"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: serverRect
                x: 8
                y: 8
                width: 242
                height: 151
                color: "#2c313c"

                Label {
                    id: serverLabel
                    color: "#ffffff"
                    text: qsTr("Server Settings:")
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12
                }

                Label {
                    id: portLabel
                    x: 8
                    y: 66
                    color: "#f6fbff"
                    text: qsTr("Port:")
                    rotation: 0.892
                    font.pointSize: 12
                }

                ComboBox {
                    id: portComboBox
                    x: 51
                    y: 66
                    width: 170
                    height: 20
                    currentIndex: -1
                    textRole: qsTr("")
                    model: ListModel {
                        id: portModel
                        ListElement {text: "22333"}
                        ListElement {text: "33322"}
                    }
                }

                CustomButton {
                    id: startServerBtn
                    y: 118
                    width: 80
                    height: 25
                    text: "Start Server"
                    font.bold: true
                    visible: false
                    anchors.horizontalCenterOffset: -53
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        server.onPushStartServer(portComboBox.currentText)
                    }

                }

                CustomButton {
                    id: stopServerBtn
                    x: 141
                    y: 118
                    width: 80
                    height: 25
                    text: "Stop Server"
                    font.bold: true
                    visible: false
                    onClicked: {
                        server.onPushStopServer()
                    }

                }

                CustomButton {
                    id: setServerKeyBtn
                    y: 26
                    width: 104
                    height: 25
                    text: "Set Server Key"
                    anchors.horizontalCenterOffset: -65
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                    onClicked: {
                        serverKeyDialog.open()
                    }
                }

                CustomButton {
                    id: setServerCerBtn
                    y: 26
                    width: 124
                    height: 25
                    text: "Set Server Certificate"
                    anchors.horizontalCenterOffset: 60
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                    onClicked: {
                        serverCertDialog.open()
                    }
                }

                FileDialog {
                    id: serverKeyDialog
                    onAccepted: {
                        server.setLocalKey(urlToPath(serverKeyDialog.fileUrl))
                    }
                }

                FileDialog {
                    id: serverCertDialog
                    onAccepted: {
                        server.setLocalCertificate(urlToPath(serverCertDialog.fileUrl))
                        startServerBtn.visible = true
                        stopServerBtn.visible = true
                    }
                }
            }

            Rectangle {
                id: clientRect
                x: 317
                y: 8
                width: 396
                height: 151
                color: "#2c313c"

                Label {
                    id: clientLabel
                    color: "#ffffff"
                    text: qsTr("Client Settings:")
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12
                }

                Label {
                    id: ipLabel
                    x: 77
                    y: 35
                    color: "#f3f4f6"
                    text: qsTr("IP:")
                    font.pointSize: 12
                }

                Label {
                    id: portLabel2
                    x: 77
                    y: 61
                    color: "#fdfdfd"
                    text: qsTr("Port:")
                    font.pointSize: 12
                }

                CustomButton {
                    id: connectServerBtn
                    x: 50
                    y: 90
                    width: 125
                    height: 25
                    text: "Connect Server"
                    font.bold: true
                    visible: false
                    onClicked: {
                        client.onPushServerConnect(ipTextInput.text, portComboBox2.currentText)
                    }

                }

                CustomButton {
                    id: disconnectServerBtn
                    x: 217
                    y: 90
                    width: 125
                    height: 25
                    text: "Disconnect Server"
                    font.bold: true
                    visible: false
                    onClicked: {
                        client.onPushServerDisconnect()
                    }

                }

                ComboBox {
                    id: portComboBox2
                    x: 128
                    y: 61
                    width: 140
                    height: 20
                    currentIndex: -1
                    textRole: qsTr("")
                    model: ListModel {
                        id: portModel2
                        ListElement {text: "22333"}
                        ListElement {text: "33322"}
                    }
                }

                Rectangle {
                    id: rectangle
                    x: 128
                    y: 35
                    width: 140
                    height: 20
                    color: "#ffffff"

                    TextInput {
                        id: ipTextInput
                        text: qsTr("")
                        anchors.fill: parent
                        font.pixelSize: 12
                    }
                }

                CustomButton {
                    id: setClientCerBtn
                    x: 136
                    y: 121
                    width: 125
                    height: 25
                    text: "Set Certificate"
                    font.bold: true
                    onClicked: {
                        clientCertDialog.open()
                    }
                }

                FileDialog {
                    id: clientCertDialog
                    onAccepted: {
                        client.addCaCertficate(urlToPath(clientCertDialog.fileUrl))
                        connectServerBtn.visible = true
                        disconnectServerBtn.visible = true
                    }
                }
            }

            Rectangle {
                id: connectionRect
                x: 317
                y: 198
                width: 396
                height: 200
                color: "#2c313c"

                Label {
                    id: connectionLabel
                    color: "#fffcfc"
                    text: qsTr("Connection Status:")
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12
                }

                ScrollView {
                    id: scrollView
                    x: 4
                    y: 26
                    width: 388
                    height: 174

                    TextArea {
                        id: textArea
                        x: -10
                        y: -6
                        width: 380
                        height: 160
                        readOnly: true

                        placeholderText: qsTr("")
                        background: Rectangle {
                            color: "#ffffff"
                        }
                    }
                }
            }

            Rectangle {
                id: userRect
                x: 8
                y: 198
                width: 242
                height: 200
                color: "#2c313c"

                Label {
                    id: userLabel
                    y: 17
                    color: "#ffffff"
                    text: qsTr("User Settings:")
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: false
                    font.pointSize: 12
                }

                CustomButton {
                    width: 80
                    height: 25
                    text: "Log Out"
                    anchors.verticalCenter: parent.verticalCenter
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter

                    onClicked: {
                        popup_text.text = "Logging out of account."
                        popup.open()
                        stackView.push(Qt.resolvedUrl("homePage.qml"))
                        database.get_logout_status()
                    }

                }
            }

            Connections {
                target: server
                function onPushServerStatus(status) {
                    textArea.text += status + "\n"
                }
            }

            Connections {
                target: client
                function onPushClientStatus(status) {
                    textArea.text += status + "\n"
                }
            }

            Popup {
                id: popup
                parent: Overlay.overlay
                background: Rectangle {
                    color: "#55aaff"
                    radius: 10
                }
                x: Math.round((parent.width - width) / 2)
                y: Math.round((parent.height - height) / 2)
                width: 240
                height: 80
                Text {
                    id: popup_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("text")
                }
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}D{i:4}D{i:5}D{i:6}D{i:10}D{i:11}D{i:12}D{i:13}
D{i:14}D{i:15}D{i:3}D{i:17}D{i:18}D{i:19}D{i:20}D{i:21}D{i:22}D{i:27}D{i:26}D{i:28}
D{i:29}D{i:16}D{i:31}D{i:33}D{i:32}D{i:30}D{i:36}D{i:37}D{i:35}D{i:38}D{i:39}D{i:40}
D{i:2}D{i:1}
}
##^##*/
