#include "./dialogoconfiguracion.h"
#include "./dialogocontrasenna.h"
#include "./ui_dialogoconfiguracion.h"
#include "./dialogosudo.h"
#include "./dialogocredencialesconexionadmin.h"


#include <QFileDialog>
#include <QSettings>
#include <QDirIterator>
#include <QTemporaryDir>
#include <QProcess>
#include <QMessageBox>
#include <QtSql/QSqlError>
#include <QTextEdit>
#include <QDebug>
#include <QIODevice>

//#include "pyrun.h"

DialogoConfiguracion::DialogoConfiguracion(QSqlDatabase &db, QWidget *parent) : QDialog(parent), ui(new Ui::DialogoConfiguracion)
{
    ui->setupUi(this);
    m_dialogoConfiguracionAdmin = nullptr;
    //m_dbAdmin= QSqlDatabase::addDatabase("QPSQL");
    m_dbAdmin = &db;
    ReadSettings();
    ComprobacionesPython();
    ComprobarDatosAdminRole(*m_dbAdmin);
    QObject::connect(ui->botonDatosAdmin,SIGNAL(clicked(bool)),this,SLOT(DatosAdmin()));
    QObject::connect(ui->boton_ruta_python,SIGNAL(clicked(bool)),this,SLOT(DefinirRutaScripts()));
    QObject::connect(ui->boton_salir,SIGNAL(clicked(bool)),this,SLOT(Salir()));
    QObject::connect(ui->boton_instalar_extension,SIGNAL(clicked(bool)),this,SLOT(InstalarExtension()));
    QObject::connect(ui->boton_instalar_scripts,SIGNAL(clicked(bool)),this,SLOT(InstalarScriptsPython()));
    QObject::connect(ui->boton_crear_role_sdmed,SIGNAL(clicked(bool)),this,SLOT(CrearRoleContrasenna()));
    QObject::connect(ui->boton_crear_bbdd_sdmed,SIGNAL(clicked(bool)),this,SLOT(CrearBaseDatosSdmed()));
}

DialogoConfiguracion::~DialogoConfiguracion()
{
    delete ui;
}

void DialogoConfiguracion::ReadSettings()
{
    QSettings settings("DavidSoft", "SDMed2");
    ui->lineEdit_ruta_python->setText(settings.value("rutas/ruta_python").toString());
    m_rutaPython = settings.value("rutas/ruta_python").toString();
}

void DialogoConfiguracion::DefinirRutaScripts()
{
    QFileDialog fd(this,"Elige directorio scripts python",m_rutaPython);
    fd.setFilter(QDir::Dirs|QDir::AllDirs|QDir::Hidden|QDir::NoDotAndDotDot);
    fd.setFileMode(QFileDialog::DirectoryOnly);
    if (fd.exec())
    {
        qDebug()<<fd.selectedFiles();
        if (!fd.selectedFiles().isEmpty())
        {
            ui->lineEdit_ruta_python->setText(fd.selectedFiles().at(0));
            m_rutaPython = fd.selectedFiles().at(0);
        }
    }
}

void DialogoConfiguracion::ActivarBotonInstalarExtension()
{
    //ui->boton_ruta_extension->setEnabled(!ui->lineEdit_ruta_extension->text().isEmpty());
}

