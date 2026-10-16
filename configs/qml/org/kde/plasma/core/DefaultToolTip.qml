/*
    SPDX-FileCopyrightText: 2013-2015 Sebastian Kügler <sebas@kde.org>
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

/*!
 * Compact layout of a tooltip for sleek Waybar-style panels.
 */
Item {
    id: root
    property Item toolTip
    property int preferredTextWidth: Kirigami.Units.gridUnit * 12

    implicitWidth: mainLayout.implicitWidth + Kirigami.Units.smallSpacing * 2
    implicitHeight: mainLayout.implicitHeight + Kirigami.Units.smallSpacing * 2

    LayoutMirroring.enabled: Application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: false

    RowLayout {
        id: mainLayout
        anchors.centerIn: parent
        anchors.margins: Kirigami.Units.smallSpacing

        spacing: Kirigami.Units.smallSpacing + 2

        Image {
            source: root.toolTip ? root.toolTip.image : ""
            visible: root.toolTip !== null && root.toolTip.image !== ""
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.maximumHeight: Kirigami.Units.iconSizes.smallMedium
            Layout.maximumWidth: Kirigami.Units.iconSizes.smallMedium
            fillMode: Image.PreserveAspectFit
        }

        Kirigami.Icon {
            animated: false
            source: root.toolTip ? root.toolTip.icon : ""
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            visible: root.toolTip !== null && root.toolTip.icon !== "" && root.toolTip.image === "" && valid
            Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
            Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
        }

        ColumnLayout {
            Layout.maximumWidth: root.preferredTextWidth
            spacing: 1

            Kirigami.Heading {
                level: 5
                Layout.fillWidth: true
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                text: root.toolTip ? root.toolTip.mainText : ""
                textFormat: Text.PlainText
                visible: text !== ""
                font.pointSize: 9
            }

            PlasmaComponents.Label {
                Layout.fillWidth: true
                wrapMode: Text.Wrap
                text: root.toolTip ? root.toolTip.subText : ""
                textFormat: root.toolTip ? root.toolTip.textFormat : Text.AutoText
                opacity: 0.8
                visible: text !== ""
                maximumLineCount: 3
                font.pointSize: 8
            }
        }
    }
}
