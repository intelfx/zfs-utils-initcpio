# Maintainer: Ivan Shapovalov <intelfx@intelfx.name>

pkgname=zfs-utils-initcpio
pkgver=r1
pkgrel=1
pkgdesc='(Better) ZFS integration for systemd-based initcpio (sd-zfs hook)'
arch=(any)
url='https://openzfs.org/'
license=(MIT)
depends=(
	systemd
	mkinitcpio
	zfs-utils
)
makedepends=(
	git
)
conflicts=(
	mkinitcpio-sd-zfs
)
source=(
	zfs-functions
	zfs-parse-cmdline
	zfs-parse-zfsget
	zfs-prepare-rootfs
	zfs-prepare-multiboot
	zfs-prepare-cache
	zfs-root-generator
	zfs-listp
	sd-zfs.initcpio.install
	sd-zfs-shutdown.initcpio.install
	zfs.shutdown
	zfs.mkinitcpio-generate-shutdown-ramfs.conf
)
sha256sums=('SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP')

pkgver() {
	cd "$startdir"
	printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
	install -Dvm644 "${srcdir}"/zfs-functions \
		-t "${pkgdir}/usr/lib/zfs/initcpio"
	install -Dvm755 "${srcdir}"/{zfs-parse-*,zfs-prepare-*,zfs-root-generator} \
		-t "${pkgdir}/usr/lib/zfs/initcpio"
	install -Dvm644 "${srcdir}/sd-zfs.initcpio.install" \
		"${pkgdir}/usr/lib/initcpio/install/sd-zfs"
	install -Dvm644 "${srcdir}/sd-zfs-shutdown.initcpio.install" \
		"${pkgdir}/usr/lib/initcpio/install/sd-zfs-shutdown"
	install -Dvm755 "${srcdir}/zfs.shutdown" \
		"${pkgdir}/usr/lib/systemd/system-shutdown/zfs"
	install -Dvm755 "${srcdir}"/zfs-listp \
		-t "${pkgdir}/usr/lib/zfs/initcpio"

	# TODO: rework this once mkinitcpio!373 and/or mkinitcpio!389 lands
	install -Dvm644 "${srcdir}/zfs.mkinitcpio-generate-shutdown-ramfs.conf" \
		"${pkgdir}/usr/lib/systemd/system/mkinitcpio-generate-shutdown-ramfs.service.d/zfs.conf"
}

# vim: ft=PKGBUILD ts=8 noet:
