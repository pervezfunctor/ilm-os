# ILM OS

I currently base my images on [Bazzite](https://bazzite.gg) and [Bluefin](https://projectbluefin.io). I only include  `virt-install` and a few system utilities. I also allow `nix` installation.

## Setup

First download and install either [Bazzite](https://bazzite.gg) or [Bluefin](https://projectbluefin.io) based on your preferred desktop environment. Bazzite is recommended if you want to use nvidia graphics.

After installation switch to the Bazzite DX Nvidia image with the following command.

```bash
sudo bootc switch ghcr.io/pervezfunctor/ilm-os-bazzite-dx-nvidia:latest
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

You could also clone this repository and build an image or installation ISO yourself. You should have `just` and Podman installed on your Linux system.

```bash
  git clone https://github.com/pervezfunctor/ilm-os
  cd ilm-os
  just build-bazzite
  just build-iso-bazzite
```

Use [Fedora Media Writer](https://flathub.org/en/apps/org.fedoraproject.MediaWriter) or similar to create a bootable usb drive from the iso.

## Image variants

The GitHub Actions matrix keeps the existing published image names and `latest`/date tags:

- `ghcr.io/pervezfunctor/ilm-os-bazzite-dx-nvidia:latest`
- `ghcr.io/pervezfunctor/ilm-os-bluefin-dx:latest`
- `ghcr.io/pervezfunctor/ilm-os-fedora-bootc:latest`

The matching local Just recipes are `build-bazzite`, `build-bluefin`, and `build-fedora`. ISO recipes use the corresponding variant-specific Anaconda configuration: `build-iso-bazzite`, `build-iso-bluefin`, and `build-iso-fedora`.

The disk-image workflow builds both `qcow2` and `anaconda-iso` for all three variants and selects `iso-bazzite.toml`, `iso-bluefin.toml`, or `iso-fedora.toml` for the matching ISO.

## Build configuration and customization

`image-template.env` contains the shared image name, source repository name, tag, metadata, and Bootc Image Builder defaults used by `Justfile`. GitHub Actions overrides the image name, base image, and build script for each matrix entry. The Fedora variant continues to use `build_files/build-fedora-bootc.sh`.

Files placed under `system_files/` are copied into the image root during every variant build. For example, `system_files/etc/example.conf` becomes `/etc/example.conf`; the directory can remain empty when no static overlay is needed.

The publish workflow builds each variant with Just, runs the supported rootful `ostree-rechunk` step, preserves the existing `latest`, date, pull-request, and SHA tag forms, and also adds immutable commit aliases for clean commits. The alternative `chunkah` workflow is available locally with `sudo just rechunk <image> <tag>`.
