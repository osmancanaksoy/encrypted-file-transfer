import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
    property bool stat: false

    Rectangle {
        id: registerRect
        color: "#2c313c"
        anchors.fill: parent
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Rectangle {
            id: registerContent
            color: "#00ffffff"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.rightMargin: 60
            anchors.leftMargin: 60
            anchors.bottomMargin: 60
            anchors.topMargin: 60

            Label {
                id: title
                y: 63
                color: "#ffffff"
                text: qsTr("Register Page")
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 30
            }

            Rectangle {
                id: valuesRect
                y: 120
                width: 442
                height: 181
                color: "#00ffffff"
                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: emailLabel
                    x: 38
                    y: 56
                    color: "#fcfdff"
                    text: qsTr("E-Mail:")
                    anchors.left: parent.left
                    anchors.top: surnameLabel.bottom
                    anchors.topMargin: 5
                    anchors.leftMargin: 13
                    font.pointSize: 12
                }

                Rectangle {
                    id: emailRect
                    y: 56
                    width: 245
                    height: 20
                    color: "#ffffff"
                    anchors.horizontalCenter: parent.horizontalCenter
                    TextInput {
                        id: emailInput
                        anchors.fill: parent
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Label {
                    id: passLabel
                    x: 38
                    color: "#fcfdff"
                    text: qsTr("Password:")
                    anchors.left: parent.left
                    anchors.top: emailLabel.bottom
                    anchors.topMargin: 4
                    anchors.leftMargin: 13
                    font.pointSize: 12
                }

                Rectangle {
                    id: passRect
                    y: 80
                    width: 245
                    height: 20
                    color: "#ffffff"
                    anchors.horizontalCenter: parent.horizontalCenter
                    TextInput {
                        id: passInput
                        anchors.fill: parent
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                        echoMode: TextInput.Password
                    }
                }

                CustomButton {
                    id: registerBtn
                    width: 100
                    height: 25
                    y: 122
                    text: qsTr("OK")
                    font.pointSize: 12
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        if(emailInput.text == "" && passInput.text == "") {
                            popup_text.text = "Please fill in the required fields for registration."
                            popup.open()
                        }
                        else {
                            database.get_register_values(emailInput.text, passInput.text)
                        }
                    }
                }
            }

            Connections {
                target: database
                function onPushQueryStatus(status) {
                    if(status === true) {
                        popup_text.text = "Registration successful."
                        popup.open()
                        stackView.push(Qt.resolvedUrl("loginPage.qml"))
                    }
                    else {
                        popup_text.text = "Registration failed."
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
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}D{i:3}D{i:5}D{i:7}D{i:6}D{i:8}D{i:10}D{i:9}
D{i:11}D{i:4}D{i:12}D{i:13}D{i:2}D{i:1}
}
##^##*/
