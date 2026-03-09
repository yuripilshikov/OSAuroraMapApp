TARGET = ru.template.AuroraMapApp

CONFIG += \
    auroraapp

PKGCONFIG += \

SOURCES += \
    src/main.cpp \

HEADERS += \

DISTFILES += \
    qml/assets/Footprints.qml \
    qml/assets/ValueDisplay.qml \
    qml/pages/MapPage.qml \
    qml/pages/PositioningPage.qml \
    readme.md \
    rpm/ru.template.AuroraMapApp.spec \

AURORAAPP_ICONS = 86x86 108x108 128x128 172x172

CONFIG += auroraapp_i18n

TRANSLATIONS += \
    translations/ru.template.AuroraMapApp.ts \
    translations/ru.template.AuroraMapApp-ru.ts \