bool DialogoConfiguracion::InstalarExtension()
{
    //Para instalar la extension hay que estar conectado a la BBDD "sdmed", por lo que el primer paso sera comprobar
    //si se esta conectado, y si no, abrir un dialogo para recordarlo y salir de la funcion
    QString cadenaRoleActual = "SELECT current_database()";
    QSqlQuery consulta (*m_dbAdmin);
    consulta.exec(cadenaRoleActual);
    QString BBDD;
    if (consulta.size()>0)
    {
        while (consulta.next())
        {
            BBDD = consulta.value(0).toString();
        }
        if (BBDD!="sdmed")
        {
            QString aviso = tr("La extensión ha de instalarse estando conectado a la BBDD 'sdmed'\n¿Probar a conectarse?");
            int ret = QMessageBox::warning(this, tr("Aviso"),aviso,QMessageBox::Ok|QMessageBox::Cancel, QMessageBox::Ok);
            if (ret==QMessageBox::Ok)
            {
                m_dialogoConfiguracionAdmin->show();
                m_dialogoConfiguracionAdmin->DefinirBBDD("sdmed");
            }
            return false;
        }
    }
    //segundo paso, copiar los archivos al directorio extension
    //para ello creo un directorio temporal para copiar loa archivos del resource al disco duro y luego poder copiarlos
    //al directorio extension (solo necesario para linux/mac pero hago el mismo procedimiento para windows para no aumentar codigo
    QTemporaryDir tempdir;
    if (tempdir.isValid())
    {
        QString sResourceFiles = ":/postgres-extension";
        QTextEdit htmlText(ui->label_ruta_directorio_extension->text());
        QString ruta_extension = htmlText.toPlainText() + QDir::separator();
        QDirIterator it(sResourceFiles);//, QDirIterator::Subdirectories);
        QStringList listaArchivosCopiar;
        while (it.hasNext())
        {
            it.next();
            listaArchivosCopiar<<it.fileName();
        }
        //crear el dialogo de confirmacion
        QString aviso = "Se copiarán <b>";
        int i = 0;
        while (i<listaArchivosCopiar.size())
        {
            aviso.append(listaArchivosCopiar.at(i)).append(" ");
            i++;
        }
        aviso.append("</b>en:<br> ");
        aviso.append("<b>" + ruta_extension + "</b>");
        //fin crear el dialogo de confirmacion
        int ret = QMessageBox::information(this, tr("Aviso"),aviso,QMessageBox::Ok|QMessageBox::Cancel, QMessageBox::Cancel);
        if (ret == QMessageBox::Ok)
        {
            bool res = true;
#if defined(Q_OS_WIN)//<---Windows            
            int i=0;
            while (i<listaArchivosCopiar.size())
            {
                QString fOrigen = sResourceFiles + QDir::separator() + listaArchivosCopiar.at(i);
                QString fDestino = ruta_extension + listaArchivosCopiar.at(i);
                if (QFile::exists(fDestino))
                {                    
                    QString aviso = tr("El fichero %1 existe. No se copiará").arg(listaArchivosCopiar.at(i));
                    int ret = QMessageBox::information(this, tr("Aviso"),aviso,QMessageBox::Ok, QMessageBox::Ok);
                    //QFile::remove(fDestino);
                }
                else
                {
                    res = QFile::copy(fOrigen, fDestino);
                }
                if (res == false)
                {                    
                    QString aviso = tr("Ha habido problemas con la copia de ficheros");
                    int ret = QMessageBox::warning(this, tr("Aviso"),aviso,QMessageBox::Ok, QMessageBox::Ok);
                    return  false;
                }
                i++;
            }
#else//<--Linux ....y mac?
            DialogoSudo* d = new DialogoSudo(this);
            if (d->exec())
            {
                QString passw = d->PassWSudo();
                for (int i=0;i<listaArchivosCopiar.size();i++)
                {
                    QFile f(sResourceFiles + QDir::separator() + listaArchivosCopiar.at(i));
                    const QString fichero_origen = tempdir.path() + QDir::separator() + listaArchivosCopiar.at(i);
                    f.copy(fichero_origen);
                    QString fichero_destino = ruta_extension + listaArchivosCopiar.at(i);
                    CopiarConPermisos(fichero_origen,fichero_destino,passw);
                }
            }
#endif
            //tercer paso, una vez copiados los ficheros al directorio extension,
            //instalar la extension en la base de datos
            if (res == true)
            {
                qDebug()<<"Ahora viene el create extension";
                QString cadenaCrearExtension = "SELECT extversion FROM pg_extension WHERE extname ='sdmed'";                
                consulta.exec(cadenaCrearExtension);
                if (consulta.size()>0)//si hay alguna extension instalada, si no darq 0
                {
                    while (consulta.next())
                    {
                        qDebug()<<consulta.value(0).toBool();
                    }
                    cadenaCrearExtension = "ALTER EXTENSION sdmed UPDATE";
                }
                else//no hay versión instalada
                {
                    cadenaCrearExtension = "CREATE EXTENSION sdmed";
                }
                consulta.exec(cadenaCrearExtension);
                ComprobarExtensionInstalada(consulta);
                ComprobarExtensionSuministrada();
            }
            return true;
        }
    }
    return false;
}

