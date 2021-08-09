#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QSettings>
#include <QtSql/QSqlDatabase>

QT_BEGIN_NAMESPACE
namespace Ui { class Widget; }
QT_END_NAMESPACE

class DialogoDatosConexion;

class Widget : public QWidget
{
    Q_OBJECT

public:

    Widget(QWidget *parent = nullptr);
    ~Widget();

    void readSettings();
    void writeSettings();


    enum eDatosConexion{BBDD, NOMBRE, HOST, PUERTO, PASSWD};

public slots:
    void Configurar();
    void ConfigurarYConectar();

private:
    Ui::Widget *ui;
    QString m_nombre;
    QString m_host;
    QString m_puerto;
    QString m_basededatos;
    QString m_password;
    QSqlDatabase m_db;
    DialogoDatosConexion *m_d;
    quint8 m_tiempoMaximoIntentoConexion;
};
#endif // WIDGET_H
