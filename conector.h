#ifndef CONECTOR_H
#define CONECTOR_H

#include <QWidget>
#include <QSettings>
#include <QtSql/QSqlDatabase>

QT_BEGIN_NAMESPACE
namespace Ui { class Conector; }
QT_END_NAMESPACE

class DialogoDatosConexion;

class Conector : public QWidget
{
    Q_OBJECT

public:

    Conector(QWidget *parent = nullptr);
    ~Conector();

    void readSettings();
    void writeSettings();


    enum eDatosConexion{BBDD, NOMBRE, HOST, PUERTO, PASSWD};

public slots:
    void Configurar();
    void Conectar();

private:
    Ui::Conector *ui;
    QString m_nombre;
    QString m_host;
    QString m_puerto;
    QString m_basededatos;
    QString m_password;
    QSqlDatabase m_db;
    DialogoDatosConexion *m_d;
    quint8 m_tiempoMaximoIntentoConexion;
};
#endif // CONECTOR_H