void DialogoConfiguracion::InstalarScriptsPython()
{
    /*qDebug()<<"Instalar Scripts Python en "<<m_rutaPython;
    QTemporaryDir tempdir;
    if (tempdir.isValid())
    {
        QString sResourceFiles = ":/python";
        QString ruta = tempdir.path() + QDir::separator();
        QString sArchivoComprimido;
        QDirIterator it(sResourceFiles);
        while (it.hasNext())
        {
            it.next();
            QString fOrigen = sResourceFiles + QDir::separator() + it.fileName();
            QString fDestino = ruta + it.fileName();
            if (QFile::exists(fDestino))
            {
                QFile::remove(fDestino);
            }
            if (fDestino.endsWith(".zip"))
            {
                sArchivoComprimido=fDestino;
            }
            bool res = QFile::copy(fOrigen, fDestino);
            if (res == false)
            {
                break;
            }
        }
        QString m_pModulo = "instalar_scripts";
        QString m_pFuncion = "Descomprimir";
        QStringList pArgumentos;
        pArgumentos<<m_rutaPython<<sArchivoComprimido;

        QPair <int,QVariant>res = ::PyRun::loadModule(ruta, m_pModulo, m_pFuncion, pArgumentos);
        qDebug()<<res.first;
        if (res.first==5)
        {
            QMessageBox msgBox;
            msgBox.setText(tr("Los archivos se han copiado con éxito en ") + m_rutaPython + QDir::separator() + ".sdmed");
            msgBox.exec();
        }
        //ahora las dependencias
        m_pFuncion = "InstalarDependencias";
        pArgumentos.clear();
        pArgumentos<<m_rutaPython;
        QPair <int,QVariant>res2 = ::PyRun::loadModule(ruta, m_pModulo, m_pFuncion, pArgumentos);
        qDebug()<<res2.first;
    }*/
}

void DialogoConfiguracion::DatosAdmin()
{
    if (!m_dialogoConfiguracionAdmin)
    {
        m_dialogoConfiguracionAdmin = new DialogoCredencialesConexionAdmin(*m_dbAdmin, this);
        QObject::connect(m_dialogoConfiguracionAdmin,SIGNAL(EsAdmin(bool)),this,SLOT(SetAdmin(bool)));
        QObject::connect(m_dialogoConfiguracionAdmin,SIGNAL(accepted()),this,SLOT(ComprobacionesPostgres()));
    }
    m_dialogoConfiguracionAdmin->show();
    ComprobarDatosAdminRole(*m_dbAdmin);
}

void DialogoConfiguracion::CopiarConPermisos(const QString &fichero_origen, const QString &fichero_destino, QString passw)
{
    QProcess process1;
    QProcess process2;
    process1.setStandardOutputProcess(&process2);
    QString s_process1 = "echo " + passw;
    qDebug()<<s_process1;
    QString s_process2 = "sudo -S cp " + fichero_origen + " " + fichero_destino;
    qDebug()<<s_process2;
    process1.start(s_process1);
    process2.start(s_process2);
    process2.setProcessChannelMode(QProcess::ForwardedChannels);
    bool retval = false;
    QByteArray buffer;
    process1.waitForFinished(5000);
    while ((retval = process2.waitForFinished()))
    {
        buffer.append(process2.readAll());
    }
    if (!retval)
    {
        qDebug() << "Process 1 error:" << process1.errorString();
        qDebug() << "Process 2 error:" << process2.errorString();
    }
}

void DialogoConfiguracion::ActivarLetreros(bool esadmin)
{
    ui->label_directorio_extensiones->setEnabled(esadmin);
    ui->label_titulo_nombre_extension->setEnabled(esadmin);
    ui->label_titulo_version_defecto->setEnabled(esadmin);
    ui->label_titulo_version_instalada->setEnabled(esadmin);
    ui->label_titulo_descripcion->setEnabled(esadmin);
    ui->label_titulo_version_suministrada->setEnabled(esadmin);
    ui->label_existe_role_sdmed->setEnabled(esadmin);
    ui->label_existe_bbdd_sdmed->setEnabled(esadmin);
    ui->boton_crear_role_sdmed->setEnabled(esadmin);
    ui->boton_crear_bbdd_sdmed->setEnabled(esadmin);
    ui->boton_instalar_extension->setEnabled(ComprobarBotonInstalarExtension());
    if (!esadmin)
    {
        ui->label_ruta_directorio_extension->setText("");
        ui->label_nombre_extension->setText("");
        ui->label_advertencia_noadmin->setText(tr("Es necesario tener credenciales de administrador\npara las tareas de configuración"));
        ui->label_version_suministrada->setText("");
        ui->label_version_instalada->setText("");
    }
    else
    {
        ui->label_advertencia_noadmin->setText(tr(""));
    }
}

bool DialogoConfiguracion::ComprobarBotonInstalarExtension()
{
    return m_hayRole && m_hayBBDDSdmed;
}

