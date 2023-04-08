import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Controller
import QtTextToSpeech

import QtQuick.Controls.Material
Item {

    signal settingClicked;
    function startTrans(){
        transBtn.clicked()
    }

    TextToSpeech {
            id: tts
            volume: 0.5
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
        RowLayout {
            RadioButton {
                checked: true
                text: qsTr("Translation")
            }
            RadioButton {
                text: qsTr("Dictionary")
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
        IconButton{
            width: 13
            height:18
            anchors.horizontalCenter: settingBtn.horizontalCenter
            anchors.top: settingBtn.bottom
            anchors.topMargin: 10
            normalUrl:"qrc:///res/thumbtack.svg"
            hoveredUrl:"qrc:///res/thumbtack.svg"
            pressedUrl:"qrc:///res/thumbtack.svg"
            state:"0"
            onClicked: {
                tts.say(result.text)
                if(state == "0"){
                    state = "1"
                    mainWindow.flags = mainWindow.flags |Qt.WindowStaysOnTopHint
                }else{
                    state = "0"
                    mainWindow.flags = mainWindow.flags & (0xFFFFFF ^ Qt.WindowStaysOnTopHint)

                }

            }
        }

    }


    ScrollView {
        id: inputScroll
        width: parent.width
        anchors.margins: 10
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height/3
        contentWidth: width
        contentHeight: inputArea.contentHeight
        ScrollBar.vertical: ScrollBar {
           width:(parent.contentHeight >= parent.height)?10:0
           height:parent.height
           anchors.right: parent.right // adjust the anchor as suggested by derM
           policy: ScrollBar.AlwaysOn
       }
        TextArea {
            id: inputArea
            wrapMode: Text.WrapAnywhere
            padding: 20
//            placeholderText: "Input Anything."

            focus:true
            selectByMouse:true
            selectByKeyboard:true
            font.pixelSize: 14
            background: Rectangle {
                radius: 6
                color: "white"
                border.width : 1
                border.color: "green"
            }
            y:20
//            color:"green"
//            Material.containerStyle:Material.Filled
//            Material.accent: Material.Teal
//            Material.background: Material.Teal
//            Material.foreground :Material.Teal
//            Material.primary: Material.Teal

        }

    }

    Text{
        id:indictor
        text:"Translated"
        anchors.left: inputScroll.left
        anchors.top:inputScroll.bottom
        font.bold: true
        color:"green"
        anchors.topMargin: 30

    }

    ScrollView {
        id: resultScroll
        width: parent.width
        anchors.left: inputScroll.left
        anchors.right: inputScroll.right
        anchors.top:indictor.bottom
        anchors.topMargin: 5
        anchors.bottom: langSelector.top
        anchors.bottomMargin: 10
        contentWidth: width
        contentHeight: result.implicitHeight
        ScrollBar.vertical: ScrollBar {
           width:(parent.contentHeight >= parent.height)?10:0
           height:parent.height
           anchors.right: parent.right // adjust the anchor as suggested by derM
           policy: ScrollBar.AlwaysOn
       }
        TextArea {
            id: result
            wrapMode: Text.WrapAnywhere
            padding: 10
            y:20
            background: Rectangle {
            }
            color:"green"
            font.pixelSize: 14
            selectByMouse:true
            selectByKeyboard:true
            onTextChanged: {
                resultScroll.ScrollBar.vertical.position = result.contentHeight
            }
            readOnly: true
        }
    }


    Button{
        id:transBtn
        anchors.bottom: parent.bottom
        anchors.right:parent.right
        anchors.margins:10
        text:(Qt.platform.os == "macos" || Qt.platform.os == "osx")?"Translate ⌘R":"Translate ^R"
        enabled:inputArea.length > 0
        onClicked: {
            api.sendMessage(inputArea.text)
        }
        height:50

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
//            if(responseError != ""){
//                result.text = responseError + ":\n" + result.text
//            }
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
        }
    }
    Connections{
        target: setting
        function onApiKeyChanged(){
            console.log( setting.apiKey)
            api.apiKey = setting.apiKey
        }
        function onModelChanged(){
            api.model = setting.model
        }
    }
}
