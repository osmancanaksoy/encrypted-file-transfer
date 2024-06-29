#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtSql>
#include <QDebug>
#include <QQmlContext>

#include "database.h"
#include "sslserver.h"
#include "client.h"
#include "ecc.h"
#include "logger.h"



int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    Logger::init();

    QGuiApplication app(argc, argv);
    app.setOrganizationName("somename");
    app.setOrganizationDomain("somename");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);


    Database database;
    engine.rootContext()->setContextProperty("database", &database);

    SslServer server;
    engine.rootContext()->setContextProperty("server", &server);

    Client client;
    engine.rootContext()->setContextProperty("client", &client);

    ECC ecc;
    engine.rootContext()->setContextProperty("ecc", &ecc);

    engine.load(url);

    //Logger::clean();

    return app.exec();
}
