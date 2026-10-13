function switchToOrCreateDesktop(num) {
    print("[DynamicWorkspaces] switchToOrCreateDesktop called for " + num);
    if (num < 1) return;
    while (workspace.desktops.length < num) {
        var nextPos = workspace.desktops.length;
        print("[DynamicWorkspaces] Creating desktop " + (nextPos + 1));
        workspace.createDesktop(nextPos, "" + (nextPos + 1));
    }
    print("[DynamicWorkspaces] Desktops length is now " + workspace.desktops.length);
    if (num <= workspace.desktops.length) {
        var targetDesk = workspace.desktops[num - 1];
        print("[DynamicWorkspaces] Setting currentDesktop to " + (targetDesk ? targetDesk.name : "null"));
        workspace.currentDesktop = targetDesk;
        print("[DynamicWorkspaces] currentDesktop is now " + workspace.currentDesktop.name);
    }
}

function sendWindowToDesktop(num) {
    print("[DynamicWorkspaces] sendWindowToDesktop called for " + num);
    if (num < 1) return;
    while (workspace.desktops.length < num) {
        var nextPos = workspace.desktops.length;
        workspace.createDesktop(nextPos, "" + (nextPos + 1));
    }
    if (num <= workspace.desktops.length) {
        var targetDesk = workspace.desktops[num - 1];
        if (workspace.activeWindow) {
            workspace.activeWindow.desktops = [targetDesk];
        }
        workspace.currentDesktop = targetDesk;
    }
}

for (var i = 1; i <= 9; i++) {
    (function(targetNum) {
        registerShortcut(
            "dynamic_workspace_switch_" + targetNum,
            "Switch or Create Workspace " + targetNum,
            "Meta+" + targetNum,
            function() {
                switchToOrCreateDesktop(targetNum);
            }
        );
        registerShortcut(
            "dynamic_workspace_move_" + targetNum,
            "Move Window to Workspace " + targetNum + " (Dynamic)",
            "Meta+Shift+" + targetNum,
            function() {
                sendWindowToDesktop(targetNum);
            }
        );
    })(i);
}
print("[DynamicWorkspaces] dynamic-workspaces initialized successfully!");
