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


int main(int argc, char *argv[])
{
    QString type = QSysInfo::productType();
    // if(type == "linux"){
        qputenv("QT_QUICK_BACKEND","software");//Failed to build graphics pipeline state under linux, need to be software
    // }

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon("qrc:///res/logo/logo.ico"));

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
