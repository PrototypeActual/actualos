#!/bin/bash

set -ouex pipefail

### Install packages

## Packages can be installed from any enabled yum repo on the image.
## RPMfusion repos are available by default in ublue main images
## List of rpmfusion packages can be found here:
## https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

## This will install rpmfusion free/nonfree repos
dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

## VSCodium preinstall tasks
# rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
# printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | tee -a /etc/yum.repos.d/vscodium.repo

## VSCode preinstall tasks
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo > /dev/null

## Tailscale preinstall tasks
wget https://pkgs.tailscale.com/stable/fedora/tailscale.repo -O /etc/yum.repos.d/tailscale.repo

## Install programs with DNF
dnf5 -y copr enable rpmfusion/nonfree
dnf5 -y copr enable rpmfusion/free
dnf5 -y install virt-manager tailscale code discord
dnf5 -y copr disable rpmfusion/nonfree
dnf5 -y copr disable rpmfusion/free
# dnf5 -y remove discover-overlay

# dnf5 -y install virt-manager tailscale codium

# dnf5 -y install python3-tkinter

## Use a COPR Example:
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
## Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable tailscaled
