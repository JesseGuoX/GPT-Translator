#ifndef UPDATER_H
#define UPDATER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QGuiApplication>
#include <QClipboard>
#include <QByteArray>
#include <QFile>
#include "stdafx.h"

class Updater : public QObject
{
    Q_OBJECT

    Q_PROPERTY_AUTO(bool,isRequesting);
    Q_PROPERTY_AUTO(QString,requestResult);
    Q_PROPERTY_AUTO(QString,updateLink);
    Q_PROPERTY_AUTO(QString,releaseNote);


public:
    explicit Updater(QObject *parent = nullptr);

    Q_INVOKABLE void check();

private:
    QNetworkAccessManager* networkManager;
    QNetworkReply* reply;



};


#endif // UPDATER_H
