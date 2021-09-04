#include "conector.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    Conector w;
    w.show();
    return a.exec();
}
