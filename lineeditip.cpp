#include "lineeditip.h"
#include "ui_lineeditip.h"

#include <QRegExpValidator>

LineEditIP::LineEditIP(QWidget *parent) : QWidget(parent), ui(new Ui::LineEditIP)
{
    ui->setupUi(this);
    QString ipRange = "^[0-9]{1,3}$";
    QRegExp ipRegex (ipRange);
    QRegExpValidator *ipValidator = new QRegExpValidator(ipRegex, this);
    ui->lineEditIP->setValidator(ipValidator);
    QObject::connect(ui->lineEditIP, &QLineEdit::editingFinished, [=] () {Validar();});
    //QObject::connect(ui->lineEditIP,SIGNAL(editingFinished()),this,SLOT(Validar()));
}

LineEditIP::~LineEditIP()
{
    delete ui;
}

QString LineEditIP::LeerIP()
{
    return ui->lineEditIP->text();
}

void LineEditIP::Validar()
{
    if (ui->lineEditIP->text().toUInt()>255)
    {
        ui->lineEditIP->setText("");
        ui->mensajeErrorIP->setText("<b>Error en rango de IP</b>");
        ui->lineEditIP->setStyleSheet("QLineEdit {background: rgb(250, 180, 160);}");
        ui->lineEditIP->setFocus();        
    }
    else
    {
        ui->mensajeErrorIP->setText("");
        ui->lineEditIP->setStyleSheet("QLineEdit {background: rgb(255, 255, 255);}");
    }
}
