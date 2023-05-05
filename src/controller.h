/*
 * @Date: 2023-04-07 15:38:00
 * @LastEditors: JessGuo
 * @LastEditTime: 2023-05-04 23:49:11
 * @FilePath: /GPT_Translator/src/controller.h
 */
#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
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

#include <QStandardPaths>
#include <QTextStream>
#include <QDebug>
#include <QDir>

class Setting : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,apiServer);
    Q_PROPERTY_AUTO(QString,apiKey);
    Q_PROPERTY_AUTO(QString,model);
    Q_PROPERTY_AUTO(QString,shortCut);
public:
    explicit Setting(QObject *parent = nullptr);
    Q_INVOKABLE bool loadConfig();
    Q_INVOKABLE void updateConfig();

private:
    QString _configPath;
};

class Controller : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString,responseData);
    Q_PROPERTY_AUTO(QString,responseError);
    Q_PROPERTY_AUTO(QString,transToLang);
    Q_PROPERTY_AUTO(bool,isRequesting);
    Q_PROPERTY_AUTO(QString,apiServer);
    Q_PROPERTY_AUTO(QString,apiKey);
    Q_PROPERTY_AUTO(QString,model);


public:
    explicit Controller(QObject *parent = nullptr);

    Q_INVOKABLE void sendMessage(QString str, int mode);
    Q_INVOKABLE void abort();

signals:

private slots:
    void streamReceived();
private:
    QNetworkAccessManager* networkManager;
    QNetworkReply* reply;
    QJsonObject createMessage(const QString& role,const QString& content);
    QString _data;
    std::tuple<QString, bool> _getContent(QString &str);
    std::tuple<QString, bool> _parseResponse(QByteArray &ba);

    QString _getError(QString &str);


};

#endif // CONTROLLER_H
