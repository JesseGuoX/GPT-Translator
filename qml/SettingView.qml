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
        anchors.margins: 10
        height:50

        Button{
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            text:"Main"
            onClicked: {
                backClicked();
            }
        }
        Button{
            id:saveBtn
            visible:false
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text:"Save"
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
    TextArea{
        id:keyInput
        height:50
        anchors.left: header.left
        anchors.right: header.right
        anchors.top:apiText.bottom
        anchors.topMargin: 10
        font.pixelSize: 14
        onTextChanged:{
           saveBtn.visible = true
        }

    }
    Text{
        id:modelText
        anchors.left: header.left
        anchors.top:keyInput.bottom
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
    }

}
