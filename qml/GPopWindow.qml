import QtQuick

Window {
    flags:Qt.Window | Qt.FramelessWindowHint | Qt.WindowTitleHint | Qt.WindowSystemMenuHint

    id:popWindow
    height:100
    width:100
    color:"green"

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