void DialogoConfiguracion::Salir()
{
    WriteSettings();
    int result = 0;
    this->done(result);
}

void DialogoConfiguracion::WriteSettings()
{
    QSettings settings("DavidSoft", "SDMed2");
    settings.beginGroup("rutas");
    settings.setValue("ruta_python", m_rutaPython);
    //si hay ruta de datos la guardo para poder usarla luego para intentar levantar y parar el servidor
    if (!ui->label_ruta_directorio_datos->text().isEmpty())
    {
        settings.setValue("ruta_directorio_datos",ui->label_ruta_directorio_datos->text());
    }
    settings.endGroup();
}

bool DialogoConfiguracion::HayPython()
{
    QProcess programa;
    QStringList environment = programa.systemEnvironment();
    QString commandToStart= "python3";
    QStringList argumentos;
    argumentos<<"-V";
    programa.start(commandToStart,argumentos);
    bool started = programa.waitForStarted();
    qDebug()<<"bool "<<started;
    if (!programa.waitForFinished(5000)) // 10 Second timeout
    {
        programa.kill();
    }
    int exitCode = programa.exitCode();
    qDebug()<<"exit status"<<exitCode;
    if (exitCode!= 0)
    {
        commandToStart = "python";
        programa.start(commandToStart,argumentos);
        started = programa.waitForStarted();
        if (programa.waitForFinished(5000))
        {
            programa.kill();
        }
        exitCode = programa.exitCode();
    }
    //qDebug()<<"Salida: "<<stdOutput;
    m_versionPython = QString::fromLocal8Bit(programa.readAllStandardOutput());
    QString stdError = QString::fromLocal8Bit(programa.readAllStandardError());
    qDebug()<<"Errores: "<<stdError;
    if (exitCode == 0)
    {
        return true;
    }
    return false;
}

void DialogoConfiguracion::ComprobacionesPostgres()
{
    //if (IsPostgresRunning())    
    {
        if (m_dbAdmin->open())
        {
            QSqlQuery consulta(*m_dbAdmin);
            //directorio extension
            QString consultaSharedir = "SELECT setting from pg_config WHERE name = \'SHAREDIR\'";
            consulta.exec(consultaSharedir);
            while (consulta.next())
            {
                qDebug()<<consulta.value(0).toString();
                ui->label_ruta_directorio_extension->setText(tr("<font color=green><b>%1</b></font>").arg(consulta.value(0).toString()+"/extension"));
            }
            QString consultaDirectorioDatos = "SHOW data_directory;";
            consulta.exec(consultaDirectorioDatos);
            while (consulta.next())
            {
                qDebug()<<consulta.value(0).toString();
                ui->label_ruta_directorio_datos->setText(tr("<font color=green><b>%1</b></font>").arg(consulta.value(0).toString()));
            }
            //extensiones instaladas
            ComprobarRoleSdmed(consulta);
            ComprobarExistenciaBBDDSdmed(consulta);
            ComprobarExtensionInstalada(consulta);
        }
        //directorio datos
        QString smain = m_postgres.left(m_postgres.lastIndexOf("-c")-1);
        smain = smain.mid(m_postgres.lastIndexOf("-D")+3);
        ui->combobox_rutas_datos->addItem(smain);
        ComprobarExtensionSuministrada();
    }
}

void DialogoConfiguracion::ComprobacionesPython()
{
    bool hayPython = HayPython();
    if (hayPython)
    {
        ui->labelVersionPython->setText(tr("<font color=green><b>%1</b></font>").arg(m_versionPython));
    }
    else
    {
        ui->labelLetreroVersionPython->setToolTip(tr("<p>Los scripts de python necesitan que python3 esté instalado en el equipo</p>"
                                                     "Puedes descargarlo e instalarlo desde su web oficial <b>https://www.python.org</b>"));
        ui->labelVersionPython->setText(tr("<font color=red><b>%1</b></font>").arg("No se ha detectado python3 en el equipo"));
    }
    ui->boton_instalar_scripts->setEnabled(hayPython);
}

