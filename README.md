# ILM OS

I currently base my images on [Bazzite](https://bazzite.gg) and [Bluefin](https://projectbluefin.io). I only include  `virt-install` and a few system utilities. I also allow `nix` installation.

## Setup

First download and install either [Bazzite](https://bazzite.gg) or [Bluefin](https://projectbluefin.io) based on your preferred desktop environment. Bazzite is recommended if you want to use nvidia graphics.

After installation switch to my image with the following command.

```bash
sudo bootc switch ghcr.io/pervezfunctor/ilm-os:latest
```

After reboot, run the following to setup basic tools.

```bash
  bash -c "$(curl -fsSL https://is.gd/egitif)" -- ublue
```


Or, if you prefer `nix`, you can install nix along with home-manager.

First you need to create a subvolume or a partition for `/nix` and mount it in `/etc/fstab`.

Once you have done that, run the following to install nix and home-manager.

```bash
  bash -c "$(curl -fsSL https://is.gd/egitif)" -- bluenix
```

You could also clone this repository and build installation iso yourself. You should have `just` installed on your linux system.

```bash
  git clone https://github.com/pervezfunctor/ilm-os
  cd ilm-os
  just build
  just build-iso
```

Use [Fedora Media Writer](https://flathub.org/en/apps/org.fedoraproject.MediaWriter) or similar to create a bootable usb drive from the iso.
