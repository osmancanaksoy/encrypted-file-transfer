#include <iostream>

#include "database.h"
#include "logger.h"

using namespace std;

Database::Database(QObject *parent) : QObject(parent)
{
    mydb = QSqlDatabase::addDatabase("QSQLITE");
    mydb.setDatabaseName("database.db");
    if(!mydb.open()) {
        qCritical() << "Could not connect to database.";
        cout << "Could not connect to database." << endl;
    }
    else {
        qInfo() << "Connected to the database.";
        cout << "Connected to the database." << endl;
    }

//    QSqlQuery query(mydb);
//    query.exec("create table users(id integer primary key, email text, password text)");
}

void Database::get_login_values(QString email, QString password)
{
    QSqlQuery query(mydb);
    query.prepare("select * from users where email = :email and password = :password");
    query.bindValue(":email", email);
    query.bindValue(":password", QCryptographicHash::hash(password.toLocal8Bit(), QCryptographicHash::Sha256).toHex());
    query.exec();


    if(query.next()) {
        qInfo() << "Login to the system is successful.";
        cout << "Login to the system is successful." << endl;
        emit pushQueryStatus(true);
        emit pushLogInStatus(true);
    }
    else {
        qCritical() << "Login to the system failed.";
        cout << "Login to the system failed." << endl;
        emit pushQueryStatus(false);
    }
}

void Database::get_register_values(QString email, QString password)
{
    QSqlQuery query(mydb);
    query.prepare("insert into users (email, password) values(:email, :password)");
    query.bindValue(":email", email);
    query.bindValue(":password", QCryptographicHash::hash(password.toLocal8Bit(), QCryptographicHash::Sha256).toHex());

    if(query.exec()) {
        qInfo() << "Registration to the system was successful.";
        cout << "Registration to the system was successful." << endl;
        emit pushQueryStatus(true);
    }
    else {
        qCritical() << "Registration failed.";
        cout << "Registration failed." << endl;
        emit pushQueryStatus(false);
    }
}

void Database::get_logout_status()
{
    qInfo() << "The system has been logged out.";
    cout << "The system has been logged out." << endl;
    emit pushLogOutStatus(true);
}
