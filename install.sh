##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=false

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=true

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################

# Set what you want to display when installing your module

print_modname() {
  ui_print "*******************************"
  ui_print "      OpenSSH for Android      "
  ui_print "*******************************"
}

# Copy/extract your module files into $MODPATH in on_install.

on_install() {
  local TMPDIR="$MODPATH/tmp"
  ui_print "[0/7] Preparing module directory"
  mkdir -p "$TMPDIR"
  mkdir -p "$MODPATH/usr/bin/raw"

  ui_print "[1/7] Extracting architecture unspecific module files"
  unzip -o "$ZIPFILE" 'common/opensshd.init' -d "$MODPATH/tmp" >&2
  unzip -o "$ZIPFILE" 'common/magisk_ssh_library_wrapper' -d "$MODPATH/tmp" >&2
  mv "$TMPDIR/common/opensshd.init" "$MODPATH"
  mv "$TMPDIR/common/magisk_ssh_library_wrapper" "$MODPATH/usr/bin/raw"

  ui_print "[2/7] Extracting libraries and binaries for $ARCH"
  unzip -o "$ZIPFILE" "arch/$ARCH/*" -d "$TMPDIR" >&2
  mv "$TMPDIR/arch/$ARCH/lib" "$MODPATH/usr"
  mv "$TMPDIR/arch/$ARCH/bin"/* "$MODPATH/usr/bin"

  ui_print "[3/7] Configuring library path wrapper"
  for f in scp sftp sftp-server ssh ssh-keygen sshd rsync; do
    mv "$MODPATH/usr/bin/$f" "$MODPATH/usr/bin/raw/$f"
    ln -s ./raw/magisk_ssh_library_wrapper "$MODPATH/usr/bin/$f"
  done

  ui_print "[4/6] Creating SSH user directories"
  mkdir -p /data/ssh
  mkdir -p /data/ssh/root/.ssh
  mkdir -p /data/ssh/shell/.ssh

  if [ -f /data/ssh/sshd_config ]; then
    ui_print "[5/6] Found sshd_config, will not copy a default one"
  else
    ui_print "[5/6] Extracting sshd_config"
    unzip -o "$ZIPFILE" 'common/sshd_config' -d "$TMPDIR" >&2
    mv "$TMPDIR/common/sshd_config" '/data/ssh/'
  fi

  ui_print "[6/6] Cleaning up"
  rm -rf "$TMPDIR"
}

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644

  set_perm_recursive "$MODPATH/usr/bin" 0 0 0755 0755
  set_perm "$MODPATH/opensshd.init" 0 0 0755
  set_perm /data/ssh/sshd_config 0 0 0600
  chown shell:shell /data/ssh/shell
  chown shell:shell /data/ssh/shell/.ssh
  chown root:root /data/ssh/root
  chown root:root /data/ssh/root/.ssh
  chmod 700 /data/ssh/{shell,root}
  chmod 700 /data/ssh/{shell,root}/.ssh
}

# You can add more functions to assist your custom script code
