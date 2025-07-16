# zfs-utils-initcpio

This is an alternative implementation of the mkinitcpio hooks required to boot
from ZFS (i.e., use a ZFS dataset as rootfs). This implementation supports
systemd-based early userspace (`systemd` mkinitcpio hook).

## Usage

This hook is implemented using shell scripts, thus it still requires busybox
(and several ancillary commands). If the `base` hook is not used (in addition
to `systemd`), this hook will add those binaries to the initcpio.

To use this hook, append `sd-zfs` to your mkinitcpio.conf `HOOKS=()` array.
This hook will do nothing unless a special `root=` kernel command line parameter
is set. Three modes of operation are supported:

  1. `root=zfs`, which imports all pools, searches for the first pool with
      the `bootfs` property set, and then mounts the `bootfs` as root.
  2. `root=zfs:poolname`, which imports the specified pool and then mounts
     the pool's `bootfs` as root.
  3. `root=zfs:poolname/dataset`, which imports the specified pool and then
     mounts the specified dataset as root.

Alternatively, `zfsroot=` parameter may be used with the equivalent semantics.
This is supported to avoid inhibiting systemd-gpt-auto-generator (which might
be useful e.g. to auto-configure LUKS decryption). If you need this generator
to run in the initramfs, replace `root=` with `zfsroot=` in the instruction
above.
