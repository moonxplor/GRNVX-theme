import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    // Function to dynamically get open application logos for each workspace
    function getAppLogos(wsId) {
        try {
            if (!Hyprland.clients || !Hyprland.clients.values) return "";
            var icons = [];
            var seen = {};
            for (var i = 0; i < Hyprland.clients.values.length; i++) {
                var client = Hyprland.clients.values[i];
                if (client && client.workspace && client.workspace.id === wsId) {
                    var cls = (client.class || "").toLowerCase();
                    var icon = "";
                    if (cls.indexOf("kitty") !== -1) icon = "󰄛";
                    else if (cls.indexOf("discord") !== -1) icon = "󰙯";
                    else if (cls.indexOf("brave") !== -1 || cls.indexOf("firefox") !== -1 || cls.indexOf("browser") !== -1) icon = "󰈹";
                    else if (cls.indexOf("thunar") !== -1) icon = "󰉋";
                    else if (cls.indexOf("code") !== -1) icon = "󰆍";
                    else if (cls.indexOf("telegram") !== -1 || cls.indexOf("whatsapp") !== -1) icon = "󰖣";
                    else if (cls.indexOf("spotify") !== -1) icon = "󰓇";
                    else icon = "󰖲";

                    if (icon && !seen[icon]) {
                        seen[icon] = true;
                        icons.push(icon);
                    }
                }
            }
            return icons.length > 0 ? " " + icons.join(" ") : "";
        } catch (e) {
            return "";
        }
    }
    
    // Top bar positioning
    anchors {
        top: true
        left: true
        right: true
    }
    
    implicitHeight: 38
    exclusiveZone: 38
    color: "transparent"

    // Floating Glass Pill Container
    Rectangle {
        id: barPill
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 2
        anchors.leftMargin: 8
        anchors.rightMargin: 8

        color: "#c0232a2e" // Everforest dark translucent
        radius: 12
        border.color: "#60a7c080" // Soft green accent border
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 8

            // -------------------------------------------------------------
            // Left: Workspaces (1 - 7 with Icons)
            // -------------------------------------------------------------
            RowLayout {
                spacing: 4

                // Garuda Logo Launcher
                Rectangle {
                    width: 28
                    height: 24
                    radius: 6
                    color: "#30a7c080"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "󰣇"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 15
                        color: "#a7c080"
                    }
                }

                // Workspace Pills Repeater: Numbers + Dynamic App Logos
                Repeater {
                    model: [1, 2, 3, 4, 5, 6, 7]

                    Rectangle {
                        id: wsBtn
                        property bool isFocused: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === modelData
                        property string appLogos: root.getAppLogos(modelData)
                        
                        implicitWidth: wsText.implicitWidth + 14
                        height: 24
                        radius: 6
                        color: isFocused ? "#35a7c080" : "transparent"
                        border.color: isFocused ? "#a7c080" : "#30505a"
                        border.width: 1

                        Text {
                            id: wsText
                            anchors.centerIn: parent
                            text: modelData + wsBtn.appLogos
                            font.family: "JetBrainsMono Nerd Font"
                            font.bold: isFocused
                            font.pixelSize: 12
                            color: isFocused ? "#a7c080" : "#9da9a0"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Hyprland.dispatch("workspace " + modelData)
                            }
                        }
                    }
                }
            }

            // Expanding Spacer
            Item {
                Layout.fillWidth: true
            }

            // -------------------------------------------------------------
            // Center: Digital Clock & Date Pill
            // -------------------------------------------------------------
            Rectangle {
                implicitWidth: clockText.implicitWidth + 24
                height: 26
                radius: 8
                color: "#283439"
                border.color: "#40a7c080"
                border.width: 1

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: {
                        var now = new Date();
                        clockText.text = "󱎫 " + Qt.formatDateTime(now, "h:mm AP") + "   󰃭 " + Qt.formatDateTime(now, "MMM d");
                    }
                }

                Text {
                    id: clockText
                    anchors.centerIn: parent
                    text: {
                        var now = new Date();
                        return "󱎫 " + Qt.formatDateTime(now, "h:mm AP") + "   󰃭 " + Qt.formatDateTime(now, "MMM d");
                    }
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#d3c6aa"
                }
            }

            // Expanding Spacer
            Item {
                Layout.fillWidth: true
            }

            // -------------------------------------------------------------
            // Right: System Actions & Window Close
            // -------------------------------------------------------------
            RowLayout {
                spacing: 6

                // Terminal Quick Action
                Rectangle {
                    width: 26
                    height: 24
                    radius: 6
                    color: "#253438"

                    Text {
                        anchors.centerIn: parent
                        text: "󰄛" // Kitty icon
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        color: "#a7c080"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("exec kitty")
                    }
                }

                // File Manager Quick Action
                Rectangle {
                    width: 26
                    height: 24
                    radius: 6
                    color: "#253438"

                    Text {
                        anchors.centerIn: parent
                        text: "󰉋" // Thunar folder icon
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        color: "#83c092"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("exec thunar")
                    }
                }

                // Close Window (Right Corner)
                Rectangle {
                    width: 26
                    height: 24
                    radius: 6
                    color: "#35e67e80"
                    border.color: "#e67e80"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        font.bold: true
                        color: "#e67e80"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("killactive")
                    }
                }
            }
        }
    }
}
