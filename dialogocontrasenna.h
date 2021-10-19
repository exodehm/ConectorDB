#ifndef DIALOGOCONTRASENNA_H
#define DIALOGOCONTRASENNA_H

#include <QDialog>

namespace Ui {
class DialogoContrasenna;
}

class DialogoContrasenna : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoContrasenna(QWidget *parent = nullptr);
    ~DialogoContrasenna();
    QString LeePassword();

public slots:
    void CambiarVisualizacion();

private:
    Ui::DialogoContrasenna *ui;
};

#endif // DIALOGOCONTRASENNA_H
