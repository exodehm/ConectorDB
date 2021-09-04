#include "dialogodatosconexion.h"
#include "./ui_dialogodatosconexion.h"
#include "./dialogoconfiguracion.h"

#include <QDebug>
#include <QObject>
#include <QSettings>
#include <QPushButton>
#include <QProcess>

DialogoDatosConexion::DialogoDatosConexion(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoDatosConexion)
{
    ui->setupUi(this);
    m_d =  nullptr;
    readSettings();
    SincronizarCheckButtons();
    QObject::connect(ui->radioButtonLocalHost,SIGNAL(toggled(bool)),this,SLOT(SincronizarCheckButtons()));
    QObject::connect(ui->botonConfiguracionAvanzada, &QPushButton::clicked, [=] () {ConfiguracionAvanzada();});
    //QObject::connect(ui->botonera->button(QDialogButtonBox::Ok),SIGNAL(clicked()),this,SLOT(LeeDatosConexion()));
}

DialogoDatosConexion::~DialogoDatosConexion()
{
    qDebug()<<"Adios";
    delete ui;
}

void DialogoDatosConexion::readSettings()
{
    QSettings settings("DavidSoft", "SDMed2");

    settings.beginGroup("DatosConexion");
    ui->lineEditBBDD->setText(settings.value("basedatos").toString());
    ui->lineEditUsuario->setText(settings.value("usuario").toString());
    ui->lineEditPuerto->setText(settings.value("puerto").toString());
    ui->lineEditPasswd->setText(settings.value("passwd").toString());
    settings.endGroup();
}

QStringList DialogoDatosConexion::DialogoDatosConexion::LeeDatosConexion()
{
    //primero miro y construyo la cadena de la direccion, si es localhost o una IP
    QString host;
    if (ui->radioButtonLocalHost->isChecked())
    {
        host = "localhost";
    }
    else
    {
        host = ui->lineEditIP1->LeerIP()+"."+
                ui->lineEditIP2->LeerIP()+"."+
                ui->lineEditIP3->LeerIP()+"."+
                ui->lineEditIP4->LeerIP();
    }
    //ahora ingreso este y el resto de datos en el QStringList
    QStringList datos;
    datos<<ui->lineEditBBDD->text()<<   //nombre de la base de datos
       ui->lineEditUsuario->text()<<    //usuario
       host<<                           //hostname
       ui->lineEditPuerto->text()<<     //puerto
       ui->lineEditPasswd->text();      //contrasenna
    foreach (QString s, datos) {
       qDebug()<<"dato; "<<s;
    }
    return datos;
}

void DialogoDatosConexion::ConfiguracionAvanzada()
{
    if (m_d==nullptr)
    {
        m_d = new DialogoConfiguracion;
    }
    m_d->show();
}

void DialogoDatosConexion::writeSettings()
{
    QSettings settings("DavidSoft", "SDMed2");

    settings.beginGroup("DatosConexion");
    settings.setValue("basedatos", ui->lineEditBBDD->text());
    settings.setValue("usuario", ui->lineEditUsuario->text());
    settings.setValue("puerto", ui->lineEditPuerto->text());
    settings.setValue("passwd", ui->lineEditPasswd->text());
    settings.endGroup();
}

void DialogoDatosConexion::SincronizarCheckButtons()
{
    //casillas para IP
    ui->lineEditIP1->setEnabled(ui->radioButtonIP->isChecked());
    ui->lineEditIP2->setEnabled(ui->radioButtonIP->isChecked());
    ui->lineEditIP3->setEnabled(ui->radioButtonIP->isChecked());
    ui->lineEditIP4->setEnabled(ui->radioButtonIP->isChecked());
    //boton para configurar
    //este solo se activara si estamos en modo local, para poder instalar
    //extensiones y demas.
    ui->botonConfiguracionAvanzada->setEnabled(ui->radioButtonLocalHost->isChecked() && IsPostgresRunning());
    //boton arrancar postgres
    //solo se activa si estamos en localhost y el servidor no esta arrancado
    ui->botonArrancarServidor->setEnabled(ui->radioButtonLocalHost->isChecked() && !IsPostgresRunning());
}

bool DialogoDatosConexion::IsPostgresRunning()
{
    QSettings settings;
    QString admin = settings.value("adminrole/usuario").toString();

    #if defined(Q_OS_LINUX)
        QProcess programa;
        QStringList environment = programa.systemEnvironment();
        QString commandToStart= "pgrep";
        QStringList argumentos;
        argumentos<<"-u"<<admin<<"-fa"<<"--"<<"-D";
        programa.start(commandToStart,argumentos);
        bool started = programa.waitForStarted();
        qDebug()<<"bool "<<started;
        if (!programa.waitForFinished(10000)) // 10 Second timeout
        {
            programa.kill();
        }
        int exitCode = programa.exitCode();
        qDebug()<<"exit status"<<exitCode;
        m_postgres = QString::fromLocal8Bit(programa.readAllStandardOutput());
        QString stdError = QString::fromLocal8Bit(programa.readAllStandardError());
        qDebug()<<"Salida: "<<m_postgres;
        qDebug()<<"Errores: "<<stdError;
        if (exitCode == 0)
        {
            return true;
        }
        return false;
    #else //windows
    {
        QProcess programa;
        QStringList environment = programa.systemEnvironment();
        QString commandToStart= "netstat";
        QStringList argumentos;
        argumentos<<"-a"<<"-n";
        programa.start(commandToStart,argumentos);
        //netstat -a -n | findstr 5432
        return true;
    }
    #endif
}
