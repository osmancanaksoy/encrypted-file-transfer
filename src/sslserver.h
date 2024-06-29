#ifndef SSLSERVER_H
#define SSLSERVER_H

#include <QObject>
#include <QTcpServer>
#include <QSslKey>
#include <QSslCertificate>

class SslServer : public QTcpServer
{
    Q_OBJECT
public:
    explicit SslServer(QObject *parent = nullptr);

private:
    QSslKey key;
    QSslCertificate cert;
    int file_counter = 0;

private slots:
    void sslErrors(const QList<QSslError> &errors);
    void link();
    void rx();
    void disconnected();

public slots:
    //Front-End Slots
    void setLocalKey(QString localKey);
    void setLocalCertificate(QString localCertificate);
    void onPushStartServer(QString port);
    void onPushStopServer();
    void setFileCounter();

protected:
    void incomingConnection(qintptr socketDescriptor);

signals:
    void pushServerStatus(QString status);
    void pushInComingFileStatus();

};

#endif // SSLSERVER_H
