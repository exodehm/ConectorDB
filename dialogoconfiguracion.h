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
    //explicit DialogoConfiguracion(QWidget *parent = nullptr);
    explicit DialogoConfiguracion(QSqlDatabase &db, QWidget *parent = nullptr);
    ~DialogoConfiguracion();
    void ReadSettings();
    void WriteSettings();
    bool HayPython();    
    void ComprobacionesPython();
    void ComprobarDatosAdminRole(QSqlDatabase db);
    void ComprobarRoleSdmed(QSqlQuery consulta);
    bool ComprobarExistenciaBBDDSdmed(QSqlQuery consulta);
    void ComprobarExtensionSuministrada();
    void ComprobarExtensionInstalada(QSqlQuery consulta);
    void CopiarConPermisos(const QString &fichero_origen, const QString &fichero_destino, QString passw = "");
    void ActivarLetreros(bool esadmin);
    bool ComprobarBotonInstalarExtension();

public slots:
    void ComprobacionesPostgres();
    void DefinirRutaScripts();
    void ActivarBotonInstalarExtension();
    bool InstalarExtension();
    void InstalarScriptsPython();
    void DatosAdmin();
    bool CrearRoleContrasenna();
    bool CrearBaseDatosSdmed();
    void SetAdmin(bool esadmin);
    void Salir();

private:
    Ui::DialogoConfiguracion *ui;
    QString m_versionPython;
    QString m_rutaPython;
    QString m_rutaExtensiones;
    QString m_postgres;
    QString m_directorioExtension;
    bool m_instalarExtension;


    //QSqlDatabase m_dbAdmin;
    QSqlDatabase *m_dbAdmin;
    bool m_esDBAdmin;
    bool m_hayRole;
    bool m_hayExtension;
    bool m_hayBBDDSdmed;
    DialogoCredencialesConexionAdmin* m_dialogoConfiguracionAdmin;
};

#endif // DIALOGOCONFIGURACION_H
