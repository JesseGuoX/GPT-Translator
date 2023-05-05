import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import Qt.labs.platform

import "."

import Controller


Window {
    id: mainWindow
    visible: true
    width: 400
    height: 600
    minimumHeight:500
    minimumWidth:400
    title: qsTr("GPT Translator")

    property Component  popComponent: null
    property QtObject  popW: null


//    flags:Qt.Window | Qt.FramelessWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint

    function popWindow(t, pos){

        if(popComponent !== null){
            popW.close()
             popComponent.destroy()
        }

        popComponent = Qt.createComponent("GPopWindow.qml")
        if (popComponent.status === Component.Ready) {
            popW = popComponent.createObject(mainWindow)
            if (popW) {
                popW.x = pos.x
                popW.y = pos.y
                popW.visible = true
                popW.show()
                popW.raise()
                popW.requestActivate()
                mainWindow.visible = false
            } else {
                console.error("Error creating new window:", popComponent.errorString())
            }
        } else {
            console.error("Error loading DynamicWindow component:", popComponent.errorString())
        }

    }
    Hotkey{
       id:hotkey
       onSelectedTextChanged: {
//            popWindow(selectedText, mousePos)
           appView.inputText = selectedText
           appView.startTrans()
           mainWindow.show()
           mainWindow.raise()
           mainWindow.requestActivate()

       }

    }



    Component.onCompleted: {
        hotkey.binding(app)
        hotkey.setShortcut(setting.shortCut)
    }

    MouseArea{
        id:mouseArea
       anchors.fill: parent
       property variant clickPos: "1,1"
       onClicked: {

       }

       onPressed: {
           clickPos  = Qt.point(mouseX ,mouseY)
       }

       onPositionChanged: {
           var delta = Qt.point(mouseX -clickPos.x, mouseY-clickPos.y)
           mainWindow.x += delta.x;
           mainWindow.y += delta.y;
       }
   }

    onActiveChanged: {
//        if(active){
//            mainWindow.visible = true
//        }else{
//            if(!appView.pinned)
//            mainWindow.visible = false
//        }
    }





    Item{
        anchors.fill: parent
        focus: true
        Keys.onPressed:(event)=> {
            if ((event.modifiers & Qt.ControlModifier) && event.key === Qt.Key_R ||
               (event.modifiers & Qt.MetaModifier) && event.key === Qt.Key_R) {
              // Command+R or Ctrl+R pressed
            appView.startTrans()
            }
        }

        SystemTrayIcon {
            id: trayIcon
            visible:true
            icon.source: (Qt.platform.os === "macos" || Qt.platform.os === "osx")?"qrc:///res/tray.png":"qrc:///res/logo/logo.png"
            // create menu for status bar

            menu: Menu {

                MenuItem {
                    text: "Quit"
                    onTriggered: {
                        Qt.quit()
                    }
                }
            }

            onActivated:{
                mainWindow.show()
                mainWindow.raise()
                mainWindow.requestActivate()

//                mainWindow.x = trayIcon.geometry.x - mainWindow.width/2
//                mainWindow.y = trayIcon.geometry.y + 50
//                mainWindow.visible = true
            }


        }

        SwipeView {
            id: swipeView
            currentIndex: 0
            anchors.fill: parent
            orientation: Qt.Horizontal
            interactive: false
            AppView{
                id:appView
                height:mainWindow.height
                onSettingClicked: {
                    settingView.reload()
                    swipeView.currentIndex = 1
                }
            }
            SettingView{
                id:settingView
                onBackClicked: {
                    swipeView.currentIndex = 0
                }
            }
        }
    }



}
