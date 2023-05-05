import QtQuick
import QtQuick.Controls

import QtLocation
import Qt5Compat.GraphicalEffects
Window {
    flags:Qt.Window | Qt.FramelessWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint

    id:popWindow
    height:20
    width:100
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    color: "transparent"



    Rectangle{
        id:_rect
        anchors.fill: parent
        radius:5
        clip:true

        Image {
             id: img
              source:"qrc:/res/icon.png"

             anchors.left:parent.left
             anchors.top: parent.top
             height:parent.height
             width:height
             fillMode: Image.PreserveAspectCrop
             layer.enabled: true
             layer.effect: OpacityMask {
                 maskSource: mask
             }
             MouseArea{
                anchors.fill: parent
                property variant clickPos: "1,1"
                onPressed: {
                    clickPos  = Qt.point(mouseX ,mouseY)
                }

                onPositionChanged: {
                    var delta = Qt.point(mouseX -clickPos.x, mouseY-clickPos.y)
                    popWindow.x += delta.x;
                    popWindow.y += delta.y;
                }
            }
         }

         Rectangle {
             id: mask
             width: popWindow.width
             height: width
             radius: 5
             visible: false
         }

    }



//    Column{
//        anchors.fill: parent
//        Button{
//            width:parent.width
//            height:parent.height/2

//        }
//        Button{
//            width:parent.width
//            height:parent.height/2

//        }
//    }



}
