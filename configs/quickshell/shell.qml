import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: root

    // System status properties
    property int volume: 100
    property bool isMuted: false
    property int brightness: 100
    property int batteryCapacity: 100
    property string batteryStatus: "Discharging"
    property string wifiSsid: "Offline"

    // Process to poll system status (volume, brightness, battery, wifi)
    Process {
        id: statusProc
        command: ["/home/moonxplor/.local/bin/hypr-status.sh"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim().split("|");
                if (p.length >= 6) {
                    root.volume = parseInt(p[0]) || 0;
                    root.isMuted = p[1] === "true";
                    root.brightness = parseInt(p[2]) || 0;
                    root.batteryCapacity = parseInt(p[3]) || 0;
                    root.batteryStatus = p[4];
                    root.wifiSsid = p[5];
                }
            }
        }
    }

    Timer {
        id: statusTimer
        interval: 2500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!statusProc.running) statusProc.running = true;
        }
    }

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
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 6

            // =============================================================
            // Left: Garuda Eagle Launcher + Workspaces (1 - 7)
            // =============================================================
            RowLayout {
                spacing: 5

                // Official Garuda Eagle Launcher Icon
                Rectangle {
                    width: 28
                    height: 24
                    radius: 6
                    color: "#253438"
                    border.color: "#40a7c080"
                    border.width: 1

                    Image {
                        anchors.centerIn: parent
                        width: 18
                        height: 18
                        source: "/home/moonxplor/Downloads/garuda-theme/icons/garuda-eagle.png"
                        fillMode: Image.PreserveAspectFit
                        smooth: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("exec ~/.local/bin/hypr-launcher.sh")
                    }
                }

                // Workspace Pills Repeater: Dynamically shows open & active workspaces
                Repeater {
                    model: Hyprland.workspaces

                    Rectangle {
                        id: wsBtn
                        required property var modelData

                        visible: modelData && modelData.id > 0
                        property bool isFocused: Hyprland.focusedWorkspace && Hyprland.focusedWorkspace.id === modelData.id
                        property string appLogos: modelData ? root.getAppLogos(modelData.id) : ""
                        
                        implicitWidth: visible ? wsText.implicitWidth + 14 : 0
                        implicitHeight: visible ? 24 : 0
                        height: 24
                        radius: 6
                        color: isFocused ? "#35a7c080" : "transparent"
                        border.color: isFocused ? "#a7c080" : "#30505a"
                        border.width: 1

                        Text {
                            id: wsText
                            anchors.centerIn: parent
                            text: (modelData && modelData.name !== "" ? modelData.name : (modelData ? modelData.id : "")) + wsBtn.appLogos
                            font.family: "JetBrainsMono Nerd Font"
                            font.bold: isFocused
                            font.pixelSize: 12
                            color: isFocused ? "#a7c080" : "#9da9a0"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData && typeof modelData.activate === "function") {
                                    modelData.activate();
                                } else if (modelData) {
                                    Hyprland.dispatch("workspace " + modelData.id);
                                }
                            }
                        }
                    }
                }
            }

            // Expanding Spacer
            Item {
                Layout.fillWidth: true
            }

            // =============================================================
            // Center: Digital Clock & Date Pill
            // =============================================================
            Rectangle {
                implicitWidth: clockText.implicitWidth + 20
                height: 25
                radius: 7
                color: "#253438"
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

            // =============================================================
            // Right: System Tray & Status Icons (Like Plasma 6)
            // =============================================================
            RowLayout {
                spacing: 5

                // 1. Network / WiFi Status Pill
                Rectangle {
                    implicitWidth: wifiRow.implicitWidth + 12
                    height: 24
                    radius: 6
                    color: "#253438"
                    border.color: "#30a7c080"
                    border.width: 1

                    RowLayout {
                        id: wifiRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: root.wifiSsid === "Offline" ? "󰤭" : "󰤨"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                            color: root.wifiSsid === "Offline" ? "#e67e80" : "#a7c080"
                        }

                        Text {
                            text: root.wifiSsid
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#d3c6aa"
                            elide: Text.ElideRight
                            Layout.maximumWidth: 90
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("exec nm-connection-editor")
                    }
                }

                // 2. Bluetooth Pill
                Rectangle {
                    width: 26
                    height: 24
                    radius: 6
                    color: "#253438"
                    border.color: "#30a7c080"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "󰂯"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        color: "#7fbbb3"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("exec blueman-manager")
                    }
                }

                // 3. Audio / Volume Pill
                Rectangle {
                    implicitWidth: volRow.implicitWidth + 12
                    height: 24
                    radius: 6
                    color: "#253438"
                    border.color: "#30a7c080"
                    border.width: 1

                    RowLayout {
                        id: volRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: root.isMuted ? "󰝟" : (root.volume > 60 ? "󰕾" : (root.volume > 20 ? "󰖀" : "󰕿"))
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                            color: root.isMuted ? "#e67e80" : "#a7c080"
                        }

                        Text {
                            text: root.isMuted ? "Muted" : root.volume + "%"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#d3c6aa"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("exec pavucontrol")
                        onWheel: wheel => {
                            if (wheel.angleDelta.y > 0) {
                                Hyprland.dispatch("exec wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+");
                            } else {
                                Hyprland.dispatch("exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-");
                            }
                            statusTimer.restart();
                        }
                    }
                }

                // 4. Brightness Pill
                Rectangle {
                    implicitWidth: brightRow.implicitWidth + 12
                    height: 24
                    radius: 6
                    color: "#253438"
                    border.color: "#30a7c080"
                    border.width: 1

                    RowLayout {
                        id: brightRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: "󰃠"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                            color: "#dbbc7f"
                        }

                        Text {
                            text: root.brightness + "%"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#d3c6aa"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onWheel: wheel => {
                            if (wheel.angleDelta.y > 0) {
                                Hyprland.dispatch("exec brightnessctl set +5%");
                            } else {
                                Hyprland.dispatch("exec brightnessctl set 5%-");
                            }
                            statusTimer.restart();
                        }
                    }
                }

                // 5. Battery Status Pill
                Rectangle {
                    implicitWidth: batRow.implicitWidth + 12
                    height: 24
                    radius: 6
                    color: "#253438"
                    border.color: "#30a7c080"
                    border.width: 1

                    RowLayout {
                        id: batRow
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            text: root.batteryStatus === "Charging" ? "󰂄" : (root.batteryCapacity > 85 ? "󰁹" : (root.batteryCapacity > 60 ? "󰂁" : (root.batteryCapacity > 40 ? "󰁿" : (root.batteryCapacity > 20 ? "󰁽" : "󰁻"))))
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                            color: root.batteryCapacity <= 20 && root.batteryStatus !== "Charging" ? "#e67e80" : "#83c092"
                        }

                        Text {
                            text: root.batteryCapacity + "%"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 11
                            color: "#d3c6aa"
                        }
                    }
                }

                // Separator
                Rectangle {
                    width: 1
                    height: 16
                    color: "#35505a"
                }

                // 6. Terminal Quick Launcher
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

                // 7. File Manager Quick Launcher
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

                // 8. Power / Leave Pill
                Rectangle {
                    width: 26
                    height: 24
                    radius: 6
                    color: "#253438"
                    border.color: "#40e67e80"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "⏻"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        color: "#e67e80"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("exec command -v wlogout >/dev/null && wlogout || hyprctl dispatch exit")
                    }
                }

            }
        }
    }
}
