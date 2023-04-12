import QtQuick
import QtQuick.Controls
Item {
    id: root
    width: 100
    height:100
    property url normalUrl      //常规状态下的图片路径
    property url hoveredUrl     //悬浮
    property url pressedUrl     //按下
    property url disabledUrl    //禁用

    property url checkedUrl

    property alias imageItem: img           //直接别名导出Image实例，外面可以修改其任意属性
    property alias imageUrl: img.source     //别名导出图片路径

    property alias imageWidth: img.width
    property alias imageHeight: img.height
    property alias imageAnchors: img.anchors
    property alias containsMouse: area.containsMouse
    property alias containsPress: area.containsPress

    property bool checkable:false
    property bool checked:false
    //点击信号
    signal clicked();

    function getSource(){
        if(checkable){
            return root.enabled ? (containsPress ? pressedUrl : (checked ? checkedUrl : normalUrl)) : disabledUrl
        }else{
            return root.enabled ? (containsPress ? pressedUrl : (containsMouse ? hoveredUrl : normalUrl)) : disabledUrl
        }
    }

    Image {
        id: img
        anchors.fill: parent
        smooth: true
        sourceSize.width: root.width * 2 //一定要比image大，否则会失真，太大也会失真
        sourceSize.height: root.height * 2
        //默认按鼠标状态选取不同的图片
        source: getSource()

    }

    MouseArea {
        id: area
        anchors.fill: parent;
        hoverEnabled: parent.enabled;
        onClicked: {
            root.clicked()
            if(checkable)
                checked = !checked
        }


        cursorShape: Qt.PointingHandCursor
        preventStealing: true
    }
}


