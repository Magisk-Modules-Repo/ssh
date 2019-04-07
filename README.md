MagiskSSH
=========

This is an SSH server running as root using the great Magisk systemless root suite. It includes binaries for arm, arm64, x86, x86_64, mips and mips64. However, only arm64 has been tested at all. It requires Android API version 23 or higher (Android 6.0 Marshmallow and higher).

## Included software

* [OpenSSL 1.0.2r](https://www.openssl.org/) (only needed for its libcrypto)
* [OpenSSH 7.9p1](https://www.openssh.com/)
* [Rsync 3.1.3](https://rsync.samba.org/)
* [Magisk Module Installer](https://github.com/topjohnwu/magisk-module-installer)

## Installation

Download the zip file and install it via the Magisk Manager app. Once this module is available in the Magisk module repository, you can just install it from there.

## Configuration

SSH keys can be put into `/data/ssh/root/.ssh/authorized_keys` and `/data/ssh/shell/.ssh/authorized_keys` using your favorite method of editing files.

The sshd configuration file in `/data/ssh/sshd_config` can be edited as well, but please be aware that some features usually present in an OpenSSH installation may be missing. Most importantly, password login is not possible using this package.

The ssh daemon automatically starts on device boot. If this is undesired, you can create a file `/data/ssh/no-autostart`. It will not start the service then.

## Usage

Once you have written a valid SSH public key into an `authorized_keys` file (see section 'Configuration' above), you can connect to the device using `ssh shell@<device_ip>` (unprivileged access) or `ssh root@<device_ip>` (privileged access), while supplying the correct private key. You will drop into a shell on the device. sftp and rsync should work as usual.

If you want to manually start/stop the sshd-service, you may do so using `/magisk/ssh/opensshd.init start` and `/magisk/ssh/opensshd.init stop`. This is usually not necessary but may be useful if you use the `no-autostart` file described earlier.

## Uninstallation

Uninstalling the module via the Magisk Manager does not fully remove all data that has been installed or created during execution. You may want to delete the `/data/ssh` folder from your device to remove all traces of this module.

## Contributing

Please don't file Pull Requests against the module repository. The module building is an automated process and will overwrite any changes to the files in the module repository.
Feel free to create a Merge Request against the [source repository](https://gitlab.com/d4rcm4rc/MagiskSSH), instead.

## License

[GPL v3](https://gitlab.com/d4rcm4rc/MagiskSSH/blob/master/LICENSE)

## Links

[Source Code Repository](https://gitlab.com/d4rcm4rc/MagiskSSH)

## Changelog

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