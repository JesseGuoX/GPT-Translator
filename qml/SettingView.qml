import QtQuick
import QtQuick.Controls
Item {
    signal backClicked;

    function reload(){
        setting.loadConfig()
        keyInput.text = setting.apiKey
        if(setting.model == "gpt-3.5-turbo")
            modelSelector.currentIndex = 0
        else if(setting.model == "gpt-4")
            modelSelector.currentIndex = 1
        
        saveBtn.visible = false
    }

    Item{
        id:header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.margins: 15
        height:50


        IconButton{
            width: 20
            height:20
            anchors.left: parent.left
            anchors.top: parent.top
            normalUrl:"qrc:///res/back.svg"
            hoveredUrl:"qrc:///res/back.svg"
            pressedUrl:"qrc:///res/back.svg"
            onClicked: {
                backClicked();
            }
        }



        IconButton{
            id:saveBtn
            width: 17.5
            height:20
            visible:false
            anchors.right: parent.right
            anchors.top: parent.top
            normalUrl:"qrc:///res/save.svg"
            hoveredUrl:"qrc:///res/save.svg"
            pressedUrl:"qrc:///res/save.svg"
            onClicked: {
                setting.apiKey = keyInput.text
                if(modelSelector.currentIndex == 0)
                    setting.model = "gpt-3.5-turbo"
                else
                    setting.model = "gpt-4"
                setting.updateConfig()
                visible = false
            }
        }

    }
    Text{
        id:apiText
        anchors.left: header.left
        anchors.top:header.bottom
        anchors.topMargin: 10
        text:"API Key"
        font.bold: true
        color:"green"
    }

    ScrollView {
        id:keyInputScroll
        anchors.left: header.left
        anchors.right: header.right
        anchors.top:apiText.bottom
        anchors.topMargin: 10
        height:80
        contentWidth: width
        contentHeight: keyInput.contentHeight
        ScrollBar.vertical: ScrollBar {
           width:(parent.contentHeight >= parent.height)?10:0
           height:parent.height
           anchors.right: parent.right
           policy: ScrollBar.AlwaysOn
       }
        TextArea{
            id:keyInput
            height:80
            font.pixelSize: 14
            wrapMode: Text.WrapAnywhere
            onTextChanged:{
               saveBtn.visible = true
            }

        }
    }

    Text{
        id:modelText
        anchors.left: header.left
        anchors.top:keyInputScroll.bottom
        anchors.topMargin: 10
        text:"Model"
        font.bold: true
        color:"green"
    }
    ComboBox {
        id:modelSelector
        anchors.left:parent.left
        anchors.top:modelText.bottom
        anchors.margins:10
        currentIndex: 0
        model:["GPT-3.5", "GPT-4"]
        onCurrentIndexChanged:{
            saveBtn.visible = true
        }
        height:40
    }

}
