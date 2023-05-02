#ifndef HOTKEY_H
#define HOTKEY_H

#include <QObject>

#include "stdafx.h"

#include <QHotkey>
#include <QKeyEvent>
#include <QTimer>
#include <QGuiApplication>
#include <QClipboard>

#ifdef Q_OS_MAC
#include <ApplicationServices/ApplicationServices.h>
#endif

class Hotkey : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,selectedText);
    Q_PROPERTY_AUTO(QPoint,mousePos);

public:
    explicit Hotkey(QObject *parent = nullptr);

    Q_INVOKABLE void binding(QObject * obj);

private:
    QHotkey *_hotkey;
signals:

};

#endif // HOTKEY_H
