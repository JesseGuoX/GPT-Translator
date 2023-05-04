import QtQuick
import QtQuick.Controls
import Updater
import Controller

Item {
    signal backClicked;

    function reload(){
        setting.loadConfig()
        keyInput.text = setting.apiKey
        serverInput.text = setting.apiServer
        shortcutText.text = setting.shortCut
        if(setting.model == "gpt-3.5-turbo")
            modelSelector.currentIndex = 0
        else if(setting.model == "gpt-4")
            modelSelector.currentIndex = 1
        
        saveBtn.visible = false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            shortcutRect.focus = false;
            if(shortcutText.text.length > 0){
                console.log("setshorcut:" + shortcutText.text)
                hotkey.setShortcut(shortcutText.text)
            }
        }
    }




    Item{
        id:header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.margins: 15
        height:30


        IconButton{
            width: 20
            height:20
            anchors.left: parent.left
            anchors.top: parent.top
            normalUrl:"qrc:///res/back1.png"
            hoveredUrl:"qrc:///res/back1.png"
            pressedUrl:"qrc:///res/back2.png"
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
            normalUrl:"qrc:///res/save1.png"
            hoveredUrl:"qrc:///res/save1.png"
            pressedUrl:"qrc:///res/save2.png"
            onClicked: {
                setting.apiServer = serverInput.text.trim()
                setting.apiKey = keyInput.text
                setting.shortCut = shortcutText.text
                if(modelSelector.currentIndex == 0)
                    setting.model = "gpt-3.5-turbo"
                else
                    setting.model = "gpt-4"
                setting.updateConfig()
                visible = false
            }
            onVisibleChanged: {
                if(visible){
                    saveBtn.clicked()
                }
            }
        }

    }
    Text{
        id:serverText
        anchors.left: header.left
        anchors.top:header.bottom
        anchors.topMargin: 10
        text:"API Server"
        font.bold: true
        color:"green"
    }

    Item {
        id:serverItem
        anchors.left: header.left
        anchors.right: header.right
        anchors.top:serverText.bottom
        anchors.topMargin: 10
        height:30
        Rectangle {
            color: "#E6E7E7"
            anchors.fill: parent
            radius: 5
        }

        TextInput {
            id:serverInput
            anchors.fill: parent
            padding:7
            text: "https://api.openai.com"
            onTextChanged: {
                saveBtn.visible = true
            }
        }
    }

    Text{
        id:apiText
        anchors.left: header.left
        anchors.top:serverItem.bottom
        anchors.topMargin: 20
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
        contentHeight: keyInput.contentHeight + 20
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
            y:20
            wrapMode: Text.WrapAnywhere
            onTextChanged:{
               saveBtn.visible = true
            }
            background: Rectangle{
                color: "#E6E7E7"
                radius: 5

            }

        }
    }

    Text{
        id:modelText
        anchors.left: header.left
        anchors.top:keyInputScroll.bottom
        anchors.topMargin: 20
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

    Text{
        id:shortCutText
        anchors.left: header.left
        anchors.top:modelSelector.bottom
        anchors.topMargin: 20
        text:"Shortcut"
        font.bold: true
        color:"green"
    }

    Item {
        id:shortcutItem
        anchors.left: header.left
        anchors.top:shortCutText.bottom
        anchors.topMargin: 10
        width:100
        height:30
        Rectangle {
            id:shortcutRect
            color: "#E6E7E7"
            anchors.fill: parent
            radius: 5
            border.width:1
            border.color: color
            onActiveFocusChanged: {
                console.log("afocus")
            }

            onFocusChanged: {
                if(focus){
                    border.color = "green"
                    shortcutRect.forceActiveFocus()
                }else{
                    border.color = color
                }
                console.log("foucu")
            }

            Text{
                id:shortcutText
                anchors.centerIn: parent
                text:""
                onTextChanged: {
                    saveBtn.visible = true
                }
            }

            Keys.onPressed:(event)=> {
                if(!shortcutRect.focus){
                    return
                }

                shortcutText.text = ""



                if(Qt.platform.os === "macos" || Qt.platform.os === "osx"){
                   if (event.modifiers & Qt.ControlModifier) {
                       shortcutText.text = "Ctrl+"
                   }
                   if (event.modifiers & Qt.MetaModifier) {
                       shortcutText.text = "Meta+"
                   }
                }else{
                   if (event.modifiers & Qt.ControlModifier) {
                       shortcutText.text = "Ctrl+"
                   }
                }

                if (event.modifiers & Qt.AltModifier) {
                   shortcutText.text = "Alt+"
                }

                if(shortCutText.text.length > 0){
                    switch(event.key){
                        case Qt.Key_F1: shortcutText.text = "F1"; break;
                        case Qt.Key_F2: shortcutText.text = "F2"; break;
                        case Qt.Key_F3: shortcutText.text = "F3"; break;
                        case Qt.Key_F4: shortcutText.text = "F4"; break;
                        case Qt.Key_F5: shortcutText.text = "F5"; break;
                        case Qt.Key_F6: shortcutText.text = "F6"; break;
                        case Qt.Key_F7: shortcutText.text = "F7"; break;
                        case Qt.Key_F8: shortcutText.text = "F8"; break;
                        case Qt.Key_F9: shortcutText.text = "F9"; break;
                        case Qt.Key_F10: shortcutText.text = "F10"; break;
                        case Qt.Key_F11: shortcutText.text = "F11"; break;
                        case Qt.Key_F12: shortcutText.text = "F12"; break;
                    }
                }
            }

        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                shortcutRect.focus = true
            }
        }



    }


    Text{
        id:about
        anchors.left: header.left
        anchors.top:shortcutItem.bottom
        anchors.topMargin: 20
        text:"About"
        font.bold: true
        color:"green"
    }


    Column{
        spacing:10
        anchors.top:about.bottom
        anchors.topMargin: 15
        anchors.left: header.left
        anchors.right: header.right
        Image{
            id:icon
            anchors.horizontalCenter: parent.horizontalCenter
            source:"qrc:///res/logo/logo.ico"
            height:40
            width:40
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    Qt.openUrlExternally("https://github.com/JesseGuoX/GPT-Translator")
                }
            }
        }

        Text{
            id:version
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 15
            text:"Current version:" +  Qt.application.version
            font.bold: true
            font.pixelSize: 12
            color:"green"
        }
        Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            height:checkBtn.height
            width:parent.width
            Button{
                id:checkBtn
                text:"check update"
                font.capitalization: Font.MixedCase
                height: 40
                anchors.horizontalCenter: parent.horizontalCenter
                Material.background: Material.Green
                Material.foreground :(Qt.platform.os === "linux")?"black":"white" //linux can't display button use software render
                onClicked: {
                    updater.check()
                }
            }
            BusyIndicator {
                anchors.verticalCenter: checkBtn.verticalCenter
                anchors.left:checkBtn.right
                anchors.leftMargin: 10
                running: updater.isRequesting
                visible:updater.isRequesting
                width:checkBtn.height - 10
                height:width
            }
        }


        Text{
            id:linkText
            anchors.horizontalCenter: parent.horizontalCenter

            visible:!updater.isRequesting
            text: "<u><a href='" + "https://www.google.com" + "'>" + updater.requestResult + "</a></u>"
            onLinkActivated: Qt.openUrlExternally(updater.updateLink)
        }
        TextArea{
            width:parent.width
            visible:!updater.isRequesting
            text:updater.releaseNote
            readOnly: true
            wrapMode: Text.WrapAnywhere
            y:30
            background: Rectangle {
            }
        }
    }



    APIUpdater{
        id:updater
        onIsRequestingChanged: {
            if(isRequesting){
                checkBtn.enabled = false
            }else{
                checkBtn.enabled = true
                if(updater.updateLink.length > 0){
                    linkText.text = "<u><a  href='" + updater.updateLink + "'>" + updater.requestResult + "</a></u>"
                }else{
                    linkText.text = requestResult
                }


            }
        }
    }

}
