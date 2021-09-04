#ifndef DIALOGOCONFIGURACION_H
#define DIALOGOCONFIGURACION_H

#include <QDialog>
#include <QtSql/QSqlQuery>
#include <QFile>

namespace Ui {
    class DialogoConfiguracion;
}

class DialogoCredencialesConexionAdmin;

class DialogoConfiguracion : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoConfiguracion(QWidget *parent = nullptr);
    ~DialogoConfiguracion();
    void ReadSettings();
    void WriteSettings();
    bool HayPython();
    //bool IsPostgresRunning();
    void ComprobacionesPython();
    void ComprobarDatosAdminRole(QSqlDatabase db);
    void ComprobarRoleSdmed(QSqlQuery consulta);
    void ComprobarExistenciaBBDDSdmed(QSqlQuery consulta);
    void ComprobarExtensionSuministrada();
    void ComprobarExtensionInstalada(QSqlQuery consulta);
    void CopiarConPermisos(const QString &fichero_origen, const QString &fichero_destino, QString passw = "");
    void ActivarLetreros(bool esadmin);

public slots:
    void ComprobacionesPostgres();
    void DefinirRutaScripts();
    void ActivarBotonInstalarExtension();
    void InstalarExtension();
    void InstalarScriptsPython();
    void DatosAdmin();
    void Salir();

private:
    Ui::DialogoConfiguracion *ui;
    QString m_versionPython;
    QString m_rutaPython;
    QString m_rutaExtensiones;
    QString m_postgres;
    QString m_directorioExtension;
    bool m_instalarExtension;


    QSqlDatabase m_dbAdmin;
    bool m_esDBAdmin;
    DialogoCredencialesConexionAdmin* m_dialogoConfiguracionAdmin;
};

#endif // DIALOGOCONFIGURACION_H
