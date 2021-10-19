#include "dialogodatosconexion.h"
#include "./ui_dialogodatosconexion.h"
#include "./dialogoconfiguracion.h"

#include <QDebug>
#include <QObject>
#include <QSettings>
#include <QPushButton>
#include <QProcess>

DialogoDatosConexion::DialogoDatosConexion(QSqlDatabase &db, QWidget *parent) :
    m_db(db),
    QDialog(parent),
    ui(new Ui::DialogoDatosConexion)
{
    ui->setupUi(this);
    m_dialogoconfig =  nullptr;
    readSettings();
    SincronizarCheckButtons();
    m_ispostgres_running = IsPostgresRunning();
    qDebug()<<"It´s postgres running!"<<m_ispostgres_running;
    QObject::connect(ui->radioButtonLocalHost,SIGNAL(toggled(bool)),this,SLOT(SincronizarCheckButtons()));
    QObject::connect(ui->botonConfiguracionAvanzada, &QPushButton::clicked, [=] () {ConfiguracionAvanzada();});
    QObject::connect(ui->botonComprobar, &QPushButton::clicked, [=] () {Conectar();});
    QObject::connect(ui->botonArrancarServidor, &QPushButton::clicked,[=](){ArrancarPararServidor();});
    //QObject::connect(ui->botonera->button(QDialogButtonBox::Ok),SIGNAL(clicked()),this,SLOT(LeeDatosConexion()));

}

DialogoDatosConexion::~DialogoDatosConexion()
{
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
    //settings.beginGroup("rutas");
    //m_rutaPython = settings.value("rutas/ruta_python").toString();
    m_directorio_datos_conexion = settings.value("rutas/ruta_directorio_datos").toString();
    //settings.endGroup();
}

QString DialogoDatosConexion::ComponerIP()
{
    return ui->lineEditIP1->LeerIP()+"."+
            ui->lineEditIP2->LeerIP()+"."+
            ui->lineEditIP3->LeerIP()+"."+
            ui->lineEditIP4->LeerIP();
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
        host = ComponerIP();
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
    if (m_dialogoconfig==nullptr)
    {
        m_dialogoconfig = new DialogoConfiguracion;
    }
    m_dialogoconfig->show();
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
    ui->botonConfiguracionAvanzada->setEnabled(ui->radioButtonLocalHost->isChecked() && /*IsPostgresRunning()*/m_ispostgres_running);
    //ver si hay que modificar el boton de arrancar servidor
    ActualizarBotonServidor();
}

void DialogoDatosConexion::ActualizarBotonServidor()
{
    //boton arrancar/parar postgres
    //solo se activa si estamos en localhost y tenemos la ruta donde se guardan los datos de postgres
    qDebug()<<"Los datos estan en "<<m_directorio_datos_conexion;
    ui->botonArrancarServidor->setEnabled(ui->radioButtonLocalHost->isChecked() && !m_directorio_datos_conexion.isEmpty()
                                          && !m_directorio_datos_conexion.isNull());
    if (m_ispostgres_running/*IsPostgresRunning()*/)
    {
        ui->botonArrancarServidor->setText(tr("Parar servidor"));
    }
    else
    {
        ui->botonArrancarServidor->setText(tr("Arrancar servidor"));
    }
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
        QProcess proceso1, proceso2;
        QStringList environment = proceso1.systemEnvironment();
        QString commandToStart1= "netstat";
        QStringList argumentos1;
        argumentos1<<"-ano";
        proceso1.start(commandToStart1,argumentos1);
        QString commandToStart2= "findstr";
        QStringList argumentos2;
        //argumentos2<<"\"5432\"";
        argumentos2<<ui->lineEditPuerto->text();
        proceso2.start(commandToStart2,argumentos2);
        proceso2.setProcessChannelMode(QProcess::ForwardedChannels);
        bool started = proceso1.waitForStarted();
        qDebug()<<"bool "<<started;
        if (!proceso1.waitForFinished(10000)) // 10 Second timeout
        {
            proceso1.kill();
        }
        int exitCode = proceso1.exitCode();
        qDebug()<<"exit status"<<exitCode;
        m_postgres = QString::fromLocal8Bit(proceso1.readAllStandardOutput());
        QString stdError = QString::fromLocal8Bit(proceso1.readAllStandardError());
        qDebug()<<"Salida: "<<m_postgres;
        qDebug()<<"Errores: "<<stdError;
        if (exitCode == 0)
        {
            qDebug()<<"It´s postgres running!"<<m_ispostgres_running;
            return true;
        }
        return false;
    }
#endif
}

bool DialogoDatosConexion::Conectar()
{
    m_db.setDatabaseName(ui->lineEditBBDD->text());
    m_db.setUserName(ui->lineEditUsuario->text());
    m_db.setPort(ui->lineEditPuerto->text().toInt());
    m_db.setPassword(ui->lineEditPasswd->text());
    //IP o localhost
    if (ui->radioButtonLocalHost->isChecked())
    {
        m_db.setHostName("localhost");
    }
    else if (ui->radioButtonIP->isChecked())
    {
        m_db.setHostName(ComponerIP());
    }
    if (m_db.open())
    {
        ui->labelConectado->setStyleSheet("QLabel { color: green;}");
        ui->labelConectado->setText(tr("<b>Conectado con éxito</b>"));
    }
    else
    {
        ui->labelConectado->setStyleSheet("QLabel {color: red;}");
        ui->labelConectado->setText(tr("<b>Error en la conexión</b>"));
    }
    return m_db.open();
}

bool DialogoDatosConexion::ArrancarPararServidor()
{
    m_ispostgres_running=!m_ispostgres_running;
    if (m_ispostgres_running)
    {
        ui->botonArrancarServidor->setText(tr("Parar\nservidor"));
    }
    else
    {
        ui->botonArrancarServidor->setText(tr("Arrancar\nservidor"));
    }
    return m_ispostgres_running;
}
