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

### Dual-boot (multiple OS on the same pool) support

This hook implements rudimentary support for dual- (or multi-)boot that aims
to do the right thing. The right thing is defined as:

- when booting a particular dataset, only the datasets that belong to the same
  OS are mounted, datasets that belong to other OSes are ignored;
- multiple subhierarchies of datasets can "belong to the same OS" (there is no
  explicit or implicit requirement that all such datasets must be children of
  the bootfs);
- there is no mismatch between the `mountpoint=` property of each dataset and
  its actual mountpoint;
- mounting or remounting any part of the pool during the runtime of the OS
  will not wreck anything;
- fstab is not used or required.

To mark a dataset that "belongs to an OS", set a `dev.sd-zfs:machine-id`
property on it. This property can be set on the roots of multiple dataset
subhierarchies. The datasets that have the same effective value of this
property as the bootfs are considered "part of the same OS". The datasets
that _do not_ have this property are considered "shared" and do not receive
any special handling.

When dual-boot support is in use, a special `zfsalt=` kernel cmdline parameter
may be set to influence handling of datasets that belong to _other_ OSes than
the one being currently booted:

- `zfsalt=ignore` to ignore (not mount) other OS roots (default);
- `zfsalt=/path` to mount other OS roots under `/path/<dev.sd-zfs:machine-id>`.

> [!WARNING]
> The dual-boot support is implemented by statefully adjusting the `canmount`
> and `mountpoint` properties on the participating datasets, and therefore
> must be considered a hack.
