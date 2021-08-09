#ifndef DIALOGODATOSCONEXION_H
#define DIALOGODATOSCONEXION_H

#include <QDialog>

class DialogoConfiguracion;

namespace Ui {
class DialogoDatosConexion;
}

class DialogoDatosConexion : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoDatosConexion(QWidget *parent = nullptr);
    ~DialogoDatosConexion();
    void readSettings();


public slots:
    void writeSettings();
    void SincronizarCheckButtons();
    QStringList LeeDatosConexion();
    void ConfiguracionAvanzada();
    bool IsPostgresRunning();

private:
    Ui::DialogoDatosConexion *ui;
    DialogoConfiguracion* m_d;
    QString m_postgres;
};

#endif // DIALOGODATOSCONEXION_H
