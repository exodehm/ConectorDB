#ifndef DIALOGODATOSCONEXION_H
#define DIALOGODATOSCONEXION_H

#include <QDialog>

class QSqlDatabase;

namespace Ui {
class DialogoCredencialesConexionAdmin;
}

class DialogoCredencialesConexionAdmin : public QDialog
{
    Q_OBJECT
    struct sDatosConexion
    {
        QString hostName;
        int puerto;
        QString usuario;
        QString password;
    };

public:
    explicit DialogoCredencialesConexionAdmin(QSqlDatabase &db, QWidget *parent = nullptr);
    ~DialogoCredencialesConexionAdmin();
    void WriteSettings();
    void ReadSettings();
    sDatosConexion LeeDatosConexion();
    void DefinirBBDD(QString nombreBBDD);

public slots:
    bool ComprobarAdminRole();
    void ResetearBotonComprobar(const QString& texto);
signals:
    void EsAdmin(bool esadmin);

private:
    Ui::DialogoCredencialesConexionAdmin *ui;
    sDatosConexion m_datosConexion;
    QSqlDatabase* m_db;
};

#endif // DIALOGODATOSCONEXION_H
