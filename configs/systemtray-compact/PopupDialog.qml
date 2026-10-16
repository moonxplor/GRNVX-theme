/*
    SPDX-FileCopyrightText: 2024 Antigravity / Garuda Theme
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.components as PlasmaComponents3
import org.kde.plasma.extras as PlasmaExtras
import org.kde.kirigami as Kirigami

import org.kde.plasma.workspace.dbus as DBus
import org.kde.plasma.private.displayadjuster as Adjuster

PlasmaExtras.Representation {
    id: dialog

    required property DBus.Properties nightLightControl

    contentItem: PlasmaComponents3.ScrollView {
        id: scrollView
        focus: false

        Column {
            id: brightnessList
            width: scrollView.availableWidth
            spacing: 2

            // --- 1. Brightness Slider (Screen) ---
            Repeater {
                id: screenBrightnessRepeater
                model: screenBrightnessControl.displays

                PlasmaComponents3.ItemDelegate {
                    id: screenBrightnessItem
                    required property int index
                    required property string displayName
                    required property string label
                    required property int brightness
                    required property int maxBrightness

                    width: brightnessList.width
                    topPadding: 2
                    bottomPadding: 2
                    leftPadding: 4
                    rightPadding: 4
                    background.visible: highlighted
                    highlighted: activeFocus
                    hoverEnabled: false

                    contentItem: RowLayout {
                        spacing: Kirigami.Units.smallSpacing

                        Kirigami.Icon {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                            Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                            source: "video-display-brightness"
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Kirigami.Units.smallSpacing

                                PlasmaComponents3.Label {
                                    Layout.fillWidth: true
                                    text: screenBrightnessRepeater.count > 1 ? screenBrightnessItem.label : i18n("Brightness")
                                    textFormat: Text.PlainText
                                    elide: Text.ElideRight
                                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                                }

                                PlasmaComponents3.Label {
                                    Layout.alignment: Qt.AlignRight
                                    text: Math.round(screenBrightnessItem.maxBrightness > 0 ? (screenBrightnessSlider.value / screenBrightnessItem.maxBrightness * 100) : screenBrightnessSlider.value) + "%"
                                    textFormat: Text.PlainText
                                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                                }
                            }

                            PlasmaComponents3.Slider {
                                id: screenBrightnessSlider
                                Layout.fillWidth: true
                                Layout.preferredHeight: 22
                                from: 0
                                to: screenBrightnessItem.maxBrightness
                                stepSize: Math.max(1, screenBrightnessItem.maxBrightness / 100)
                                value: screenBrightnessItem.brightness

                                onMoved: {
                                    screenBrightnessControl.setBrightness(screenBrightnessItem.displayName, Math.round(value))
                                }
                            }
                        }
                    }
                }
            }

            // --- 2. Sharpness Slider ---
            PlasmaComponents3.ItemDelegate {
                id: sharpnessItem
                width: brightnessList.width
                topPadding: 2
                bottomPadding: 2
                leftPadding: 4
                rightPadding: 4
                background.visible: highlighted
                highlighted: activeFocus
                hoverEnabled: false

                contentItem: RowLayout {
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Icon {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                        source: "edit-image"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            PlasmaComponents3.Label {
                                Layout.fillWidth: true
                                text: i18n("Sharpness")
                                textFormat: Text.PlainText
                                elide: Text.ElideRight
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                            }

                            PlasmaComponents3.Label {
                                Layout.alignment: Qt.AlignRight
                                text: Math.round(sharpnessSlider.value) + "%"
                                textFormat: Text.PlainText
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                            }
                        }

                        PlasmaComponents3.Slider {
                            id: sharpnessSlider
                            Layout.fillWidth: true
                            Layout.preferredHeight: 22
                            from: 0
                            to: 100
                            stepSize: 1
                            value: Adjuster.DisplayAdjuster.sharpness

                            onMoved: {
                                Adjuster.DisplayAdjuster.sharpness = Math.round(value)
                            }
                        }
                    }
                }
            }

            // --- 3. Contrast Slider ---
            PlasmaComponents3.ItemDelegate {
                id: contrastItem
                width: brightnessList.width
                topPadding: 2
                bottomPadding: 2
                leftPadding: 4
                rightPadding: 4
                background.visible: highlighted
                highlighted: activeFocus
                hoverEnabled: false

                contentItem: RowLayout {
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Icon {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                        source: "contrast"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            PlasmaComponents3.Label {
                                Layout.fillWidth: true
                                text: i18n("Contrast")
                                textFormat: Text.PlainText
                                elide: Text.ElideRight
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                            }

                            PlasmaComponents3.Label {
                                Layout.alignment: Qt.AlignRight
                                text: Math.round(contrastSlider.value) + "%"
                                textFormat: Text.PlainText
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                            }
                        }

                        PlasmaComponents3.Slider {
                            id: contrastSlider
                            Layout.fillWidth: true
                            Layout.preferredHeight: 22
                            from: 0
                            to: 100
                            stepSize: 1
                            value: Adjuster.DisplayAdjuster.contrast

                            onMoved: {
                                Adjuster.DisplayAdjuster.contrast = Math.round(value)
                            }
                        }
                    }
                }
            }

            // --- 4. Vividness Slider ---
            PlasmaComponents3.ItemDelegate {
                id: vividnessItem
                width: brightnessList.width
                topPadding: 2
                bottomPadding: 2
                leftPadding: 4
                rightPadding: 4
                background.visible: highlighted
                highlighted: activeFocus
                hoverEnabled: false

                contentItem: RowLayout {
                    spacing: Kirigami.Units.smallSpacing

                    Kirigami.Icon {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.preferredWidth: Kirigami.Units.iconSizes.smallMedium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.smallMedium
                        source: "color-management"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            PlasmaComponents3.Label {
                                Layout.fillWidth: true
                                text: i18n("Vividness")
                                textFormat: Text.PlainText
                                elide: Text.ElideRight
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                            }

                            PlasmaComponents3.Label {
                                Layout.alignment: Qt.AlignRight
                                text: Math.round(vividnessSlider.value) + "%"
                                textFormat: Text.PlainText
                                font.pointSize: Kirigami.Theme.smallFont.pointSize
                            }
                        }

                        PlasmaComponents3.Slider {
                            id: vividnessSlider
                            Layout.fillWidth: true
                            Layout.preferredHeight: 22
                            from: 0
                            to: 100
                            stepSize: 1
                            value: Adjuster.DisplayAdjuster.vividness

                            onMoved: {
                                Adjuster.DisplayAdjuster.vividness = Math.round(value)
                            }
                        }
                    }
                }
            }

            // --- 5. Optional Night Light ---
            NightLightItem {
                id: nightLightItem
                width: brightnessList.width
                text: i18n("Night Light")
                nightLightControl: dialog.nightLightControl
                visible: dialog.nightLightControl && dialog.nightLightControl.available
            }

            // --- 6. Optional Theme Toggle ---
            DarkModeItem {
                id: darkModeItem
                width: brightnessList.width
                text: i18n("Theme")
            }
        }
    }
}
