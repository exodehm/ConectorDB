#ifndef DIALOGOSUDO_H
#define DIALOGOSUDO_H

#include <QDialog>

namespace Ui {
class DialogoSudo;
}

class DialogoSudo : public QDialog
{
    Q_OBJECT

public:
    explicit DialogoSudo(QWidget *parent = nullptr);
    ~DialogoSudo();
    QString PassWSudo();

private:
    Ui::DialogoSudo *ui;
};

#endif // DIALOGOSUDO_H
