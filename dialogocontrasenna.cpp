#include "dialogocontrasenna.h"
#include "ui_dialogocontrasenna.h"
#include <QDebug>

DialogoContrasenna::DialogoContrasenna(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoContrasenna)
{
    ui->setupUi(this);
    setFixedSize(this->size());
    QObject::connect(ui->checkBox,SIGNAL(stateChanged(int)),this, SLOT(CambiarVisualizacion()));
}

DialogoContrasenna::~DialogoContrasenna()
{
    delete ui;
}

QString DialogoContrasenna::LeePassword()
{
    return ui->lineEditPassword->text();
}

void DialogoContrasenna::CambiarVisualizacion()
{
    if (ui->checkBox->isChecked())
    {
        ui->lineEditPassword->setEchoMode(QLineEdit::Normal);
    }
    else
    {
        ui->lineEditPassword->setEchoMode(QLineEdit::Password);
    }

}
