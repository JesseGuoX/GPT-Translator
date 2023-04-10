import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Controller
import QtTextToSpeech

import QtQuick.Controls.Material
import "."
Item {

    signal settingClicked;
    function startTrans(){
        if(inputArea.text.length > 0 && transBtn.visible)
            transBtn.clicked()
    }

    function getMode(){
        return transRadio.currentIndex
    }

    function speekDisplay(){
        if(getMode() === 0){
            if((result.text.length > 0) && (langSelector.currentText === "English")){
                return true
            }
        }else if(getMode() === 1){
            if((inputArea.text.length > 0)){
                return true
            }
        }else if(getMode() === 2){
            if((result.text.length > 0)){
                return true
            }
        }
        return false
    }

    TextToSpeech {
        id: tts
        volume: 1
        pitch: 0
        rate: 0
    }


    Item{
        id:header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.margins: 15

        height:50

        GRadioGroup{
            id:transRadio
            model: ["Translation", "Dictionary", "Grammar"]
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            onCurrentIndexChanged: {
                switch(currentIndex){
                case 0:{
                    indictor.text = "Translated"
                    transBtn.text = (Qt.platform.os === "macos" || Qt.platform.os === "osx")?"Translate ⌘R":"Translate ^R"
                    langSelector.visible = true
                }break;
                case 1:{
                    indictor.text = "Word"
                    transBtn.text = (Qt.platform.os === "macos" || Qt.platform.os === "osx")?"Lookup ⌘R":"Lookup ^R"
                    langSelector.visible = true
                }break;
                case 2:{
                    indictor.text = "Grammar fixed"
                    transBtn.text = (Qt.platform.os === "macos" || Qt.platform.os === "osx")?"Fix ⌘R":"Fix ^R"
                    langSelector.visible = false
                }break;
                }
                result.text = ""
            }
        }


        IconButton{
            id:settingBtn
            width: 18
            height:18
            anchors.right: parent.right
            anchors.top: parent.top
            normalUrl:"qrc:///res/setting.svg"
            hoveredUrl:"qrc:///res/setting.svg"
            pressedUrl:"qrc:///res/setting.svg"
            onClicked: {
                settingClicked();
            }
        }

        Item{
            id:tItem
            width: 22
            height:22
            anchors.horizontalCenter: settingBtn.horizontalCenter
            anchors.top: settingBtn.bottom
            anchors.topMargin: 10
            state:"no"
            Image{
                id:tyes
                anchors.fill: parent
                source:"qrc:///res/thumbtack_yes.png"
                visible:tItem.state === "yes"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mainWindow.flags = mainWindow.flags & (0xFFFFFF ^ Qt.WindowStaysOnTopHint)
                        tItem.state = "no"

                    }
                }
            }
            Image{
                id:tyno
                anchors.fill: parent
                source:"qrc:///res/thumbtack_no.png"
                visible:tItem.state === "no"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mainWindow.flags = mainWindow.flags |Qt.WindowStaysOnTopHint
                        tItem.state = "yes"

                    }
                }
            }
        }



    }

    Item{
        id:inputItem
        anchors.margins: 10
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height/3
        clip:true
        Rectangle {
            radius: 6
            color: "transparent"
            border.width : 1
            border.color: "green"
            anchors.fill: parent
        }
        GTextEdit{
            id:inputArea
            anchors.fill: parent
            autoScroll:false
            textedit.focus : true
        }
    }


    Text{
        id:indictor
        text:"Translated"
        anchors.left: inputItem.left
        anchors.top:inputItem.bottom
        font.bold: true
        color:"green"
        anchors.topMargin: 30

    }

    IconButton{
        id:speakerBtn
        width: 18
        height:18
        anchors.verticalCenter: indictor.verticalCenter
        anchors.right: inputItem.right
        normalUrl:"qrc:///res/speaker.svg"
        hoveredUrl:"qrc:///res/speaker.svg"
        pressedUrl:"qrc:///res/speaker.svg"
        visible:speekDisplay()
        onClicked: {
            if(getMode() === 1){
                //if in dictionary mode then say input inputArea
                tts.say(inputArea.text)
            }else{
                tts.say(result.text)
            }

        }
    }

    GTextEdit{
        id:result
        anchors.left: inputItem.left
        anchors.right: inputItem.right
        anchors.top:indictor.bottom
        anchors.topMargin: 5
        anchors.bottom: langSelector.top
        anchors.bottomMargin: 10
        autoScroll:true
        readOnly:true
    }

    Button{
        id:transBtn
        anchors.bottom: parent.bottom
        anchors.right:parent.right
        anchors.margins:10
        text:(Qt.platform.os == "macos" || Qt.platform.os == "osx")?"Translate ⌘R":"Translate ^R"
        font.capitalization: Font.MixedCase
        enabled:inputArea.text.length > 0
        onClicked: {
            api.sendMessage(inputArea.text, getMode())
        }
        height:50
        Material.background: Material.Green
        Material.foreground :"white"

    }
    BusyIndicator {
        anchors.verticalCenter: stopBtn.verticalCenter
        anchors.right:stopBtn.left
        anchors.rightMargin: 10
        running: api.isRequesting
        visible:api.isRequesting
        width:transBtn.height - 10
        height:width
    }
    Button{
        id:stopBtn
        visible:false
        anchors.bottom: parent.bottom
        anchors.right:parent.right
        anchors.margins:10
        text:"stop"
        onClicked: {
            api.abort()
        }
        Material.background: Material.Green
        Material.foreground :"white"
    }

    ComboBox {
        id:langSelector
        anchors.bottom: parent.bottom
        anchors.left:parent.left
        anchors.margins:10
        currentIndex: 0
        model:["简体中文","繁体中文", "English", "Japanse", "German", "Korean", "Español", "français"]
        onCurrentTextChanged: {
            api.transToLang = currentText
        }
        height:40
    }

    APIController{
        id:api
        onResponseDataChanged: {
            result.text = responseData
        }
        onResponseErrorChanged: {
            if(responseError != ""){
                result.text = responseError + ":\n" + result.text
            }
        }
        onIsRequestingChanged: {
            if(isRequesting){
                transBtn.visible = false
                stopBtn.visible = true
            }else{
                transBtn.visible = true
                stopBtn.visible = false
            }
        }
        Component.onCompleted: {
            api.apiKey = setting.apiKey
            api.model = setting.model
            api.apiServer = setting.apiServer
        }
    }
    Connections{
        target: setting
        function onApiServerChanged(){
            api.apiServer = setting.apiServer
        }
        function onApiKeyChanged(){
            api.apiKey = setting.apiKey
        }
        function onModelChanged(){
            api.model = setting.model
        }
    }
}
