import QtQuick
import QtQuick.Controls
import "."

Item {
    id:root
    height:25
    width:300

    property int currentIndex:0
    property alias model: repeater.model

    //蓝色选中框
    Rectangle{
        id:selector
        height: root.height
        width: 110
        anchors.top:parent.top
        anchors.verticalCenter: parent.verticalCenter
        x: 0
        radius:8
        gradient: Gradient {
            GradientStop { id:gstart; position: 0.0;    color: "#00CA00"  }
            GradientStop { id:gend; position: 1.0;    color: "#00B700" }
        }
        NumberAnimation on x {
            id:ani
            to: 0
            duration:200
            onRunningChanged:{
                if(!running){
                    if(ani.to === repeater.itemAt(0).x){
                        selector.width = repeater.itemAt(0).width
                        repeater.itemAt(0).textColor = "white"
                        repeater.itemAt(1).textColor = "green"
                        repeater.itemAt(2).textColor = "green"
                    }else if(ani.to === repeater.itemAt(1).x){
                        selector.width = repeater.itemAt(1).width

                        repeater.itemAt(1).textColor = "white"
                        repeater.itemAt(0).textColor = "green"
                        repeater.itemAt(2).textColor = "green"
                    }else if(ani.to === repeater.itemAt(2).x){
                        selector.width = repeater.itemAt(2).width

                        repeater.itemAt(2).textColor = "white"
                        repeater.itemAt(0).textColor = "green"
                        repeater.itemAt(1).textColor = "green"
                    }
                }
            }
        }

    }

    Row{
        anchors.fill: parent
        Repeater {
            id:repeater
            GRadioButton {
                anchors.verticalCenter: parent.verticalCenter
                text:modelData
                onClicked: {
                   ani.to = repeater.itemAt(index).x
                   ani.start()
                   currentIndex = index
               }
            }

        }
    }

}
