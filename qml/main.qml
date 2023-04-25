import QtQuick
import QtQuick.Controls

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

    function popWindow(t){
        if(popComponent !== null){
             popW.close()
             popComponent.destroy()
        }
        popComponent = Qt.createComponent("GPopWindow.qml")
        popW = popComponent.createObject(mainWindow)
//        popW.text = t
        var point = mouseArea.mapToItem(null, mouseArea.mouseX, mouseArea.mouseY)
        popW.x = point.x + mainWindow.x
        popW.y = point.y + mainWindow.y
        console.log(popW.x, popW.y)
        popW.show()
    }
    Hotkey{
       id:hotkey
       onSelectedTextChanged: {
            popWindow(selectedText)
       }

    }

    Component.onCompleted: {
        hotkey.binding(app)
    }

    MouseArea{
        id:mouseArea
       anchors.fill: parent
       property variant clickPos: "1,1"
       onClicked: {

//           if(popComponent !== null){
//                popW.close()
//                popComponent.destroy()
//           }
//           popComponent = Qt.createComponent("GPopWindow.qml")
//           popW = popComponent.createObject(mainWindow)
//           var point = mapToItem(null, mouseX, mouseY)
//           popW.x = point.x + mainWindow.x
//           popW.y = point.y + mainWindow.y
//           popW.show()
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
