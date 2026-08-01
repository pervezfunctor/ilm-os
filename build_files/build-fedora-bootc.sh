#!/usr/bin/env bash

set -ouex pipefail

# Copy optional static files into the image before applying package changes.
if [[ -d "/ctx/system_files" ]]; then
  cp -avf "/ctx/system_files"/. /
fi

# Ensure the COPR plugin is present before enabling third-party repos.
dnf5 install -y 'dnf5-command(copr)'

# Visual Studio Code is not shipped by Fedora. Configure Microsoft's official
# RPM repository before including the `code` package in the desktop install.
rpm --import https://packages.microsoft.com/keys/microsoft.asc
tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# Enable third-party COPRs needed for the niri session and DankMaterialShell.
dnf5 copr enable -y avengemedia/dms
dnf5 copr enable -y yalter/niri

# Install the niri compositor and the rest of the desktop session packages.
dnf5 install -y \
  adw-gtk3-theme \
  adwaita-sans-fonts \
  bat \
  brightnessctl \
  cascadia-code-nf-fonts \
  cascadia-mono-nf-fonts \
  cliphist \
  cmake \
  code \
  cups-pk-helper \
  ddcutil \
  default-fonts \
  default-fonts-core-emoji \
  difftastic \
  direnv \
  distribution-gpg-keys \
  distrobox \
  dms \
  dms-greeter \
  dnsmasq \
  duf \
  eza \
  fastfetch \
  fd \
  fish \
  flatpak \
  fuse \
  fuse-common \
  fwupd \
  fzf \
  gcc \
  gcr \
  gdu \
  gh \
  git \
  gnome-keyring \
  gnome-keyring-pam \
  google-noto-color-emoji-fonts \
  google-noto-emoji-fonts \
  greetd \
  grim \
  guestfs-tools \
  gum \
  gvfs \
  gvfs-fuse \
  gvfs-smb \
  htop \
  imv \
  jq \
  kf6-kimageformats \
  kitty \
  less \
  libatomic \
  libguestfs-tools \
  libosinfo \
  libsecret \
  libvirt \
  libvirt-nss \
  lm_sensors \
  lshw \
  make \
  mate-polkit \
  material-symbols-fonts \
  mpv \
  nautilus \
  ncurses \
  niri \
  osinfo-db \
  osinfo-db-tools \
  pipewire \
  pipewire-gstreamer \
  pipewire-pulseaudio \
  pipx \
  playerctl \
  plocate \
  podman \
  qemu-img \
  qemu-tools \
  qt5ct \
  qt6-qtimageformats \
  qt6-qtmultimedia \
  qt6ct \
  ripgrep \
  rsms-inter-vf-fonts \
  rsync \
  shellcheck \
  shfmt \
  slurp \
  swtpm \
  tar \
  tealdeer \
  tmux \
  trash-cli \
  tuned \
  udiskie \
  udisks2 \
  unzip \
  virt-install \
  virt-manager \
  virt-viewer \
  wireplumber \
  wl-clipboard \
  xdg-desktop-portal-gnome \
  xdg-desktop-portal-gtk \
  zoxide \
  zstd

# Disable the COPRs again so the resulting image does not keep the extra repos.
dnf5 -y copr disable avengemedia/dms || true
dnf5 -y copr disable yalter/niri || true

dnf5 clean all

if systemctl list-unit-files | grep -q '^greetd.service'; then
  systemctl enable greetd.service
else
  echo "greetd.service not found on this base image, skipping enable"
fi
