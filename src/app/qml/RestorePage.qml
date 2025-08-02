/*
 * AOSC Media Writer
 * Copyright (C) 2024 Jan Grulich <jgrulich@redhat.com>
 * Copyright (C) 2021-2022 Evžen Gasta <evzen.ml@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is in the hope that it will be useful,
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
    id: restorePage

    text: qsTr("Restore Drive <b>%1</b>").arg(lastRestoreable.name)
    textLevel: 1

    QQC2.Label {
        id: warningText
        visible: lastRestoreable.restoreStatus == Units.RestoreStatus.Contains_Live
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        text: qsTr("<p align=\"justify\"> To reclaim all space available on the drive, it has to be reformatted. All data will be removed.</p> <p align=\"justify\"> Would you like to restore your portable drive?</p>" )
        textFormat: Text.RichText
        wrapMode: QQC2.Label.Wrap
    }

    ColumnLayout {
        id: progress
        visible: lastRestoreable.restoreStatus == Units.RestoreStatus.Restoring

        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true

        QQC2.Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: QQC2.Label.AlignHCenter
            wrapMode: QQC2.Label.Wrap
            text: qsTr("<p align=\"justify\">Restoring your portable drive, please wait…</p>")
        }

        QQC2.ProgressBar {
            id: progressIndicator
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            indeterminate: true
        }
    }

    QQC2.Label {
        id: restoredText
        visible: lastRestoreable.restoreStatus == Units.RestoreStatus.Restored
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        text: qsTr("Your portable drive has been successfully restored!")
        wrapMode: QQC2.Label.Wrap
    }

    QQC2.Label {
        id: errorText
        visible: lastRestoreable.restoreStatus == Units.RestoreStatus.Restore_Error
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        text: qsTr("An error occured while attemptinmg to restore your portable drive. Please try restoring the drive using your system tools.")
        wrapMode: QQC2.Label.Wrap
    }
    
    Component.onCompleted: {
        lastRestoreable = drives.lastRestoreable
    }
    
    states: [
        State {
            name: "restored"
            when: lastRestoreable.restoreStatus == Units.RestoreStatus.Restored
            PropertyChanges {
                target: mainWindow;
                title: qsTr("Restoration Complete")
            }
            StateChangeScript {
                script: drives.lastRestoreable = null
            }
        }
    ]

    previousButtonEnabled: lastRestoreable.restoreStatus != Units.RestoreStatus.Restored &&
                           lastRestoreable.restoreStatus != Units.RestoreStatus.Restoring
    previousButtonVisible: previousButtonEnabled
    onPreviousButtonClicked: {
        selectedPage = Units.Page.MainPage
    }

    nextButtonEnabled: lastRestoreable.restoreStatus == Units.RestoreStatus.Restored ||
                       lastRestoreable.restoreStatus == Units.RestoreStatus.Contains_Live
    nextButtonVisible: lastRestoreable.restoreStatus != Units.RestoreStatus.Restoring
    nextButtonText: lastRestoreable.restoreStatus == Units.RestoreStatus.Restored ? qsTr("Finish") : qsTr("Restore")
    onNextButtonClicked: {
        if (lastRestoreable.restoreStatus == Units.RestoreStatus.Restored)
            selectedPage = Units.Page.MainPage
        else
            drives.lastRestoreable.restore()
    }

}