void DialogoConfiguracion::ComprobarDatosAdminRole(QSqlDatabase db)
{
    m_esDBAdmin = false;//inicio a false siempre
    QSettings settings;
    QString servidor = settings.value("adminrole/servidor").toString();
    int puerto = settings.value("adminrole/puerto").toInt();
    QString admin = settings.value("adminrole/usuario").toString();
    QString password = settings.value("adminrole/password").toString();
    db.setHostName(servidor);
    db.setPort(puerto);
    db.setUserName(admin);
    db.setPassword(password);
    db.setDatabaseName("sdmed");
    //bool esAdmin = true;
    if (db.open())
    {
        QSqlQuery consulta(db);
        QString cadenacomprobacionrolsuper = "SELECT rolsuper FROM pg_authid WHERE rolname = '" + settings.value("adminrole/usuario").toString() + "'";
        qDebug()<<cadenacomprobacionrolsuper;
        consulta.exec(cadenacomprobacionrolsuper);
        while (consulta.next())
        {
            m_esDBAdmin = consulta.value(0).toBool();
        }
    }
    else
    {
        qDebug()<<db.lastError();
    }
    ActivarLetreros(m_esDBAdmin);
    if (m_esDBAdmin)
    {
        ComprobacionesPostgres();
    }
}

void DialogoConfiguracion::ComprobarExtensionInstalada(QSqlQuery consulta)
{
    ui->label_version_instalada->setText("...");
    QString consultaExtensionesSdmedInstaladas = "SELECT * FROM pg_available_extensions where name like \'%sdmed%\'";
    consulta.exec(consultaExtensionesSdmedInstaladas);
    if (/*consulta.isValid() && */consulta.size()>0)
    {
        while (consulta.next())
        {
            ui->label_nombre_extension->setText(consulta.value(0).toString());
            ui->label_version_defecto->setText(consulta.value(1).toString());
            if (consulta.value(2).toString().isEmpty())
            {
                ui->label_version_instalada->setText(tr("<font color=red><b>%1</b></font>").arg("Ninguna"));
                m_hayExtension = false;
            }
            else
            {
                ui->label_version_instalada->setText(consulta.value(2).toString());
                m_hayExtension = true;
            }
            ui->label_descripcion->setText(consulta.value(3).toString());
        }
    }
    else
    {
        ui->label_nombre_extension->setEnabled(consulta.isValid());
        ui->label_nombre_extension->setText(tr("<font color=red><b>%1</b></font>").arg("No hay extension instalada"));
        qDebug()<<"error es "<<consulta.lastError();
    }
}

void DialogoConfiguracion::ComprobarExtensionSuministrada()
{
    QFile file_control(QStringLiteral(":/postgres-extension/sdmed.control"));
    QStringList listado;
    if(file_control.open(QIODevice::ReadOnly))
    {
        QTextStream control(&file_control);
        listado = control.readAll().split('\n');
    }
    for (int i=0;i<listado.size();i++)
    {
        if (listado.at(i).contains("default_version"))
        {
            QString version = listado.at(i).section("'",1,1);
            qDebug()<<"Version instalada: "<<ui->label_version_instalada->text();
            if (m_hayExtension)
            {
                if (version.remove(".") <= ui->label_version_suministrada->text().remove("."))
                {
                    ui->label_version_suministrada->setText(tr("<font color=red><b>%1</b></font>").arg(listado.at(i).section("'",1,1)));
                    ui->boton_instalar_extension->setEnabled(false);
                }
            }
            else
            {
                ui->label_version_suministrada->setText(tr("<font color=green><b>%1</b></font>").arg(listado.at(i).section("'",1,1)));
                ui->boton_instalar_extension->setEnabled(true && ComprobarBotonInstalarExtension());
            }
            break;
        }
    }
}

void DialogoConfiguracion::ComprobarRoleSdmed(QSqlQuery consulta)
{
    ui->label_existe_role_sdmed->setEnabled(m_esDBAdmin);
    ui->boton_crear_role_sdmed->setEnabled(m_esDBAdmin);
    QString cadenaComprobarRole = "SELECT true FROM pg_roles WHERE rolname='sdmed'";
    qDebug()<<cadenaComprobarRole;
    consulta.exec(cadenaComprobarRole);
    m_hayRole = false;
    while (consulta.next())
    {
        m_hayRole = consulta.value(0).toBool();
        qDebug()<<"Consulta hay role= "<<m_hayRole;
    }
    if (!m_hayRole)
    {
        ui->label_existe_role_sdmed->setText(tr("<font color=red><b>%1</b></font>").arg("No existe el role \"sdmed\""));
        ui->boton_crear_role_sdmed->setText(tr("Crear role"));
        m_hayRole = false;
        /*ui->label_existe_role_sdmed->setEnabled(m_esDBAdmin);
        ui->boton_crear_role_sdmed->setEnabled(m_esDBAdmin);*/
    }
    else
    {
        ui->label_existe_role_sdmed->setText(tr("<font color=green><b>%1</b></font>").arg("Existe el role \"sdmed\""));
        ui->boton_crear_role_sdmed->setText(tr("Cambiar contraseña"));
        m_hayRole = true;
        /*ui->label_existe_role_sdmed->setEnabled(m_esDBAdmin);
        ui->boton_crear_role_sdmed->setEnabled(m_esDBAdmin);*/
    }
}

