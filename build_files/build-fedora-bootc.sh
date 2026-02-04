#!/usr/bin/env bash

set -ouex pipefail

# Ensure the COPR plugin is present before enabling third-party repos
dnf5 install -y 'dnf5-command(copr)'

# Enable the upstream niri COPR, install the compositor, then disable the repo
# so it is not left enabled in the final image.
dnf5 -y copr enable niri-desktop/niri

# Install the niri compositor and its runtime dependencies
# (pulled in from the COPR enabled above).
dnf5 install -y niri

# Disable the COPR again so the resulting image does not keep the extra repo
dnf5 -y copr disable niri-desktop/niri || true

dnf5 clean all
