#include "conector.h"
#include "ui_widget.h"
#include "./dialogodatosconexion.h"
#include <QDebug>

Widget::Widget(QWidget *parent):QWidget(parent),ui(new Ui::Widget)
{
    ui->setupUi(this);
    readSettings();
    m_tiempoMaximoIntentoConexion = 5;
    m_db = QSqlDatabase::addDatabase("QPSQL");
    m_db.setConnectOptions("connect_timeout = " + QString::number(m_tiempoMaximoIntentoConexion));
    m_d = nullptr;    
    ConfigurarYConectar();
    QObject::connect(ui->botonConfigurar, SIGNAL(clicked()), this,  SLOT(Configurar()));
}

Widget::~Widget()
{
    QSqlDatabase::removeDatabase("QPSQL");
    writeSettings();
    delete ui;
}

void Widget::readSettings()
{
    QSettings settings("DavidSoft", "SDMed2");
    settings.beginGroup("DatosConexion");
    m_basededatos = settings.value("basedatos").toString();
    m_nombre = settings.value("usuario").toString();
    m_puerto = settings.value("puerto").toString();
    m_password = settings.value("passwd").toString();
    m_host = settings.value("hostname").toString();
    settings.endGroup();
}

void Widget::writeSettings()
{
    QSettings settings("DavidSoft", "SDMed2");

    settings.beginGroup("DatosConexion");
    settings.setValue("basedatos", m_basededatos);
    settings.setValue("usuario", m_nombre);
    settings.setValue("puerto", m_puerto);
    settings.setValue("passwd", m_password);
    settings.setValue("hostname", m_host);
    settings.endGroup();
}

void Widget::ConfigurarYConectar()
{
    qDebug()<<"Nombre base de datos: "<<m_basededatos;
    qDebug()<<"Nombre usuario: "<<m_nombre;
    qDebug()<<"Nombre puerto: "<<m_puerto;
    qDebug()<<"Nombre password: "<<m_password;
    qDebug()<<"Nombre del hostname: "<<m_host;
    m_db.setDatabaseName(m_basededatos);
    m_db.setUserName(m_nombre);
    m_db.setPort(m_puerto.toInt());
    m_db.setPassword(m_password);
    m_db.setHostName(m_host);

    if (m_db.open())
    {
        ui->labelResultado->setStyleSheet("QLabel { color: green;}");
        ui->labelResultado->setText("<b>Exito</b>");
    }
    else
    {
        ui->labelResultado->setStyleSheet("QLabel {color: red;}");
        ui->labelResultado->setText("<b>Fracaso</b>");
        m_db.close();
        Configurar();
    }
}

void Widget::Configurar()
{
    if (m_d==nullptr)
    {
        m_d = new DialogoDatosConexion(this);
    }
    m_d->show();
    if (m_d->exec())
    {
        QStringList l = m_d->LeeDatosConexion();
        foreach (QString s, l )
        {
            qDebug()<<"Leuendo del dialogo: "<<s;
        }
        m_basededatos = l.at(eDatosConexion::BBDD);
        m_nombre = l.at(eDatosConexion::NOMBRE);
        m_puerto = l.at(eDatosConexion::PUERTO);
        m_password = l.at(eDatosConexion::PASSWD);
        m_host = l.at(eDatosConexion::HOST);
        writeSettings();
        ConfigurarYConectar();
    }
}

