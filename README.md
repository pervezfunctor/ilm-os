# ILM OS

ILM OS is a collection of custom [bootc](https://bootc-dev.github.io/bootc/) images for development, virtualization, and everyday desktop use.

| Image | Base | Highlights |
| --- | --- | --- |
| `ilm-os-bazzite-dx-nvidia` | [Bazzite DX](https://bazzite.gg/) | NVIDIA support, developer tools, and virtualization |
| `ilm-os-bluefin-dx` | [Bluefin DX](https://projectbluefin.io/) | Developer workstation with virtualization tools |
| `ilm-os-fedora-bootc` | Fedora Bootc | Niri, DankMaterialShell, developer tools, and virtualization |

## Installation

Install a compatible bootc system, then switch to the image you want. For example, to use the Fedora/Niri image:

```bash
sudo bootc switch ghcr.io/pervezfunctor/ilm-os-fedora-bootc:latest
sudo systemctl reboot
```

Replace `ilm-os-fedora-bootc` with `ilm-os-bazzite-dx-nvidia` or `ilm-os-bluefin-dx` for another variant. Bazzite is recommended for NVIDIA systems.

After rebooting, you can run the optional system setup:

```bash
bash -c "$(curl -fsSL https://is.gd/egitif)" -- ublue
```

For Nix with Home Manager, first mount a dedicated partition or subvolume at `/nix`, then run:

```bash
bash -c "$(curl -fsSL https://is.gd/egitif)" -- bluenix
```

## Building locally

Local builds require Linux, Podman, `just`, and `sudo` access.

```bash
git clone https://github.com/pervezfunctor/ilm-os.git
cd ilm-os
just build-fedora
just build-iso-fedora
```

Replace `fedora` with `bazzite` or `bluefin` to build another variant. Matching QCOW2 recipes are also available, such as `just build-qcow2-fedora`.

Shared local defaults and image metadata are stored in `image-template.env`. Files placed under `system_files/` are copied to the same paths in the image root during every build.

## Automation

GitHub Actions builds and publishes all three container images with `latest`, dated, and immutable commit tags. Published images are rechunked for more reliable updates and signed with Cosign.

The disk-image workflow can create QCOW2 images and installation ISOs for every variant. Outputs can be downloaded as uniquely named workflow artifacts or uploaded to the configured S3 bucket.

Write an ISO to a USB drive with [Fedora Media Writer](https://flathub.org/en/apps/org.fedoraproject.MediaWriter) or a similar tool.
