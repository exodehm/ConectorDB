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
    QObject::connect(ui->radioButtonLocalHost,SIGNAL(toggled(bool)),this,SLOT(SincronizarCheckButtons()));
    QObject::connect(ui->botonConfiguracionAvanzada, &QPushButton::clicked, [=] () {ConfiguracionAvanzada();});
    QObject::connect(ui->botonComprobar,&QPushButton::clicked, [=] () {Conectar();});
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
    ui->botonConfiguracionAvanzada->setEnabled(ui->radioButtonLocalHost->isChecked() && IsPostgresRunning());
    //ver si hay que modificar el boton de arrancar servidor
    ActualizarBotonServidor();
}

void DialogoDatosConexion::ActualizarBotonServidor()
{
    //boton arrancar/parar postgres
    //solo se activa si estamos en localhost y tenemos la ruta donde se guardan los datos de postgres
    QString datos = m_directorio_datos_conexion.remove(QRegExp("<[^>]*>"));
    qDebug()<<"Los datos estan en "<<datos;
    ui->botonArrancarServidor->setEnabled(ui->radioButtonLocalHost->isChecked() && !m_directorio_datos_conexion.isEmpty()
                                          && !m_directorio_datos_conexion.isNull());
    if (IsPostgresRunning())
    {
        ui->botonArrancarServidor->setText("Parar servidor");
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
        bool isPostgresListening = false;
        QProcess proceso_netstat, proceso_tasklist;
        //QStringList environment = proceso_netstat.systemEnvironment();
        QString command_netstat= "netstat";
        QStringList argumentos_netstat({"-ano"});
        proceso_netstat.start(command_netstat, argumentos_netstat);
        proceso_netstat.waitForFinished();
        QString output = proceso_netstat.readAllStandardOutput();
        QString stsderr = proceso_netstat.readAllStandardError();
        //qDebug("%s", output.toUtf8().data());
        qDebug("%s", stsderr.toUtf8().data());
        QStringList salida = output.split("\r\n");
        QString PID;
        Q_FOREACH(QString linea, salida)
        {
            if (linea.contains("127.0.0.1:5432"))
            {
                qDebug()<<"Linea "<<linea;
                PID = linea.section(' ', -1);
                QString command_tasklist= "tasklist";
                QStringList argumentos_tasklist;
                argumentos_tasklist<<"/fi";
                argumentos_tasklist<<"""pid eq " + PID + """";
                proceso_tasklist.start(command_tasklist, argumentos_tasklist);
                proceso_tasklist.waitForFinished();
                QString output = proceso_tasklist.readAllStandardOutput();
                QString stsderr = proceso_tasklist.readAllStandardError();
                qDebug("%s", output.toUtf8().data());
                qDebug("%s", stsderr.toUtf8().data());
                QStringList salida = output.split("\r\n");
                Q_FOREACH(QString s, salida)
                {
                    if (s.contains("postg"))
                    {
                        qDebug()<<"eureka lo encontré!!! "<<s;
                        isPostgresListening = true;
                    }
                }
            }
        }
        return isPostgresListening;
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

    }
    if (m_db.open())
    {
        ui->labelConectado->setStyleSheet("QLabel { color: green;}");
        ui->labelConectado->setText("<b>Exito</b>");
    }
    else
    {
        ui->labelConectado->setStyleSheet("QLabel {color: red;}");
        ui->labelConectado->setText("<b>Fracaso</b>");
    }
    return m_db.open();

}
