TARGET = texthandles
QT += qml quick
#QMAKE_INFO_PLIST = Info.plist

SOURCES += \
    $$PWD/main.cpp

OTHER_FILES += \
    $$PWD/main.qml \
    $$PWD/IosSelectionStyle.qml

RESOURCES += \
    texthandles.qrc
