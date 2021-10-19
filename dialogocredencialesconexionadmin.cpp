#include "dialogocredencialesconexionadmin.h"
#include "ui_dialogocredencialesconexionadmin.h"

#include <QSqlDatabase>
#include <QtSql/QSqlQuery>
#include <QSettings>
#include <QDebug>


DialogoCredencialesConexionAdmin::DialogoCredencialesConexionAdmin(QSqlDatabase &db, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoCredencialesConexionAdmin)
{
    ui->setupUi(this);    
    ReadSettings();
    m_db = &db;
    //pongo "localhost" como servidor por defecto, puesto que la configuracion
    //hay que hacerla desde una maquina local
    ui->lineEditServidor->setText("localhost");    
    //tambien pongo el puerto que hay en los settings, ya que ese deberia ser el que se este usando
    ReadSettings();//<--lo uso para poner el puerto
    ui->lineEditUsuario->setFocus();
    QObject::connect(ui->botonComprobar,SIGNAL(clicked(bool)),this, SLOT(ComprobarAdminRole()));
    QObject::connect(ui->lineEditServidor,SIGNAL(textChanged(const QString &)),this, SLOT(ResetearBotonComprobar(const QString &)));
    QObject::connect(ui->lineEditPuerto,SIGNAL(textChanged(const QString &)),this, SLOT(ResetearBotonComprobar(const QString &)));
    QObject::connect(ui->lineEditUsuario,SIGNAL(textChanged(const QString &)),this, SLOT(ResetearBotonComprobar(const QString &)));
    QObject::connect(ui->lineEditPassword,SIGNAL(textChanged(const QString &)),this, SLOT(ResetearBotonComprobar(const QString &)));
    QObject::connect(ui->lineEditBBDD,SIGNAL(textChanged(const QString &)),this, SLOT(ResetearBotonComprobar(const QString &)));
    //QObject::connect(ui->lineEditServidor, &QLineEdit::textChanged, this, &DialogoCredencialesConexion::ResetearBotonComprobar);
}

DialogoCredencialesConexionAdmin::~DialogoCredencialesConexionAdmin()
{
    delete ui;
}

void DialogoCredencialesConexionAdmin::WriteSettings()
{
    QSettings settings("DavidSoft", "SDMed2");
    settings.beginGroup("DatosConexion");
    //settings.setValue("usuario", ui->lineEditUsuario->text());
    //settings.setValue("password", ui->lineEditPassword->text());
    //settings.setValue("servidor", ui->lineEditServidor->text());
    //settings.setValue("puerto", ui->lineEditPuerto->text());
    settings.endGroup();
}

void DialogoCredencialesConexionAdmin::ReadSettings()
{
    /*QSettings settings;
    //ui->lineEditServidor->setText(settings.value("adminrole/servidor").toString());
    ui->lineEditPuerto->setText(settings.value("DatosConexion/puerto").toString());
    ui->lineEditUsuario->setText(settings.value("adminrole/usuario").toString());
    ui->lineEditPassword->setText(settings.value("adminrole/password").toString());*/
    QSettings settings("DavidSoft", "SDMed2");
    settings.beginGroup("DatosConexion");
    //m_basededatos = settings.value("basedatos").toString();
    //m_nombre = settings.value("usuario").toString();
    ui->lineEditPuerto->setText(settings.value("puerto").toString());
    //m_password = settings.value("passwd").toString();
    //m_host = settings.value("hostname").toString();
    settings.endGroup();
}

DialogoCredencialesConexionAdmin::sDatosConexion DialogoCredencialesConexionAdmin::LeeDatosConexion()
{
    m_datosConexion.hostName = ui->lineEditServidor->text();
    m_datosConexion.puerto = ui->lineEditPuerto->text().toInt();
    m_datosConexion.usuario = ui->lineEditUsuario->text();
    m_datosConexion.password = ui->lineEditPassword->text();
    return m_datosConexion;
}

void DialogoCredencialesConexionAdmin::DefinirBBDD(QString nombreBBDD)
{
    ui->lineEditBBDD->setText(nombreBBDD);
}

bool DialogoCredencialesConexionAdmin::ComprobarAdminRole()
{
    //QSqlDatabase m_db;
    //m_db= QSqlDatabase::addDatabase("QPSQL");
    m_db->setHostName(ui->lineEditServidor->text());
    m_db->setPort(ui->lineEditPuerto->text().toInt());
    m_db->setUserName(ui->lineEditUsuario->text());
    m_db->setPassword(ui->lineEditPassword->text());
    m_db->setDatabaseName(ui->lineEditBBDD->text());
    bool esSuperUser = false;
    m_db->close();
    if (m_db->open(ui->lineEditUsuario->text(),ui->lineEditPassword->text()))
    {
        WriteSettings();
        QString cadenacomprobacionrolsuper = "SELECT rolsuper FROM pg_authid WHERE rolname = '" + ui->lineEditUsuario->text() + "'";
        QSqlQuery consulta(cadenacomprobacionrolsuper, *m_db);
        while (consulta.next())
        {
            esSuperUser = consulta.value(0).toBool();
        }
        if (esSuperUser)
        {
            ui->botonComprobar->setStyleSheet("background-color: rgb(0,255,0);");
            ui->botonComprobar->setText(tr("Conectado correctamente como administrador"));            
            //WriteSettings();
        }
        else //si se ha conectado pero las credenciales no son de admin
        {
            ui->botonComprobar->setStyleSheet("background-color: rgb(255,255,0);");
            ui->botonComprobar->setText(tr("El usuario no es administrador"));
        }
    }
    else //si no se ha podido conectar
    {
        ui->botonComprobar->setStyleSheet("background-color: rgb(255,0,0);");
        ui->botonComprobar->setText(tr("Error de conexión"));

    }
    //ui->botonAceptar->setEnabled(esSuperUser);
    WriteSettings();
    m_db->close();
    emit EsAdmin(esSuperUser);
    return esSuperUser;
}

void DialogoCredencialesConexionAdmin::ResetearBotonComprobar(const QString &texto)
{
    Q_UNUSED(texto)
    ui->botonComprobar->setStyleSheet("");//reseteamos las propiedades, en este caso el color
    ui->botonComprobar->setText(tr("Comprobar"));
}
