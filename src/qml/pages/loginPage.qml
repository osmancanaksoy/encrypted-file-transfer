import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
    id: loginItem
    signal sendLoginStatus(bool status)
    Rectangle {
        id: loginRect
        color: "#2c313c"
        anchors.fill: parent

        Rectangle {
            id: contentRect
            width: 349
            height: 147
            color: "#00ffffff"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Label {
                id: mailLabel
                y: 18
                height: 19
                color: "#ffffff"
                text: qsTr("E-Mail:")
                anchors.left: parent.left
                anchors.right: mailRect.left
                anchors.rightMargin: 30
                anchors.leftMargin: 10
                font.pointSize: 12
            }

            Rectangle {
                id: mailRect
                x: 92
                y: 15
                width: 245
                height: 20
                color: "#ffffff"
                anchors.right: parent.right
                anchors.rightMargin: 12

                TextInput {
                    id: mail
                    anchors.fill: parent
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    echoMode: TextInput.Normal
                    passwordCharacter: ""
                }
            }

            Label {
                id: passLabel
                y: 47
                height: 19
                color: "#ffffff"
                text: qsTr("Password:")
                anchors.left: parent.left
                anchors.right: passRect.left
                anchors.leftMargin: 10
                anchors.rightMargin: 7
                font.pointSize: 12
            }

            Rectangle {
                id: passRect
                x: 92
                y: 47
                width: 245
                height: 20
                color: "#ffffff"
                anchors.right: parent.right
                anchors.rightMargin: 12
                TextInput {
                    id: password
                    anchors.fill: parent
                    font.pixelSize: 12
                    verticalAlignment: Text.AlignVCenter
                    echoMode: TextInput.Password
                    passwordCharacter: ""
                }
            }

            CustomButton {
                id: loginBtn
                width: 100
                height: 25
                y: 88
                text: qsTr("OK")
                font.bold: true
                font.pointSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    if(mail.text == "" && password.text == "") {
                        popup_text.text = "Please fill in the required fields for login."
                        popup.open()
                    }
                    else {
                        database.get_login_values(mail.text, password.text)
                    }
                }
            }

            Connections {
                target: database
                function onPushQueryStatus(status) {
                    if(status === true) {
                        popup_text.text = "Login successful."
                        popup.open()
                        stackView.push(Qt.resolvedUrl("fileOperationsPage.qml"))
                        sendLoginStatus(true)
                    }
                    else {
                        popup_text.text = "Login failed. Email or password is incorrect."
                        popup.open()
                    }
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

        Label {
            id: title
            y: 147
            width: 156
            height: 39
            color: "#ffffff"
            text: qsTr("Login Page")
            anchors.bottom: contentRect.top
            font.pointSize: 25
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
        }

    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}D{i:3}D{i:5}D{i:4}D{i:6}D{i:8}D{i:7}D{i:9}
D{i:10}D{i:11}D{i:2}D{i:14}D{i:1}
}
##^##*/
