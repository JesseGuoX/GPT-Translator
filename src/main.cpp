/*
 * @Date: 2023-04-06 20:58:59
 * @LastEditors: JessGuo
 * @LastEditTime: 2023-04-12 13:12:19
 * @FilePath: /GPT_Translator/src/main.cpp
 */
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QLocale>
#include <QTranslator>

#include "controller.h"
#include "updater.h"
#include <QIcon>

#include <QHotkey>
#include <QKeyEvent>
#include <QTimer>

#include <QShortcut>

#include <QProcess>

#ifdef Q_OS_MAC
#include <ApplicationServices/ApplicationServices.h>
#endif


int main(int argc, char *argv[])
{

    #ifdef Q_OS_WIN
       qDebug() << "Current OS: Windows";
    #endif

    #ifdef Q_OS_MAC
       qDebug() << "Current OS: macOS";
    #endif

    #ifdef Q_OS_LINUX
       qDebug() << "Current OS: Linux";
    #endif

    #ifdef Q_OS_LINUX
        qputenv("QT_QUICK_BACKEND","software");//Failed to build graphics pipeline state under linux, need to be software
    #endif

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon("qrc:///res/logo/logo.ico"));

    QHotkey hotkey(QKeySequence("F1"), true, &app); //The hotkey will be automatically registered
    qDebug() << "Is segistered:" << hotkey.isRegistered();


    QObject::connect(&hotkey, &QHotkey::activated, qApp, [&](){
        qDebug() << "Hotkey Activated ";

#ifdef Q_OS_MAC
            CGEventRef push = CGEventCreateKeyboardEvent(NULL, 0x08, true);//0x08=='c'
            CGEventSetFlags(push, kCGEventFlagMaskCommand);
            CGEventPost(kCGHIDEventTap, push);

            push = CGEventCreateKeyboardEvent(NULL, 0x08, false);//0x08=='c'
            CGEventSetFlags(push, kCGEventFlagMaskCommand);
            CGEventPost(kCGHIDEventTap, push);
#endif
            // Use a timer to wait for the copy operation to complete
            QTimer::singleShot(300,  [] {
                QClipboard *clipboard = QGuiApplication::clipboard();
                QString copiedText = clipboard->text();
                qDebug() << "Copied text:" << copiedText;

            });

    });

    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "GPT_Translator_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            app.installTranslator(&translator);
            break;
        }
    }

    #ifdef APP_VERSION
    app.setApplicationVersion(APP_VERSION);
    #else
    app.setApplicationVersion("NOT FOUND");
    #endif

    Setting * setting = new Setting();


    qmlRegisterType<Controller>("Controller",1,0,"APIController");
    qmlRegisterType<Updater>("Updater",1,0,"APIUpdater");


    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:///qml/main.qml"_qs);
    engine.rootContext()->setContextProperty("setting", setting);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
