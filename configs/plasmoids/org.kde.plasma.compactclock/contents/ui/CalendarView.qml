/*
    SPDX-FileCopyrightText: 2026 Garuda Linux Rice
    SPDX-License-Identifier: GPL-2.0-or-later
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.workspace.calendar as PlasmaCalendar
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami

PlasmaExtras.Representation {
    id: calendar

    readonly property var appletInterface: root

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: false

    Layout.minimumWidth: 220
    Layout.preferredWidth: 225
    Layout.maximumWidth: 260

    Layout.minimumHeight: 220
    Layout.preferredHeight: 225
    Layout.maximumHeight: 260

    collapseMarginsHint: true

    header: Item {
        implicitHeight: 0
    }

    Connections {
        target: root
        function onExpandedChanged() {
            monthView.resetToToday();
        }
    }

    // Compact header row with Previous, Month/Year, Today, Next, Pin
    RowLayout {
        id: topHeader
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 2
            leftMargin: 4
            rightMargin: 4
        }
        height: 28
        spacing: 1

        PlasmaComponents.ToolButton {
            id: prevBtn
            icon.name: Application.layoutDirection === Qt.RightToLeft ? "go-next" : "go-previous"
            display: PlasmaComponents.AbstractButton.IconOnly
            onClicked: monthView.previousView()
            implicitWidth: 24
            implicitHeight: 24
            PlasmaComponents.ToolTip { text: i18n("Previous Month") }
        }

        Kirigami.Heading {
            id: monthTitle
            text: monthView.selectedMonth + " " + monthView.selectedYear
            level: 3
            font.bold: true
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        PlasmaComponents.ToolButton {
            id: nextBtn
            icon.name: Application.layoutDirection === Qt.RightToLeft ? "go-previous" : "go-next"
            display: PlasmaComponents.AbstractButton.IconOnly
            onClicked: monthView.nextView()
            implicitWidth: 24
            implicitHeight: 24
            PlasmaComponents.ToolTip { text: i18n("Next Month") }
        }

        PlasmaComponents.ToolButton {
            id: todayBtn
            icon.name: "go-jump-today"
            display: PlasmaComponents.AbstractButton.IconOnly
            onClicked: monthView.resetToToday()
            implicitWidth: 24
            implicitHeight: 24
            PlasmaComponents.ToolTip { text: i18n("Today") }
        }

        PlasmaComponents.ToolButton {
            id: pinBtn
            icon.name: "window-pin"
            display: PlasmaComponents.AbstractButton.IconOnly
            checkable: true
            checked: Plasmoid.configuration.pin
            onToggled: Plasmoid.configuration.pin = checked
            implicitWidth: 24
            implicitHeight: 24
            PlasmaComponents.ToolTip { text: i18n("Keep Open") }
        }
    }

    // Calendar grid area
    FocusScope {
        id: monthViewWrapper
        anchors {
            top: topHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 2
            leftMargin: 2
            rightMargin: 2
            bottomMargin: 2
        }
        clip: true

        PlasmaCalendar.MonthView {
            id: monthView
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                topMargin: -monthView.viewHeader.height
                bottom: parent.bottom
            }

            borderOpacity: 0.2

            today: root.currentDateTimeInSelectedTimeZone
            firstDayOfWeek: Plasmoid.configuration.firstDayOfWeek > -1
                ? Plasmoid.configuration.firstDayOfWeek
                : Qt.locale().firstDayOfWeek
            showWeekNumbers: false
            showDigitalClockHeader: false
            eventButton: null
        }
    }
}
