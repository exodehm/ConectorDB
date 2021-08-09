#include "dialogosudo.h"
#include "ui_dialogosudo.h"

DialogoSudo::DialogoSudo(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::DialogoSudo)
{
    ui->setupUi(this);
}

DialogoSudo::~DialogoSudo()
{
    delete ui;
}

QString DialogoSudo::PassWSudo()
{
    return ui->lineEdit_passw->text();
}
