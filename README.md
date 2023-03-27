MagiskSSH
=========

This is an SSH server running as root using the great Magisk systemless root suite. It includes binaries for arm, arm64, x86, x86_64. However, only arm64 has been tested at all. It requires Android API version 24 or higher (Android 7.0 Nougat and higher).

## Included software

* [OpenSSL 3.1.0](https://www.openssl.org/) (only needed for its libcrypto)
* [OpenSSH 9.3p1](https://www.openssh.com/)
* [Rsync 3.2.7](https://rsync.samba.org/)
* [Magisk Module Installer](https://github.com/topjohnwu/magisk-module-installer)

## Installation

Download the zip file and install it via the Magisk Manager app. Once this module is available in the Magisk module repository, you can just install it from there.

## Configuration

SSH keys can be put into `/data/ssh/root/.ssh/authorized_keys` and `/data/ssh/shell/.ssh/authorized_keys` using your favorite method of editing files.
Note that this file must be owned by the respective user and should have `600` permissions (owner: rw, everyone else: nothing).

The sshd configuration file in `/data/ssh/sshd_config` can be edited as well, but please be aware that some features usually present in an OpenSSH installation may be missing. Most importantly, password login is not possible using this package.

The ssh daemon automatically starts on device boot. If this is undesired, you can create a file `/data/ssh/no-autostart`. It will not start the service then.

## Usage

Once you have written a valid SSH public key into an `authorized_keys` file (see section 'Configuration' above), you can connect to the device using `ssh shell@<device_ip>` (unprivileged access) or `ssh root@<device_ip>` (privileged access), while supplying the correct private key. You will drop into a shell on the device. sftp and rsync should work as usual.

If you want to manually start/stop the sshd-service, you may do so using `/data/adb/modules/ssh/opensshd.init start` and `/data/adb/modules/ssh/opensshd.init stop`. This is usually not necessary but may be useful if you use the `no-autostart` file described earlier.
Note that the `opensshd.init` script may be in a different place on your device. Magisk explicitly does not give any guarantees about the install location and is free to change it.

## Uninstallation

Uninstalling the module via the Magisk Manager should also delete the `/data/ssh` directory.
This contains the host keys for the SSH server and the home directories for the SSH users.
Thus, uninstalling via the Manager should get rid of all traces of this module.

If you wish to keep the runtime data for a later reinstallation of the module, create a file `/data/ssh/KEEP_ON_UNINSTALL` and the uninstaller will skip this step.

## Contributing

Please don't file Pull Requests against the module repository. The module building is an automated process and will overwrite any changes to the files in the module repository.
Feel free to create a Merge Request against the [source repository](https://gitlab.com/d4rcm4rc/MagiskSSH), instead.

## License

[GPL v3](https://gitlab.com/d4rcm4rc/MagiskSSH/blob/master/LICENSE)

## Links

[Source Code Repository](https://gitlab.com/d4rcm4rc/MagiskSSH)

## Changelog

###### 2023-03-26, v0.15

- Version bump.
- OpenSSL 3.1.0
- OpenSSH 9.3p1
- Rsync 3.2.7
- Drop mips and mips64 support
- Build using NDK r25c, simplify building and updating a bit
- Shrink package (strip binaries, use stronger compression)
- Add updateJson mechanism for updating on Magisk v24 and later (thanks tamas646)

###### 2022-02-19, v0.14

- Add uninstaller script (see section 'Uninstallation') (thanks cl-ement05 and osm0sis)
- Use user handles instead of names for credits (thanks osm0sis)
- Ensure correct home directory permissions on install (thanks nazar-pc)
- Put temp files into /data/local/tmp instead of /tmp (thanks F-i-f)

###### 2022-02-19, v0.13

- Version bump.
- OpenSSL 3.0.1
- OpenSSH 8.8p1
- Magisk installer v24.1

###### 2021-04-30, v0.12

- Version bump.
- OpenSSL 1.1.1k
- OpenSSH 8.6p1
- Rsync 3.2.3
- Magisk installer v22.1
- Fix build repository's commit hash bleeding into rsync --version
- Properly set library path for rsync (thanks adorkablue)

###### 2020-07-18, v0.11

- Version bump.
- OpenSSL 1.1.1g
- OpenSSH 8.3p1
- Rsync 3.2.2
- Magisk installer v20.4

###### 2019-11-26, v0.10

- Version bump.
- OpenSSL 1.0.2t
- OpenSSH 8.1p1
- Magisk installer v20.1

###### 2019-04-06, v0.9

- Remove downloading Magisk template, directly include the installer structure instead

###### 2019-03-23, v0.8

- Bugfix.
- Correctly apply permissions to bin/raw files

###### 2019-03-16, v0.7

- Bugfixes.
- Avoid hardcoding MODDIR in opensshd.init
- Use wrapper script for setting LD_LIBRARY_PATH instead of setting it in init script

###### 2019-03-10, v0.6

- Version bump.
- OpenSSL 1.0.2r

###### 2018-11-04, v0.5

- Version bumps (except rsync).
- Set owner and permissions for shell directory
- OpenSSL 1.0.2p
- OpenSSH 7.9p1
- Magisk Module Template v17000

###### 2018-07-16, v0.4

- Derive paths from $MODDIR instead of hardcoding /magisk

###### 2018-04-06, v0.3

- Version bumps.
- Fix sftp rename on filesystems without hardlinks (ie. FAT32)
- OpenSSL 1.0.2o
- OpenSSH 7.7p1
- Rsync 3.1.3
- Magisk Module Template v1500

###### 2017-11-23, v0.2

- Version bumps.
- OpenSSL 1.0.2m
- OpenSSH 7.6p1
- Rsync 3.1.2
- Magisk Module Template v1400

###### 2017-10-03, v0.1

- Initial release.
- OpenSSL 1.0.2l
- OpenSSH 7.5p1
- Rsync 3.1.2
- Magisk Module Template v1400
