import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Controller
import QtTextToSpeech

import QtQuick.Controls.Material
Item {

    signal settingClicked;
    function startTrans(){
        if(inputArea.length > 0)
            transBtn.clicked()
    }

    function getMode(){
        if(transRadio.checked){
            return 0
        }
        if(grammerRadio.checked){
            return 1
        }
    }

    function speekDisplay(){
        if(getMode() == 0){
            if((result.text.length > 0) && (langSelector.currentText === "English")){
                return true
            }
        }else{
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
        RowLayout {
            RadioButton {
                id:transRadio
                checked: true
                text: qsTr("Translation")
                onCheckedChanged: {
                    if(checked){
                        indictor.text = "Translated"
                        transBtn.text = (Qt.platform.os == "macos" || Qt.platform.os == "osx")?"Translate ⌘R":"Translate ^R"
                        langSelector.visible = true
                    }
                    result.text = ""
                }
            }
            RadioButton {
                id:grammerRadio
                text: qsTr("Grammar")
                onCheckedChanged: {
                    if(checked){
                        indictor.text = "Grammar fixed"
                        transBtn.text = (Qt.platform.os == "macos" || Qt.platform.os == "osx")?"Fix ⌘R":"Fix ^R"
                        langSelector.visible = false
                    }
                    result.text = ""
                }
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
            width: 20
            height:20
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

    IconButton{
        id:speakerBtn
        width: 18
        height:18
        anchors.verticalCenter: indictor.verticalCenter
        anchors.right: inputScroll.right
        normalUrl:"qrc:///res/speaker.svg"
        hoveredUrl:"qrc:///res/speaker.svg"
        pressedUrl:"qrc:///res/speaker.svg"
        visible:speekDisplay()
        onClicked: {
            tts.say(result.text)
        }
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
        font.capitalization: Font.MixedCase
        enabled:inputArea.length > 0
        onClicked: {
            api.sendMessage(inputArea.text, grammerRadio.checked?1:0)
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
