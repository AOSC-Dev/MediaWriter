#!/bin/bash

rm -f mediawriter.pot mediawriter.ts
lupdate-qt6 ../src/app/qml.qrc ../src/app/*.cpp ../src/app/*.h ../src/helper/linux/*.cpp ../src/helper/mac/*.cpp ../src/helper/win/*.cpp -ts mediawriter.ts
lconvert-qt6 -of po -o app.pot mediawriter.ts
xgettext ../src/app/data/io.aosc.MediaWriter.desktop -o desktop.pot
msgcat *.pot > mediawriter.pot
rm app.pot desktop.pot
