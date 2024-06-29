#ifndef ECC_H
#define ECC_H

#include <QObject>

#include <cstdlib>
#include <iostream>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <ostream>
using namespace std;

#include <math.h>
#include "FiniteFieldElement.hpp"
#include "EllipticCurve.hpp"
#include "smtp/smtpmime.h"
using namespace Cryptography;
using namespace utils;
using namespace operations;

class ECC : public QObject
{
    Q_OBJECT
public:
    explicit ECC(QObject *parent = nullptr);
    void encryptsMessage();

public slots:
    void onPushEncryptsMessage(QString plain_text_path);
    void onPushDecryptsMessage(QString chiper_text_path);

    void onPushFileHash(QString file_hash_path);
    void onPushGenerateHash(QString file_path);
    void onPushCompareHash(QString file_hash, QString gen_hash);
    void onPushSendPrivateKey(QString email);

private:
    int m_privateKey;

    MimeMessage message;
    MimeText text;

signals:
    void pushCipherWithHash(QString chiper, QString hash);
    void pushFileHash(QString file_hash);
    void pushGenerateHash(QString gen_hash);
    void pushCompareHashStatus(bool status);
    void pushPlain(QString plain);


};

#endif // ECC_H
