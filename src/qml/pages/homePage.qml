import QtQuick 2.15
import QtQuick.Controls 2.15
import "../controls"

Item {
    Rectangle {
        id: homeRect
        color: "#2c313c"
        anchors.fill: parent

        Rectangle {
            id: contentRect
            width: 666
            height: 140
            color: "#00ffffff"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            CustomButton {
                id: nextBtn
                width: 150
                height: 50
                y: 76
                text: qsTr("Next")
                font.bold: true
                font.pointSize: 12
                anchors.horizontalCenterOffset: 0
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: stackView.push(Qt.resolvedUrl("loginRegisterPage.qml"))
            }

            Label {
                id: title
                x: 93
                y: 8
                color: "#ffffff"
                text: qsTr("Welcome to File Transfer System")
                font.pointSize: 25
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}D{i:3}D{i:4}D{i:2}D{i:1}
}
##^##*/
