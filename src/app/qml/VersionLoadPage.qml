/*
 * AOSC Media Writer
 * Copyright (C) 2025 liushuyu
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 6.6
import QtQuick.Controls 6.6 as QQC2
import QtQuick.Layouts 6.6

Page {
    id: versionLoadPage
    property int prevSource: 0
    nextButtonVisible: false

    text: qsTr("Fetching AOSC Release Data")

    ColumnLayout {
        id: infoColumn
        width: parent.width
        Layout.alignment: Qt.AlignCenter
        
        QQC2.BusyIndicator {
            id: spinner
            Layout.alignment: Qt.AlignCenter
            running: true
        }

        QQC2.Label {
            Layout.alignment: Qt.AlignCenter

            id: messageDownload
            text: qsTr("Please wait while AOSC Media Writer is fetching AOSC OS release information ...")
            wrapMode: QQC2.Label.Wrap
        }

        Connections {
            target: releases
            function onBeingUpdatedChanged() {
                if (!releases.beingUpdated && isUpdated()) {
                    selectedPage += 1
                }
            }
        }
    }

    Item {
        Timer {
            interval: 1500
            repeat: false
            running: true
            onTriggered: {
                console.log(releases.beingUpdated);
                if (!releases.beingUpdated && isUpdated()) {
                    selectedPage += 1
                } else if (!releases.beingUpdated && !isUpdated()) {
                    // Error
                    messageDownload.text = qsTr("Failed to fetch AOSC OS release information. Please try again later.")
                    spinner.running = false
                }
            }
        }
    }


    function isUpdated() {
        return releases.size() > 1;
    }

    onPreviousButtonClicked: selectedPage -= 1
    onNextButtonClicked: selectedPage += 1
}
