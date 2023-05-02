#include "hotkey.h"

Hotkey::Hotkey(QObject *parent)
    : QObject{parent}
{

}

void Hotkey::binding(QObject *obj)
{
    _hotkey = new QHotkey(QKeySequence("F2"), true, obj); //The hotkey will be automatically registered
    qDebug() << "Is segistered:" << _hotkey->isRegistered();


    QObject::connect(_hotkey, &QHotkey::activated, obj, [&,this](){
        qDebug() << "Hotkey Activated ";

#ifdef Q_OS_MAC
            CGEventRef push = CGEventCreateKeyboardEvent(NULL, 0x08, true);//0x08=='c'
            CGEventSetFlags(push, kCGEventFlagMaskCommand);
            CGEventPost(kCGHIDEventTap, push);

            push = CGEventCreateKeyboardEvent(NULL, 0x08, false);//0x08=='c'
            CGEventSetFlags(push, kCGEventFlagMaskCommand);
            CGEventPost(kCGHIDEventTap, push);

            CGPoint mouseLocation;
            mouseLocation = CGEventGetLocation(CGEventCreate(NULL));
            qDebug() << "x:" << mouseLocation.x;
            qDebug() << "y:" << mouseLocation.y;
            _mousePos.setX(mouseLocation.x);
            _mousePos.setY(mouseLocation.y);

#endif
            // Use a timer to wait for the copy operation to complete
            QTimer::singleShot(200,  [this] {
                QClipboard *clipboard = QGuiApplication::clipboard();
                QString copiedText = clipboard->text();
                qDebug() << "Copied text:" << copiedText;
                this->_selectedText = copiedText;
                this->selectedTextChanged();
            });

    });
}
