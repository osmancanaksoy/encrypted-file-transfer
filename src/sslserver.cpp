#include <iostream>
#include <QSslSocket>
#include <QFile>
#include <QUrl>
#include <fstream>

#include "sslserver.h"
#include "logger.h"

using namespace std;

SslServer::SslServer(QObject *parent) : QTcpServer(parent)
{
    connect(this, &SslServer::newConnection, this, &SslServer::link);
}

void SslServer::incomingConnection(qintptr socketDescriptor)
{
    QSslSocket *sslSocket = new QSslSocket(this);

    connect(sslSocket, SIGNAL(sslErrors(QList<QSslError>)), this, SLOT(sslErrors(QList<QSslError>)));
    sslSocket->setSocketDescriptor(socketDescriptor);
    sslSocket->setLocalCertificate(cert);
    sslSocket->setPrivateKey(key);
    sslSocket->setProtocol(QSsl::TlsV1SslV3);

    sslSocket->startServerEncryption();

    addPendingConnection(sslSocket);
}

void SslServer::sslErrors(const QList<QSslError> &errors)
{
    foreach (const QSslError &error, errors)
        qCritical() << error.errorString();
}

void SslServer::link()
{
    QTcpSocket *clientSocket;

    clientSocket = nextPendingConnection();
    emit pushServerStatus("SERVER: Client connected.");
    connect(clientSocket, &QTcpSocket::readyRead, this, &SslServer::rx);
    connect(clientSocket, &QTcpSocket::disconnected, this, &SslServer::disconnected);
}

void SslServer::rx()
{
    file_counter++;
    QTcpSocket* clientSocket = qobject_cast<QTcpSocket*>(sender());
    QString message = clientSocket->readAll();
    qDebug() << message;

    ofstream myfile;
    myfile.open ("recieved" + std::to_string(file_counter) + ".txt");
    myfile << message.toStdString();
    myfile.close();
    emit pushInComingFileStatus();
    qDebug() << "File received!";


    QFile file("my_public_key.txt");
    file.open(QIODevice::ReadOnly);
    QByteArray data = file.readAll();
    clientSocket->write(data);
    clientSocket->waitForBytesWritten(1000);
    file.close();
    qInfo() << "SERVER: Public Key Sent.";
    cout << "SERVER: Public Key Sent." << endl;
    emit pushServerStatus("SERVER: Client connected.");
}

void SslServer::disconnected()
{
    qDebug("SERVER: Client Disconnected");
    emit pushServerStatus("SERVER: Client Disconnected");
    QTcpSocket* clientSocket = qobject_cast<QTcpSocket*>(sender());
    clientSocket->deleteLater();
}

void SslServer::setLocalKey(QString localKey)
{
    QFile keyFile(localKey);
    keyFile.open(QIODevice::ReadOnly);
    key = QSslKey(keyFile.readAll(), QSsl::Rsa);
    keyFile.close();
    qDebug("Server Key has been set.");
}

void SslServer::setLocalCertificate(QString localCertificate)
{
    QFile certFile(localCertificate);
    certFile.open(QIODevice::ReadOnly);
    cert = QSslCertificate(certFile.readAll());
    certFile.close();
    qDebug("Server Certificate has been set.");
}

void SslServer::onPushStartServer(QString port)
{
    if (!listen(QHostAddress(QHostAddress::Any), port.toUInt())) { // FQDN in red_local.pem is set to 127.0.0.1.  If you change this, it will not authenticate.
        qCritical() << "SERVER: Unable to start the TCP server";
        emit pushServerStatus("SERVER: Unable to start the TCP server");
    }
    else {
        qDebug() << "SERVER: Listening: " + port;
        emit pushServerStatus("SERVER: Listening: " + port);
    }
}

void SslServer::onPushStopServer()
{
    if(isListening()) {
        close();
        qDebug() << "SERVER: Server is closing";
        emit pushServerStatus("SERVER: Server is closing");
    }
}

void SslServer::setFileCounter()
{
    file_counter = 1;
}
