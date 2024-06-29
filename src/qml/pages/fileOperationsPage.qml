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
        id: fileRect
        color: "#2c313c"
        anchors.fill: parent

        Rectangle {
            id: contentRect
            width: 695
            height: 368
            color: "#00ffffff"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenterOffset: 1
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: encryptionRect
                y: 0
                height: 150
                color: "#00ffffff"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.leftMargin: 0

                Label {
                    id: encryptionLabel
                    color: "#fefeff"
                    text: qsTr("Encryption")
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12
                }

                Label {
                    id: fileLabel
                    y: 26
                    color: "#f0f3f7"
                    text: qsTr("File:")
                    anchors.left: parent.left
                    anchors.right: pathRect.left
                    anchors.rightMargin: 27
                    anchors.leftMargin: 8
                    font.pointSize: 12
                }

                Rectangle {
                    id: pathRect
                    x: 65
                    y: 26
                    width: 537
                    height: 20
                    color: "#ffffff"
                    anchors.right: openFileButton.left
                    anchors.rightMargin: 6

                    TextInput {
                        id: filePath
                        text: qsTr("")
                        readOnly: true
                        anchors.fill: parent
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Label {
                    id: chiperLabel
                    y: 52
                    color: "#fdfbfb"
                    text: qsTr("Chiper:")
                    anchors.left: parent.left
                    anchors.right: chiperRect.left
                    anchors.rightMargin: 6
                    anchors.leftMargin: 8
                    font.pointSize: 12
                }

                Rectangle {
                    id: chiperRect
                    x: 65
                    y: 52
                    width: 537
                    height: 20
                    color: "#ffffff"
                    anchors.right: encryptionButton.left
                    anchors.rightMargin: 6

                    ScrollView {
                        id: scrollView
                        x: -1
                        y: -6
                        width: 538
                        height: 26
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
                        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                        visible: false

                        TextArea {
                            id: chiperValue
                            x: -9
                            y: 4
                            width: 537
                            height: 18
                            readOnly: true
                            verticalAlignment: Text.AlignTop
                            placeholderText: qsTr("")
                        }
                    }
                }

                Label {
                    id: hashLabel
                    y: 78
                    color: "#f1f4f8"
                    text: qsTr("Hash:")
                    anchors.left: parent.left
                    anchors.right: hashRect.left
                    anchors.rightMargin: 16
                    anchors.leftMargin: 8
                    font.pointSize: 12
                }

                Rectangle {
                    id: hashRect
                    x: 65
                    y: 78
                    width: 537
                    height: 20
                    color: "#ffffff"
                    anchors.right: parent.right
                    anchors.rightMargin: 93
                    TextInput {
                        id: hashValue
                        text: qsTr("")
                        anchors.fill: parent
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                        readOnly: true
                    }
                }

                CustomButton {
                    id: openFileButton
                    width: 80
                    height: 20
                    x: 608
                    y: 26
                    text: qsTr("Select File")
                    anchors.right: parent.right
                    font.bold: true
                    font.pointSize: 10
                    anchors.rightMargin: 7
                    onClicked: {
                        fileDialog.open()
                    }
                }

                CustomButton {
                    id: encryptionButton
                    x: 608
                    y: 52
                    width: 80
                    height: 20
                    visible: false
                    text: qsTr("Encryption")
                    anchors.right: parent.right
                    anchors.rightMargin: 7
                    onClicked: {
                        ecc.onPushEncryptsMessage(filePath.text)
                        sendFileButton.visible = true
                        sendHashButton.visible = true
                        scrollView.visible = true
                    }
                }

                CustomButton {
                    id: sendFileButton
                    y: 109
                    width: 120
                    height: 30
                    text: qsTr("Send File")
                    visible: false
                    anchors.left: parent.left
                    font.bold: true
                    font.pointSize: 12
                    anchors.leftMargin: 65
                    onClicked: {
                        client.onPushSendFile()
                    }
                }

                CustomButton {
                    id: sendHashButton
                    x: 203
                    y: 109
                    width: 119
                    height: 30
                    text: qsTr("Send Hash")
                    visible: false
                    font.bold: true
                    font.pointSize: 12
                    onClicked: {
                        client.onPushSendHashFile()
                    }
                }

                CustomButton {
                    id: sendPublicKeyButton
                    x: 351
                    y: 109
                    width: 119
                    height: 30
                    text: qsTr("Send Pb Key")
                    font.bold: true
                    font.pointSize: 12
                    onClicked: {
                        client.onPushSendPublicKey()
                    }
                }

                CustomButton {
                    id: sendPrivateKeyButton
                    x: 482
                    y: 109
                    width: 120
                    height: 30
                    text: qsTr("Send Pr Key")
                    font.bold: true
                    font.pointSize: 12
                    onClicked: {
                        emailPopup.open()
                    }
                }

                FileDialog {
                    id: fileDialog
                    onAccepted: {
                        filePath.text = urlToPath(fileDialog.fileUrl)
                        encryptionButton.visible = true
                    }
                }
            }

            Rectangle {
                id: decryptionRect
                height: 213
                color: "#00ffffff"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: encryptionRect.bottom
                anchors.topMargin: 0
                anchors.rightMargin: 0
                anchors.leftMargin: 0

                Label {
                    id: decryptionLabel
                    color: "#f5eeee"
                    text: qsTr("Decryption")
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12
                }

                Label {
                    id: fileLabel1
                    y: 26
                    color: "#f0f3f7"
                    text: qsTr("File:")
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    font.pointSize: 12
                }

                CustomButton {
                    id: openFileButton1
                    y: 26
                    height: 20
                    text: qsTr("Select File")
                    anchors.left: pathRect1.right
                    anchors.right: parent.right
                    font.pointSize: 10
                    font.bold: true
                    anchors.leftMargin: 7
                    anchors.rightMargin: 7
                    onClicked: {
                        fileDialog2.open()
                    }
                }

                FileDialog {
                    id: fileDialog2
                    onAccepted: filePath1.text = urlToPath(fileDialog2.fileUrl)
                }

                Rectangle {
                    id: pathRect1
                    y: 26
                    width: 537
                    height: 20
                    color: "#ffffff"
                    anchors.left: fileLabel1.right
                    anchors.leftMargin: 27
                    TextInput {
                        id: filePath1
                        text: qsTr("")
                        anchors.fill: parent
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                        readOnly: true
                    }
                }

                Label {
                    id: fileHashLabel
                    y: 53
                    color: "#f1f4f8"
                    text: qsTr("FHash:")
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    font.pointSize: 12
                }

                Rectangle {
                    id: fileHashRect
                    y: 53
                    width: 537
                    height: 20
                    color: "#ffffff"
                    anchors.left: fileHashLabel.right
                    anchors.leftMargin: 8
                    TextInput {
                        id: fileHash
                        text: qsTr("")
                        anchors.fill: parent
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                        readOnly: true
                    }
                }

                FileDialog {
                    id: fileDialog3
                    onAccepted: {
                        fileHash.visible = false
                        fileHash.text = urlToPath(fileDialog3.fileUrl)
                        ecc.onPushFileHash(fileHash.text)
                    }
                }

                Label {
                    id: hashLabel1
                    y: 78
                    color: "#f1f4f8"
                    text: qsTr("Hash:")
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    font.pointSize: 12
                }

                Rectangle {
                    id: hashRect1
                    y: 78
                    width: 537
                    height: 20
                    color: "#ffffff"
                    anchors.left: hashLabel1.right
                    anchors.leftMargin: 16
                    TextInput {
                        id: hashValue1
                        text: qsTr("")
                        anchors.fill: parent
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                        readOnly: true
                    }
                }

                Label {
                    id: plainLabel
                    y: 159
                    color: "#fdfbfb"
                    text: qsTr("Plain:")
                    anchors.left: parent.left
                    anchors.leftMargin: 9
                    font.pointSize: 12
                }

                Rectangle {
                    id: plainRect
                    y: 156
                    height: 20
                    color: "#ffffff"
                    anchors.left: plainLabel.right
                    anchors.right: parent.right
                    anchors.rightMargin: 93
                    anchors.leftMargin: 17

                    ScrollView {
                        id: scrollView1
                        x: -1
                        y: -6
                        width: 538
                        height: 26
                        visible: false
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
                        ScrollBar.vertical.policy: ScrollBar.AlwaysOff

                        TextArea {
                            id: plainValue
                            x: -9
                            y: 4
                            width: 537
                            height: 18
                            readOnly: true
                            verticalAlignment: Text.AlignTop
                            placeholderText: qsTr("")
                        }
                    }
                }

                CustomButton {
                    id: genHashButton
                    y: 78
                    height: 20
                    text: qsTr("Gen Hash")
                    anchors.left: hashRect1.right
                    anchors.right: parent.right
                    font.bold: true
                    font.pointSize: 10
                    anchors.leftMargin: 6
                    anchors.rightMargin: 7
                    onClicked: {
                        ecc.onPushGenerateHash(filePath1.text)
                    }
                }

                CustomButton {
                    id: decryptionButton
                    width: 119
                    text: qsTr("Decryption")
                    anchors.top: plainRect.bottom
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.topMargin: 6
                    font.bold: true
                    font.pointSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        ecc.onPushDecryptsMessage(filePath1.text)
                        scrollView1.visible = true
                        server.setFileCounter()
                    }
                }

                CustomButton {
                    id: cmpHashButton
                    width: 125
                    height: 25
                    text: qsTr("Compare Hash")
                    anchors.top: hashRect1.bottom
                    anchors.topMargin: 10
                    font.bold: true
                    font.pointSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        ecc.onPushCompareHash(fileHash.text, hashValue1.text)
                    }
                }

                CustomButton {
                    id: openFileButton2
                    y: 53
                    height: 20
                    text: qsTr("Hash File")
                    anchors.left: fileHashRect.right
                    anchors.right: parent.right
                    font.bold: true
                    font.pointSize: 10
                    anchors.leftMargin: 6
                    anchors.rightMargin: 7
                    onClicked: {
                        fileDialog3.open()
                    }
                }

            }

            Connections {
                target: ecc
                function onPushCipherWithHash(cipherText_, hash) {
                    chiperValue.text = cipherText_
                    hashValue.text = hash
                }

                function onPushFileHash(file_hash) {
                    fileHash.text = file_hash
                    fileHash.visible = true
                }

                function onPushGenerateHash(gen_hash) {
                    hashValue1.text = gen_hash
                }

                function onPushPlain(plain) {
                    plainValue_.text = plain
                }
            }

            Connections {
                target: server
                function onPushInComingFileStatus() {
                    popup_text.text = "A new file was received."
                    popup.open()
                }
            }

            Connections {
                target: client
                function onPushSentFileStatus() {
                    popup_text.text = "File sent."
                    popup.open()
                }

                function onPushInComingFileStatus() {
                    popup_text.text = "A new file was received."
                    popup.open()
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

            Popup {
                id: emailPopup
                parent: Overlay.overlay
                background: Rectangle {
                    color: "#55aaff"
                    radius: 10
                }
                x: Math.round((parent.width - width) / 2)
                y: Math.round((parent.height - height) / 2)
                width: 240
                height: 80
                Label {
                    id: emailPopupText
                    color: "#fefeff"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.Top
                    font.pointSize: 12
                    text: qsTr("Enter the email")
                }
                Rectangle {
                    id: emailRect
                    x: 128
                    y: 35
                    width: 175
                    height: 20
                    color: "#ffffff"

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: emailPopupText.bottom

                    TextInput {
                        id: emailTextInput
                        text: qsTr("")
                        anchors.fill: parent
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                CustomButton {
                    id: sendEmailButton
                    width: 125
                    height: 20
                    text: qsTr("Send Private Key")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: emailRect.bottom
                    anchors.topMargin: 3
                    font.bold: true
                    font.pointSize: 10
                    onClicked: {
                        ecc.onPushSendPrivateKey(emailTextInput.text)
                    }
                }
            }
        }

        Label {
            id: title
            y: 8
            width: 296
            height: 39
            color: "#ffffff"
            text: qsTr("File Operations Page")
            anchors.bottom: contentRect.top
            anchors.horizontalCenterOffset: -5
            font.pointSize: 25
            anchors.bottomMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
        }

    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
##^##*/
