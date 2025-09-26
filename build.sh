#!/bin/bash

set -ouex pipefail

### Install packages

## Packages can be installed from any enabled yum repo on the image.
## RPMfusion repos are available by default in ublue main images
## List of rpmfusion packages can be found here:
## https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/42/x86_64/repoview/index.html&protocol=https&redirect=1

## VSCode preinstall tasks
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null

# Wazuh Install
curl -o wazuh-agent-4.12.0-1.x86_64.rpm https://packages.wazuh.com/4.x/yum/wazuh-agent-4.12.0-1.x86_64.rpm && sudo WAZUH_MANAGER=$WAZUH_MANAGER_IP rpm -ihv wazuh-agent-4.12.0-1.x86_64.rpm

# Install programs with DNF
dnf5 -y install code python3-tkinter

## Use a COPR Example:
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
## Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File
systemctl daemon-reload
systemctl enable podman.socket
systemctl enable tailscaled
systemctl enable libvirtd
systemctl enable wazuh-agent