<!--
MIT License

Copyright (c) 2023 Sophie Katz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->

# Guide for dev box

Follow these steps to set up a fresh dev box. This is a bare-metal Debian server that is used as a development aid.

## Generate new secrets

Generate a new user password, root password, MOK PEM pass phrase, and [SSH port](https://it-tools.tech/random-port-generator).

> [!NOTE]  
> The PEM phrase should not contain any special characters and should follow this regex: `[a-zA-Z0-9]+`.

![Screenshot of 1Password](1password.png)

## Install Debian

Follow [these instructions](https://www.debian.org/distrib/).

## Run setup

```shell
# Create Code directory
mkdir -p /root/Code

# Enter Code directory
cd /root/Code

# Clone dotfiles
git clone https://github.com/sophie-katz/dotfiles.git

# Enter dotfiles directory
cd dotfiles

# Run setup and follow instructions
bash dev-box/setup.bash
```

## Set up Samba

Follow [these instructions](https://wiki.debian.org/Samba/ServerSimple).

## Install CUDA drivers for deep learning

* Follow [these instructions](https://wiki.debian.org/SecureBoot) to disable secure boot.

* [Install proprietary NVIDIA drivers](https://wiki.debian.org/NvidiaGraphicsDrivers#Identification).

* Confirm that the `nvidia` kernel module is loaded:

  ```shell
  # There should be some results
  lsmod | grep nvidia

  sudo modinfo nvidia_current
  ```

* Smoke test the NVIDIA driver:

  ```shell
  nvidia-smi
  ```

* Install additional CUDA libraries:

  * Go to https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/. This is a list with a bunch of `*.deb` files for various CUDA libraries and tools.

  * Install the latest applicable versions of these:

    * `cuda-cudart-*.deb`

    * `cuda-cupti-*.deb`

    * `cuda-nvcc-*.deb`

    * `cuda-toolkit-*-config-common_*.deb`

  * If there are any missing dependencies:

    * Run `sudo apt --fix-broken install`

    * Install any missing `*.deb` files from the list above as needed.

  * Confirm that only packages for the correct version are installed:

    ```shell
    # Make sure all packages are from only one version
    apt list --installed | grep cuda
    ```

    If there are any from another version, just uninstall them.
