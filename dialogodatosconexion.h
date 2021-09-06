#ifndef DIALOGODATOSCONEXION_H
#define DIALOGODATOSCONEXION_H

#include <QDialog>
#include <QtSql/QSqlDatabase>

class DialogoConfiguracion;

namespace Ui {
class DialogoDatosConexion;
}

class DialogoDatosConexion : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoDatosConexion(QSqlDatabase& db, QWidget *parent = nullptr);
    ~DialogoDatosConexion();
    void readSettings();


public slots:
    void writeSettings();
    void SincronizarCheckButtons();
    void ActualizarBotonServidor();
    QStringList LeeDatosConexion();
    void ConfiguracionAvanzada();
    bool IsPostgresRunning();
    bool Conectar();
    void ControlarServidor();

private:
    Ui::DialogoDatosConexion *ui;
    DialogoConfiguracion* m_dialogoconfig;
    QString m_postgres;
    QSqlDatabase m_db;
    QString m_directorio_datos_conexion;
};

#endif // DIALOGODATOSCONEXION_H
