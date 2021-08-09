#ifndef LINEEDITIP_H
#define LINEEDITIP_H

#include <QWidget>

namespace Ui {
class LineEditIP;
}

class LineEditIP : public QWidget
{
    Q_OBJECT

public:
    explicit LineEditIP(QWidget *parent = nullptr);
    ~LineEditIP();
    QString LeerIP();

private:
    Ui::LineEditIP *ui;

private slots:
    void Validar();
};

#endif // LINEEDITIP_H
