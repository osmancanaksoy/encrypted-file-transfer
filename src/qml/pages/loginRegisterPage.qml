import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
    Rectangle {
        id: loginRegisterPage
        color: "#2c313c"
        anchors.fill: parent

        Rectangle {
            id: contentRect
            width: 738
            height: 260
            color: "#00ffffff"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            CustomButton {
                id: loginBtn
                width: 200
                height: 50
                text: qsTr("Login")
                anchors.left: parent.left
                anchors.top: title.bottom
                font.bold: true
                font.pointSize: 12
                anchors.topMargin: 50
                anchors.leftMargin: 100
                onClicked: stackView.push(Qt.resolvedUrl("loginPage.qml"))
            }

            CustomButton {
                id: registerBtn
                x: 475
                width: 200
                height: 50
                text: qsTr("Register")
                anchors.right: parent.right
                anchors.top: title.bottom
                font.bold: true
                font.pointSize: 12
                anchors.rightMargin: 100
                anchors.topMargin: 50
                onClicked: stackView.push(Qt.resolvedUrl("registerPage.qml"))
            }

            Label {
                id: title
                y: 79
                color: "#ffffff"
                text: qsTr("Login & Register")
                anchors.horizontalCenterOffset: 1
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 25
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}D{i:3}D{i:4}D{i:5}D{i:2}D{i:1}
}
##^##*/
