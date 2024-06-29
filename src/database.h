#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QtSql>
#include <QCryptographicHash>

class Database : public QObject
{
    Q_OBJECT
public:
    explicit Database(QObject *parent = nullptr);
public slots:
    void get_login_values(QString email, QString password);
    void get_register_values(QString email, QString password);
    void get_logout_status();

signals:
    void pushQueryStatus(bool status);
    void pushLogInStatus(bool status);
    void pushLogOutStatus(bool status);

private:
    QSqlDatabase mydb;

};

#endif // DATABASE_H
