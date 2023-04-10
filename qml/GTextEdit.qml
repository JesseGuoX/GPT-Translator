import QtQuick
import QtQuick.Controls

Flickable {
    id: flick
    
    property bool autoScroll:false
    property alias text: textedit.text
    property alias readOnly: textedit.readOnly
    property alias textedit: textedit


    contentWidth: width;
    contentHeight: textedit.height
    flickableDirection: Flickable.VerticalFlick
    clip: true
    function scrollToBottom() {
        if(flick.contentHeight - flick.height >= 0)
            flick.contentY = flick.contentHeight - flick.height
    }
    ScrollBar.vertical:ScrollBar {
        id: scrollbar
//        anchors {
//            top: parent.top
//            right: parent.right
//            bottom: parent.bottom
//        }
        width:10
        orientation: Qt.Vertical
        size: flick.height / flick.contentHeight

    }

    onContentHeightChanged: {
        if(autoScroll)
            flick.scrollToBottom()
    }
    TextEdit{
        id: textedit
        padding: 10
        wrapMode: TextEdit.WrapAnywhere
        width:flick.width
        font.pixelSize: 14
        selectByMouse:true
        selectByKeyboard:true
        color:"green"
    }
}
