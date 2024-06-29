#include "ecc.h"

#include <QUrl>
#include <QCryptographicHash>
#include <QFile>
#include <QTextStream>
#include <QDebug>




ECC::ECC(QObject *parent) : QObject(parent)
{

    srand(time(0));
    int a = 10, b = 13;
    typedef EllipticCurve<263> ec_t;
    ec_t myEllipticCurve(a,b);
    ec_t::Point G = myEllipticCurve[0];

    // Generate base point G
    while (G.y() == 0 || G.x() == 0 || G.Order() < 2) {
        int n = utils::irand(1, myEllipticCurve.Size());
        G = myEllipticCurve[n];
    }

    // Generate Alice's keys
    m_privateKey = generatePrivateKey(myEllipticCurve);
    EllipticCurve<263>::Point public_key = generatePublicKey(m_privateKey, myEllipticCurve);
    writeKeysToFile("my_public_key.txt", m_privateKey, public_key);


}

void ECC::onPushEncryptsMessage(QString plain_text_path)
{
    string plainText = readFile(plain_text_path.toStdString());
    int a = 10, b = 13;
    typedef EllipticCurve<263> ec_t;
    ec_t myEllipticCurve(a,b);
    ec_t::Point G = myEllipticCurve[0];

    // Generate base point G
    while (G.y() == 0 || G.x() == 0 || G.Order() < 2) {
        int n = utils::irand(1, myEllipticCurve.Size());
        G = myEllipticCurve[n];
    }

    QFile dosya("recieved1.txt"); // Dosya adını belirtin

    if (!dosya.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Dosya acilamadi.";
    }

    QTextStream in(&dosya);
    QString satir = in.readLine(); // Satırı oku

    dosya.close(); // Dosyayı kapat

    // Parantez içindeki değerleri almak için işlemler
    int deger1, deger2;
    QString temizSatir = satir.mid(1, satir.size() - 2); // Parantez içindeki kısmı al
    QStringList degerler = temizSatir.split(", ");

    if (degerler.size() == 2) {
        deger1 = degerler[0].toInt();
        deger2 = degerler[1].toInt();

        qDebug() << "Deger 1:" << deger1;
        qDebug() << "Deger 2:" << deger2;
    } else {
        qDebug() << "Hatali format.";
    }

    Cryptography::EllipticCurve<263>::Point otherPublicKey = myEllipticCurve.convertDBCoordinatesToPoint(deger1,deger2);

    EllipticCurve<263>::Point Pk = m_privateKey * otherPublicKey;
    string cipherText = encryptMessage(plainText, Pk);

    QString cipherText_ = QString::fromStdString(cipherText);
    QString hash = QCryptographicHash::hash(cipherText_.toLocal8Bit(), QCryptographicHash::Md5).toHex();

    writeFile("cipher_text.txt", cipherText);
    writeFile("cipher_text_hash.txt", hash.toStdString());

    emit pushCipherWithHash(cipherText_, hash);

}

void ECC::onPushDecryptsMessage(QString chiper_text_path)
{
    string chiperText = readFile(chiper_text_path.toStdString());

    int a = 10, b = 13;
    typedef EllipticCurve<263> ec_t;
    ec_t myEllipticCurve(a,b);
    ec_t::Point G = myEllipticCurve[0];

    // Generate base point G
    while (G.y() == 0 || G.x() == 0 || G.Order() < 2) {
        int n = utils::irand(1, myEllipticCurve.Size());
        G = myEllipticCurve[n];
    }
    QFile dosya("recieved1.txt"); // Dosya adını belirtin

    if (!dosya.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Dosya acilamadi.";
    }

    QTextStream in(&dosya);
    QString satir = in.readLine(); // Satırı oku

    dosya.close(); // Dosyayı kapat

    // Parantez içindeki değerleri almak için işlemler
    int deger1, deger2;
    QString temizSatir = satir.mid(1, satir.size() - 2); // Parantez içindeki kısmı al
    QStringList degerler = temizSatir.split(", ");

    if (degerler.size() == 2) {
        deger1 = degerler[0].toInt();
        deger2 = degerler[1].toInt();

        qDebug() << "Deger 1:" << deger1;
        qDebug() << "Deger 2:" << deger2;
    } else {
        qDebug() << "Hatali format.";
    }

    Cryptography::EllipticCurve<263>::Point otherPublicKey = myEllipticCurve.convertDBCoordinatesToPoint(deger1,deger2);

    EllipticCurve<263>::Point Pk = m_privateKey * otherPublicKey;
    string plainText = decryptMessage(chiperText, Pk);

    QString plainText_ = QString::fromStdString(plainText);
    writeFile("decr.txt", plainText);

    emit pushPlain(plainText_);

}

void ECC::onPushFileHash(QString file_hash_path)
{
    string file_hash = readFile(file_hash_path.toStdString());

    emit pushFileHash(QString::fromStdString(file_hash));

}

void ECC::onPushGenerateHash(QString file_path)
{
    string data = readFile(file_path.toStdString());

    QString data_ = QString::fromStdString(data);
    QString hash = QCryptographicHash::hash(data_.toLocal8Bit(), QCryptographicHash::Md5).toHex();

    emit pushGenerateHash(hash);
}

void ECC::onPushCompareHash(QString file_hash, QString gen_hash)
{
    if(file_hash == gen_hash) {
        cout << "yes" << endl;
        emit pushCompareHashStatus(true);
    }
    else {
        cout << "no" << endl;
        emit pushCompareHashStatus(false);

    }
}

void ECC::onPushSendPrivateKey(QString email)
{


    EmailAddress sender("osmanaksoy53@gmail.com", "Osman Can AKSOY");
    message.setSender(sender);

    EmailAddress to(email, "");
    message.addRecipient(to);

    message.setSubject("Private key for project");


    text.setText(QString::number(m_privateKey));


    message.addPart(&text);

    SmtpClient smtp("smtp.gmail.com", 465, SmtpClient::SslConnection);

    smtp.connectToHost();
    if (!smtp.waitForReadyConnected()) {
        qDebug() << "Failed to connect to host!";
    }

    smtp.login("osmanaksoy53@gmail.com", "upba dmid tngv dopl");
    if (!smtp.waitForAuthenticated()) {
        qDebug() << "Failed to login!";
    }

    smtp.sendMail(message);
    if (!smtp.waitForMailSent()) {
        qDebug() << "Failed to send mail!";
    }

    smtp.quit();
}
