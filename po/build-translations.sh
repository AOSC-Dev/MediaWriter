#!/bin/bash

####### App translations
rm -f *.qm

echo -e '<RCC>' > translations.qrc
echo -e '\t<qresource prefix="/translations/">' >> translations.qrc
for i in `ls mediawriter_*.po`; do
    echo $i
    LANGCODE=$(sed 's/mediawriter_\([^.]*\).po/\1/' <<< "$i")
    lrelease-qt5 $i -qm $LANGCODE.qm
    echo -e "\t\t<file>${LANGCODE}.qm</file>" >> translations.qrc
done
echo -e '\t</qresource>' >> translations.qrc
echo -e '</RCC>' >> translations.qrc

####### Appstream metadata
for i in `ls mediawriter_*.po`; do
    echo $i
    LANGCODE=$(sed 's/mediawriter_\([^.]*\).po/\1/' <<< "$i")
    msgfmt $i -o "${LANGCODE}.mo"
done

itstool -i as-metainfo.its -j ../src/app/data/io.aosc.MediaWriter.appdata.xml.in -o ../src/app/data/io.aosc.MediaWriter.appdata.xml *.mo

rm -f *.mo

####### Desktop file
mkdir -p desktop-file
cp -r *.po desktop-file

pushd desktop-file

for i in `ls mediawriter_*.po`; do
    echo $i
    LANGCODE=$(sed 's/mediawriter_\([^.]*\).po/\1/' <<< "$i")
    mv "$i" "$LANGCODE.po"
done

intltool-merge -d . ../../src/app/data/io.aosc.MediaWriter.desktop.in ../../src/app/data/io.aosc.MediaWriter.desktop
popd

rm -rf desktop-file

