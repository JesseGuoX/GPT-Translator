import QtQuick
import QtQuick.Controls

import QtQuick.Layouts
import Qt.labs.platform
//import QtGraphicalEffects
import "."


Window {
    id: mainWindow
    visible: true
    width: 400
    height: 600
    minimumHeight:500
    minimumWidth:400
    title: qsTr("GPT Translator")

//    flags:Qt.Window | Qt.FramelessWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint
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
            icon.source: "qrc:///res/language-solid.svg"
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
                console.log("hjello")
                mainWindow.raise()
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
