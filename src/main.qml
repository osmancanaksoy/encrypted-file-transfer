import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtGraphicalEffects 1.15
import "qml/controls"


Window {
    id: mainWindow
    width: 1000
    height: 580
    minimumWidth: 800
    minimumHeight: 500
    visible: true
    title: qsTr("Hello World")
    color: "#00000000"

    //Remove title bar
    flags: Qt.Window | Qt.FramelessWindowHint

    //Properties
    property int windowStatus: 0
    property int windowMargin: 10

    //Internal function
    QtObject {
        id: internal

        function resetResizeBorders() {
            //Resize visibility
            resizeLeft.visible = true
            resizeRight.visible = true
            resizeBottom.visible = true
            resizeWindow.visible = true
        }

        function maximizeRestore() {
            if(windowStatus == 0) {
                mainWindow.showMaximized()
                windowStatus = 1
                windowMargin = 0
                //Resize visibility
                resizeLeft.visible = false
                resizeRight.visible = false
                resizeBottom.visible = false
                resizeWindow.visible = false
                btnMaximizeRest.btnIconSource = "images/svg_images/restore_icon.svg"
            }
            else {
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                //Resize visibility
                internal.resetResizeBorders()
                btnMaximizeRest.btnIconSource = "images/svg_images/maximize_icon.svg"
            }
        }

        function ifMaximizeWindowRestore() {
            if(windowStatus == 1) {
                mainWindow.showNormal()
                windowStatus = 0
                windowMargin = 10
                //Resize visibility
                internal.resetResizeBorders()
                btnMaximizeRest.btnIconSource = "images/svg_images/maximize_icon.svg"
            }
        }

        function restoreMargins() {
            windowStatus = 0
            windowMargin = 10
            //Resize visibility
            internal.resetResizeBorders()
            btnMaximizeRest.btnIconSource = "images/svg_images/maximize_icon.svg"
        }

    }

    Rectangle {
        id: bg
        color: "#2c313c"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: windowMargin
        anchors.leftMargin: windowMargin
        anchors.bottomMargin: windowMargin
        anchors.topMargin: windowMargin
        z: 1

        Rectangle {
            id: appContainer
            color: "#00000000"
            anchors.fill: parent
            anchors.rightMargin: 1
            anchors.leftMargin: 1
            anchors.bottomMargin: 1
            anchors.topMargin: 1

            Rectangle {
                id: topBar
                height: 60
                color: "#1c1d20"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                ToggleButton {
                    onClicked: animationMenu.running = true
                }

                Rectangle {
                    id: topBarDescription
                    y: 28
                    height: 24
                    color: "#282c34"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.leftMargin: 70
                    anchors.bottomMargin: 0

                    Label {
                        id: labelTopInfo
                        height: 25
                        color: "#5f6a82"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 10
                        anchors.bottomMargin: 0
                        anchors.rightMargin: 300
                        anchors.topMargin: 0
                    }

                    Label {
                        id: labelRightInfo
                        color: "#5f6a82"
                        text: qsTr("| HOME")
                        anchors.left: labelTopInfo.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter
                        anchors.rightMargin: 10
                        anchors.leftMargin: 0
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                    }
                }

                Rectangle {
                    id: titleBar
                    x: 70
                    width: 803
                    height: 25
                    color: "#00000000"

                    DragHandler {
                        onActiveChanged: if(active) {
                                             mainWindow.startSystemMove()
                                             internal.ifMaximizeWindowRestore()
                                         }
                    }

                    Image {
                        id: iconApp
                        width: 22
                        height: 22
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        source: "images/svg_images/file_transfer.svg"
                        anchors.leftMargin: 5
                        anchors.bottomMargin: 0
                        anchors.topMargin: 0
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        id: label
                        color: "#c3cbdd"
                        text: qsTr("File Transfer System")
                        anchors.left: iconApp.right
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        anchors.leftMargin: 5
                    }
                }

                Row {
                    id: rowButtons
                    x: 924
                    width: 105
                    height: 35
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 0
                    anchors.topMargin: 0

                    TopBarButton {
                        id: btnMinimize
                        onClicked: {
                            mainWindow.showMinimized()
                            internal.restoreMargins()
                        }
                    }

                    TopBarButton {
                        id: btnMaximizeRest
                        btnIconSource: "images/svg_images/maximize_icon.svg"
                        onClicked: internal.maximizeRestore()
                    }

                    TopBarButton {
                        id: btnClose
                        btnColorClicked: "#ff007f"
                        btnIconSource: "images/svg_images/close_icon.svg"
                        onClicked: mainWindow.close()
                    }
                }
            }

            Rectangle {
                id: content
                color: "#00000000"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: topBar.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 0

                Rectangle {
                    id: leftMenu
                    width: 70
                    color: "#1c1d20"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0

                    PropertyAnimation {
                        id: animationMenu
                        target: leftMenu
                        property: "width"
                        to: if(leftMenu.width == 70) return 250; else return 70
                        duration: 1000
                        easing.type: Easing.InOutQuint
                    }

                    Column {
                        id: columnMenus
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 0
                        anchors.leftMargin: 0
                        anchors.bottomMargin: 90
                        anchors.topMargin: 0

                        LeftMenuButton {
                            id: btnHome
                            text: qsTr("Home")
                            onClicked: {
                                btnHome.isActiveMenu = true
                                btnOpen.isActiveMenu = false
                                btnSettings.isActiveMenu = false
                                stackView.push(Qt.resolvedUrl("qml/pages/homePage.qml"))
                                labelRightInfo.text = "| HOME"
                            }

                        }

                        LeftMenuButton {
                            id: btnOpen
                            text: qsTr("File Operations")
                            btnIconSource: "images/svg_images/open_icon.svg"
                            visible: false
                            onClicked: {
                                btnOpen.isActiveMenu = true
                                btnHome.isActiveMenu = false
                                btnSettings.isActiveMenu = false
                                stackView.push(Qt.resolvedUrl("qml/pages/fileOperationsPage.qml"))
                                labelRightInfo.text = "| FILE OPERATIONS"
                            }
                        }
                    }

                    LeftMenuButton {
                        id: btnSettings
                        text: qsTr("Settings")
                        anchors.bottom: parent.bottom
                        btnIconSource: "images/svg_images/settings_icon.svg"
                        anchors.bottomMargin: 25
                        visible: false
                        onClicked: {
                            btnSettings.isActiveMenu = true
                            btnHome.isActiveMenu = false
                            btnOpen.isActiveMenu = false
                            stackView.push(Qt.resolvedUrl("qml/pages/settingsPage.qml"))
                            labelRightInfo.text = "| SETTINGS"
                        }
                    }
                }

                Rectangle {
                    id: contentPages
                    color: "#2c313c"
                    anchors.left: leftMenu.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    clip: true
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 25
                    anchors.topMargin: 0

                    StackView {
                        id: stackView
                        anchors.fill: parent
                        initialItem: Qt.resolvedUrl("qml/pages/homePage.qml")
                    }
                }

                Rectangle {
                    id: rectangle
                    color: "#282c34"
                    anchors.left: leftMenu.right
                    anchors.right: parent.right
                    anchors.top: contentPages.bottom
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 0
                    anchors.leftMargin: 0
                    anchors.bottomMargin: 0
                    anchors.topMargin: 0

                    Label {
                        id: labelTopInfo1
                        height: 25
                        color: "#5f6a82"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        verticalAlignment: Text.AlignVCenter
                        anchors.bottomMargin: 0
                        anchors.rightMargin: 30
                        anchors.topMargin: 0
                        anchors.leftMargin: 10
                    }

                    MouseArea {
                        id: resizeWindow
                        width: 25
                        height: 25
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.rightMargin: 0
                        cursorShape: Qt.SizeFDiagCursor

                        Image {
                            id: resizeImage
                            width: 16
                            height: 16
                            opacity: 0.5
                            anchors.fill: parent
                            source: "images/svg_images/resize_icon.svg"
                            anchors.leftMargin: 5
                            anchors.topMargin: 5
                            sourceSize.height: 16
                            sourceSize.width: 16
                            fillMode: Image.PreserveAspectFit
                            antialiasing: false
                        }

                        DragHandler {
                            target: null
                            onActiveChanged: if(active) {
                                                 mainWindow.startSystemResize(Qt.RightEdge | Qt.BottomEdge)
                                             }
                        }

                    }
                }
            }
        }
    }

    DropShadow {
        anchors.fill: bg
        horizontalOffset: 0
        verticalOffset: 0
        radius: 10
        samples: 16
        color: "#80000000"
        source: bg
        z: 0
    }

    MouseArea {
        id: resizeLeft
        width: 10
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor

        DragHandler {
            target: null
            onActiveChanged: if(active) {mainWindow.startSystemResize(Qt.LeftEdge)}
        }
    }

    MouseArea {
        id: resizeRight
        width: 10
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        cursorShape: Qt.SizeHorCursor

        DragHandler {
            target: null
            onActiveChanged: if(active) {mainWindow.startSystemResize(Qt.RightEdge)}
        }
    }

    MouseArea {
        id: resizeBottom
        height: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 0
        cursorShape: Qt.SizeVerCursor

        DragHandler {
            target: null
            onActiveChanged: if(active) {mainWindow.startSystemResize(Qt.BottomEdge)}
        }
    }

    Connections {
        target: database
        function onPushLogInStatus(status) {
            if(status === true) {
                btnHome.visible = false
                btnOpen.visible = true
                btnSettings.visible = true
            }
        }
    }

    Connections {
        target: database
        function onPushLogOutStatus(status) {
            if (status === true) {
                btnHome.visible = true
                btnOpen.visible = false
                btnSettings.visible = false
            }
        }
    }

}


/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}D{i:1}D{i:5}D{i:7}D{i:8}D{i:6}D{i:10}D{i:11}D{i:12}D{i:9}
D{i:14}D{i:15}D{i:16}D{i:13}D{i:4}D{i:19}D{i:21}D{i:22}D{i:20}D{i:23}D{i:18}D{i:25}
D{i:24}D{i:27}D{i:29}D{i:30}D{i:28}D{i:26}D{i:17}D{i:3}D{i:2}D{i:31}D{i:33}D{i:32}
D{i:35}D{i:34}D{i:37}D{i:36}D{i:38}D{i:39}
}
##^##*/
