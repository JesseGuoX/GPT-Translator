import QtQuick
import QtQuick.Controls

Button {
    property alias textColor: t.color
    id:btn
    width:t.width + 20
    height:t.height + 10
    background: Rectangle{
        anchors.fill: parent
        opacity: btn.pressed?0.5:0
        color:"transparent"
    }
    contentItem: Item{
        Text {
            id:t
            text: btn.text
            font: btn.font
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            color:"white"

        }
    }
    font.bold: true
    font.capitalization: Font.MixedCase

}
