/*
 * @Date: 2023-05-02 23:52:58
 * @LastEditors: JessGuo
 * @LastEditTime: 2023-05-23 23:25:44
 * @FilePath: /GPT_Translator/src/hotkey.cpp
 */
#include "hotkey.h"

#ifdef Q_OS_MAC
#include <ApplicationServices/ApplicationServices.h>
#endif

#ifdef Q_OS_WIN 
#include <windows.h>
#endif

#ifdef Q_OS_LINUX
#include <X11/Xlib.h>
#include <X11/keysym.h>
#include <unistd.h>
#endif


Hotkey::Hotkey(QObject *parent)
    : QObject{parent}
{

}

void Hotkey::binding(QObject *obj)
{
    _hotkey = new QHotkey(QKeySequence(""), true, obj); //The hotkey will be automatically registered
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

#ifdef Q_OS_WIN 
        // 为按下和释放 Ctrl+C 准备输入事件
        INPUT inputs[4] = { 0 };
        inputs[0].type = inputs[1].type = inputs[2].type = inputs[3].type = INPUT_KEYBOARD;
        inputs[0].ki.wVk = inputs[2].ki.wVk = VK_CONTROL;
        inputs[1].ki.wVk = inputs[3].ki.wVk = 'C';
        inputs[2].ki.dwFlags = inputs[3].ki.dwFlags = KEYEVENTF_KEYUP;

        // 发送输入事件
        UINT numEventsSent = SendInput(ARRAYSIZE(inputs), inputs, sizeof(INPUT));
        if (numEventsSent != ARRAYSIZE(inputs)) {
            qDebug() << "SendInput failed: " << GetLastError();
        }
#endif

#ifdef Q_OS_LINUX
        Display *display = XOpenDisplay(NULL);
        if (display == NULL) {
            qDebug()  << "Unable to open X display.";
            return;
        }

        Window root = DefaultRootWindow(display);
        KeyCode ctrl_key = XKeysymToKeycode(display, XK_Control_L);
        KeyCode c_key = XKeysymToKeycode(display, XK_c);

        XEvent event;
        memset(&event, 0, sizeof(event));
        event.xkey.type = KeyPress;
        event.xkey.root = root;
        event.xkey.window = root;
        event.xkey.same_screen = True;

        // 按下 Ctrl 键
        event.xkey.keycode = ctrl_key;
        XSendEvent(display, root, True, KeyPressMask, &event);
        XFlush(display);
        usleep(10000);

        // 按下 C 键
        event.xkey.keycode = c_key;
        XSendEvent(display, root, True, KeyPressMask, &event);
        XFlush(display);
        usleep(10000);

        // 释放 C 键
        event.xkey.type = KeyRelease;
        event.xkey.keycode = c_key;
        XSendEvent(display, root, True, KeyReleaseMask, &event);
        XFlush(display);
        usleep(10000);

        // 释放 Ctrl 键
        event.xkey.keycode = ctrl_key;
        XSendEvent(display, root, True, KeyReleaseMask, &event);
        XFlush(display);
        usleep(10000);

        XCloseDisplay(display);
#endif
            // Use a timer to wait for the copy operation to complete
            QTimer::singleShot(300,  [this] {
                QClipboard *clipboard = QGuiApplication::clipboard();
                QString copiedText = clipboard->text();
                qDebug() << "Copied text:" << copiedText;
                this->_selectedText = copiedText;
                this->selectedTextChanged();
            });

    });
}
