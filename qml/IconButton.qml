import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
Item {
    id: root
    width: 100
    height:100
    property url normalUrl      //常规状态下的图片路径
    property url hoveredUrl     //悬浮
    property url pressedUrl     //按下
    property url disabledUrl    //禁用

    property alias text:t.text    //下方标题
    property alias bold:t.font.bold
    property alias color:t.color
    property alias pixelSize:t.font.pixelSize

    property alias imageItem: img           //直接别名导出Image实例，外面可以修改其任意属性
    property alias imageUrl: img.source     //别名导出图片路径

    property alias imageWidth: img.width
    property alias imageHeight: img.height
    property alias imageAnchors: img.anchors
    property alias containsMouse: area.containsMouse
    property alias containsPress: area.containsPress
    //点击信号
    signal clicked();
    Image {
        id: img
        anchors.fill: parent
        smooth: true
        sourceSize.width: root.width * 2 //一定要比image大，否则会失真，太大也会失真
        sourceSize.height: root.height * 2
        //默认按鼠标状态选取不同的图片
        source: root.enabled ? (containsPress ? pressedUrl : (containsMouse ? hoveredUrl : normalUrl)) : disabledUrl
        ColorOverlay{
            id:overlay
            anchors.fill: img
            source:img
            color:"green"
            transform:rotation
            antialiasing: true
        }
        ColorOverlay{
            id:overlay2
            visible:false
            anchors.fill: overlay
            source:overlay
            color:"grey"
            transform:rotation
            antialiasing: true
            opacity:0.7
        }
    }
    Text {
        id:t
        anchors.centerIn:img
        text: ""
        horizontalAlignment: Text.AlignLeft
        color: "white"
        // font.bold: true
        font.pixelSize:24
    }

    MouseArea {
        id: area
        anchors.fill: parent;
        hoverEnabled: parent.enabled;
        onClicked: root.clicked();
        onPressed: {
           overlay2.visible = true
        }
        onReleased: {
            overlay2.visible = false

        }

        cursorShape: Qt.PointingHandCursor
        preventStealing: true
    }
}


