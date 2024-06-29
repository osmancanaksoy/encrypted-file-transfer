#include <iostream>
#include <QSslKey>
#include <QSslCertificate>
#include <QSslConfiguration>
#include <QFile>
#include <QUrl>
#include <fstream>

#include "client.h"
#include "logger.h"

using namespace std;

Client::Client(QObject *parent) : QObject(parent)
{
    connect(&server, &QSslSocket::readyRead, this, &Client::rx);
    connect(&server, &QSslSocket::disconnected, this, &Client::serverDisconnect);
    connect(&server, SIGNAL(sslErrors(QList<QSslError>)), this, SLOT(sslErrors(QList<QSslError>)));
}

void Client::connectToServer(QString ip, QString port)
{
    server.connectToHostEncrypted(ip, port.toUInt());
    if (server.waitForEncrypted(5000)) {
        qInfo() << "Authentication Suceeded";
        cout << "CLIENT: Authentication Suceeded" << endl;
        emit pushClientStatus("CLIENT: Authentication Suceeded");
    }
    else {
        qCritical("Unable to connect to server");
        cout << "CLIENT: Unable to connect to server" << endl;
        emit pushClientStatus("CLIENT: Unable to connect to server");
    }
}

void Client::sslErrors(const QList<QSslError> &errors)
{
    foreach (const QSslError &error, errors) {
        qCritical() << error.errorString();
        cout << "CLIENT: " << error.errorString().toStdString() << endl;
    }
}

void Client::serverDisconnect(void)
{
    qWarning("Server disconnected");
    cout << "CLIENT: Server disconnected" << endl;
    emit pushClientStatus("CLIENT: Server disconnected");
}

void Client::addCaCertficate(QString caCertficate)
{
    QFile certFile(caCertficate);
    certFile.open(QIODevice::ReadOnly);
    cert = QSslCertificate(certFile.readAll());
    certFile.close();

    QSslConfiguration conf;
    conf.addCaCertificate(cert);
    server.setSslConfiguration(conf);
    qDebug("Client Ca Certificate has been set.");
}

void Client::onPushServerConnect(QString ip, QString port)
{
    connectToServer(ip, port);
}

void Client::onPushServerDisconnect()
{
    server.disconnectFromHost();
}

void Client::onPushSendFile()
{
    QFile file("cipher_text.txt");
    file.open(QIODevice::ReadOnly);
    QByteArray data = file.readAll();
    server.write(data);
    server.waitForBytesWritten(1000);

    file.close();
    qInfo() << "File sent!";
    cout << "CLIENT: File sent!" << endl;
    emit pushSentFileStatus();
}

void Client::onPushSendHashFile()
{
    QFile file("chiper_text_hash.txt");
    file.open(QIODevice::ReadOnly);
    QByteArray data = file.readAll();
    server.write(data);
    server.waitForBytesWritten(1000);

    file.close();
    qInfo() << "Hash File sent!";
    cout << "CLIENT: Hash File sent!" << endl;
    emit pushSentFileStatus();
}

void Client::onPushSendPublicKey()
{
    QFile file("my_public_key.txt");
    file.open(QIODevice::ReadOnly);
    QByteArray data = file.readAll();
    server.write(data);
    server.waitForBytesWritten(1000);

    file.close();
    qInfo() << "Public Key sent!";
    cout << "CLIENT: Public Key sent!" << endl;
    emit pushSentFileStatus();
}

void Client::rx(void)
{
    file_counter++;
    QString message = server.readAll();
    qDebug() << message;

    ofstream myfile;
    myfile.open ("recieved" + std::to_string(file_counter) + ".txt");
    myfile << message.toStdString();
    myfile.close();
    qDebug() << "CLIENT: File received!";
    cout << "CLIENT: " << message.toStdString() << endl;
    emit pushInComingFileStatus();
}