bool DialogoConfiguracion::ComprobarExistenciaBBDDSdmed(QSqlQuery consulta)
{
    QString cadenaComprobarBBDD = "SELECT true FROM pg_database WHERE datname='sdmed'";
    qDebug()<<cadenaComprobarBBDD;
    consulta.exec(cadenaComprobarBBDD);
    m_hayBBDDSdmed = false;
    while (consulta.next())
    {
        m_hayBBDDSdmed = consulta.value(0).toBool();
    }
    if (!m_hayBBDDSdmed)
    {
        ui->label_existe_bbdd_sdmed->setText(tr("No existe la base de datos \"sdmed\""));
        ui->boton_crear_bbdd_sdmed->setText("Crear BBDD");
        ui->label_existe_bbdd_sdmed->setEnabled(true);
        ui->boton_crear_bbdd_sdmed->setEnabled(true);
    }
    else
    {
        ui->label_existe_bbdd_sdmed->setText(tr("<font color=green><b>%1</b></font>").arg("Existe la base de datos \"sdmed\""));
        ui->boton_crear_bbdd_sdmed->setText("...");
        ui->label_existe_bbdd_sdmed->setEnabled(true);
        ui->boton_crear_bbdd_sdmed->setEnabled(false);
        ui->boton_crear_bbdd_sdmed->setVisible(false);        
    }
    return m_hayBBDDSdmed;
}

bool DialogoConfiguracion::CrearRoleContrasenna()
{
    //esta funcion servira para crear el role si no existe y asignar una contrasenna, o solo
    //crear la contrasenna si ya existe el role
    //ademas, si no existia el role sdmed, despues de crearlo le da la propiedad de la base de datos 'sdmd'
    QSqlQuery consulta(*m_dbAdmin);
    QString cadenaRole;
    DialogoContrasenna* d = new DialogoContrasenna(this);
    if (d->exec())
    {
        if (m_hayRole)
        {
            cadenaRole = "ALTER ROLE sdmed WITH PASSWORD '" + d->LeePassword() + "'";
            consulta.exec(cadenaRole);

        }
        else
        {
            cadenaRole = "CREATE ROLE sdmed WITH LOGIN PASSWORD '" + d->LeePassword() + "'";
            consulta.exec(cadenaRole);
            cadenaRole = "ALTER DATABASE \"sdmed\" OWNER TO sdmed";
            consulta.exec(cadenaRole);
        }
        ComprobarRoleSdmed(consulta);
        ActivarLetreros(m_esDBAdmin);
    }
    return consulta.isValid();
}

bool DialogoConfiguracion::CrearBaseDatosSdmed()
{
    //esta funcion crea la bbdd sdmed. Una vez creada, comrpueba si existe el role sdmed
    //en caso afirmativo, le asigna la propiedad de la bbdd.
    QString cadenaCrearBBDD = "CREATE DATABASE sdmed WITH TEMPLATE = template0 ENCODING 'UTF8'";
    qDebug()<<cadenaCrearBBDD;
    QSqlQuery consulta (*m_dbAdmin);
    consulta.exec(cadenaCrearBBDD);
    if (!ComprobarExistenciaBBDDSdmed(consulta))//si no se ha creado salimos de la funcion
    {
        return  false;
    }
    QString cadenaCheckIsRole = "SELECT true FROM pg_roles WHERE rolname='sdmed'";
    qDebug()<<cadenaCheckIsRole;
    consulta.exec(cadenaCheckIsRole);
    while (consulta.next())
    {
        if (consulta.value(0) == true)//si existe el role sdmed
        {
            QString cadenaRole = "ALTER DATABASE \"sdmed\" OWNER TO sdmed"; //asigno la bbdd al role sdmed
            qDebug()<<cadenaRole;
            consulta.exec(cadenaRole);
            ActivarLetreros(m_esDBAdmin);
            return consulta.isValid();
        }
    }
    return false;
}

void DialogoConfiguracion::SetAdmin(bool esadmin)
{
    m_esDBAdmin= esadmin;
}
