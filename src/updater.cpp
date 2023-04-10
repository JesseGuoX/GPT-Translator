#include "updater.h"

Updater::Updater(QObject *parent)
    : QObject{parent}
{
    networkManager = new QNetworkAccessManager(this);
}

#define VERSION "1.2.0"

void Updater::check()
{
    isRequesting(true);
    requestResult("");
    updateLink("");
    releaseNote("");
    QUrl apiUrl("https://api.github.com/repos/JesseGuoX/GPT-Translator/releases/latest");
    QNetworkRequest request(apiUrl);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::AlwaysNetwork); // Events shouldn't be cached
    reply = networkManager->get(request);
    connect(reply, &QNetworkReply::finished,this, [=]() {
        QByteArray response = reply->readAll();
        qDebug() << response;
        QString tag = "not found";
        QString link = "";
        QString note = "";
        if (reply->error() == QNetworkReply::NoError) {
            QJsonDocument doc = QJsonDocument::fromJson(response);
            if (!doc.isNull()) {
                if (doc.isObject()) {
                    tag = doc.object().value("tag_name").toString();
                    link = doc.object().value("assets").toArray().at(0).toObject().value("browser_download_url").toString();
                    note = doc.object().value("body").toString();
                }
            }
            if(tag.length() == 0 || link.length() == 0){
                tag = "出现错误,请前往项目主页查看";
                link = "https://github.com/JesseGuoX/GPT-Translator";
            }
            requestResult(tag);
            updateLink(link);
            releaseNote(note);
        } else {
            requestResult("出现错误,请前往项目主页查看");
            updateLink("https://github.com/JesseGuoX/GPT-Translator");
        }
        reply->deleteLater();
        isRequesting(false);
    });
}


