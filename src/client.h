#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QSslSocket>
#include <QSslCertificate>

class Client : public QObject
{
    Q_OBJECT
public:
    explicit Client(QObject *parent = nullptr);

private:
    QSslSocket server;
    void connectToServer(QString ip, QString port);
    int file_counter = 0;
    QSslCertificate cert;

Q_SIGNALS:
    void disconnected(void);

private slots:
    void sslErrors(const QList<QSslError> &errors);
    void rx(void);
    void serverDisconnect(void);

public slots:
    void addCaCertficate(QString caCertficate);
    void onPushServerConnect(QString ip, QString port);
    void onPushServerDisconnect();
    void onPushSendFile();
    void onPushSendHashFile();
    void onPushSendPublicKey();


signals:
    void pushClientStatus(QString status);
    void pushInComingFileStatus();
    void pushSentFileStatus();
};

#endif // CLIENT_H
