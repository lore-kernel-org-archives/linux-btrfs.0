From: Mat <jackdachef@gmail.com>
Subject: btrfs-progs (unstable) failing to compile successfully
Date: Sat, 28 Aug 2010 13:10:20 +0200
Message-ID: <AANLkTikMDSzNejaEhJdjqxVdiX4GhTuePYnXh4TbhQ2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

when trying to compile btrfs-progs from the unstable repo
(git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstab=
le.git)
via the live-ebuild (on Gentoo)

it keeps on failing for me no matter what (sane) CFLAGS or LDFLAGS I us=
e:

(for reference and completeness I'll also post the ebuild here to find
out if it's a ebuild-related problem):

***********************************************************************=
***********************************************************************=
****


# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/btrfs-progs/btrfs-progs-9999.=
ebuild,v
1.13 2010/04/06 14:46:59 lavajoe Exp $

inherit eutils git

DESCRIPTION=3D"Btrfs filesystem utilities"
HOMEPAGE=3D"http://btrfs.wiki.kernel.org/"
SRC_URI=3D""

LICENSE=3D"GPL-2"
SLOT=3D"0"
KEYWORDS=3D""
IUSE=3D"acl debug-utils"

DEPEND=3D"debug-utils? ( dev-python/matplotlib )
	acl? (
			sys-apps/acl
			sys-fs/e2fsprogs
	)"
RDEPEND=3D"${DEPEND}"

EGIT_REPO_URI=3D"git://git.kernel.org/pub/scm/linux/kernel/git/mason/bt=
rfs-progs-unstable.git"
EGIT_BRANCH=3D"master"

src_unpack() {
	git_src_unpack
	cd "${S}"

	# Fix hardcoded "gcc" and "make"
	sed -i -e 's:gcc $(CFLAGS):$(CC) $(CFLAGS):' Makefile
	sed -i -e 's:make:$(MAKE):' Makefile
}

src_compile() {
	emake CC=3D"$(tc-getCC)" CFLAGS=3D"${CFLAGS}" LDFLAGS=3D"${LDFLAGS}" \
		all || die
	emake CC=3D"$(tc-getCC)" CFLAGS=3D"${CFLAGS}" LDFLAGS=3D"${LDFLAGS}" \
		btrfstune btrfs-image || die
	if use acl; then
		emake CC=3D"$(tc-getCC)" CFLAGS=3D"${CFLAGS}" LDFLAGS=3D"${LDFLAGS}" =
\
			convert || die
	fi
}

src_install() {
	into /
	dosbin btrfs-show
	dosbin btrfs-vol
	dosbin btrfsctl
	dosbin btrfsck
	dosbin btrfstune
	dosbin btrfs-image
	dosbin btrfs
	# fsck will segfault if invoked at boot, so do not make this link
	#dosym btrfsck /sbin/fsck.btrfs
	newsbin mkfs.btrfs mkbtrfs
	dosym mkbtrfs /sbin/mkfs.btrfs
	if use acl; then
		dosbin btrfs-convert
	else
		ewarn "Note: btrfs-convert not built/installed (requires acl USE flag=
)"
	fi

	if use debug-utils; then
		dobin btrfs-debug-tree
	else
		ewarn "Note: btrfs-debug-tree not installed (requires debug-utils USE=
 flag)"
	fi

	into /usr
	newbin bcp btrfs-bcp

	if use debug-utils; then
		newbin show-blocks btrfs-show-blocks
	else
		ewarn "Note: btrfs-show-blocks not installed (requires debug-utils US=
E flag)"
	fi

	dodoc INSTALL
	emake prefix=3D"${D}/usr/share" install-man
}

pkg_postinst() {
	ewarn "WARNING: This version of btrfs-progs uses the latest unstable c=
ode,"
	ewarn "         and care should be taken that it is compatible with th=
e"
	ewarn "         version of btrfs in your kernel!"
}


***********************************************************************=
***********************************************************************=
****

USE=3D"-debug-utils -acl" CFLAGS=3D"-O2 -march=3Dcore2 -mtune=3Dcore2 -=
pipe"
CXXFLAGS=3D"${CFLAGS}"


in the beginning I first suspected that it failed due to hardened
toolchain (it's using RELRO, fPIE, fPIC and -D_FORTIFY_SOURCE=3D2 if I
remember correctly) but switching to the
vanilla-behavior of gcc and disabling fortify via -U_FORTIFY_SOURCE &
the default gentoo LDFLAGS also didn't help:


***********************************************************************=
***********************************************************************=
****

>>> Emerging (1 of 1) sys-fs/btrfs-progs-9999
* CPV: sys-fs/btrfs-progs-9999
* REPO: gentoo
* USE: amd64 elibc_glibc kernel_linux multilib userland_GNU
>>> Unpacking source...
* GIT update -->
* repository: git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs=
-progs-unstable.git
* at the commit: 075587c96c2f39e227847d13ca0ef305b13cd7d3
* branch: master
* storage directory: "/home/distfiles/git-src/btrfs-progs"
Cloning into /var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-=
9999...
done.
>>> Unpacked to /var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-pro=
gs-9999
>>> Source unpacked in /var/tmp/portage/sys-fs/btrfs-progs-9999/work
>>> Compiling source in /var/tmp/portage/sys-fs/btrfs-progs-9999/work/b=
trfs-progs-9999 ...
make -j9 CC=3Dx86_64-pc-linux-gnu-gcc 'CFLAGS=3D-O2 -march=3Dcore2
-mtune=3Dcore2 -pipe' 'LDFLAGS=3D-Wl,-O1 -Wl,--as-needed' all
bash version.sh
ls ctree.c
ls disk-io.c
ls radix-tree.c
ctree.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.ctree.o.d,-MT,ctree.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c ctree.c
disk-io.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.disk-io.o.d,-MT,disk-io.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c disk-io.c
radix-tree.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.radix-tree.o.d,-MT,radix-tree.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c radix-tree.c
ls extent-tree.c
ls print-tree.c
ls root-tree.c
extent-tree.c
print-tree.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.extent-tree.o.d,-MT,extent-tree.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c extent-tree.c
root-tree.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.print-tree.o.d,-MT,print-tree.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c print-tree.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.root-tree.o.d,-MT,root-tree.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c root-tree.c
ls dir-item.c
ls file-item.c
dir-item.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.dir-item.o.d,-MT,dir-item.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c dir-item.c
file-item.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.file-item.o.d,-MT,file-item.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c file-item.c
ls inode-item.c
inode-item.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.inode-item.o.d,-MT,inode-item.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c inode-item.c
ls inode-map.c
inode-map.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.inode-map.o.d,-MT,inode-map.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c inode-map.c
ls crc32c.c
crc32c.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.crc32c.o.d,-MT,crc32c.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c crc32c.c
ls rbtree.c
rbtree.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.rbtree.o.d,-MT,rbtree.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c rbtree.c
ls extent-cache.c
extent-cache.c
x86_64-pc-linux-gnu-gcc
-Wp,-MMD,./.extent-cache.o.d,-MT,extent-cache.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c extent-cache.c
ls extent_io.c
extent_io.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.extent_io.o.d,-MT,extent_io.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c extent_io.c
ls volumes.c
volumes.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.volumes.o.d,-MT,volumes.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c volumes.c
ls utils.c
utils.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.utils.o.d,-MT,utils.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c utils.c
ls btrfs-list.c
btrfs-list.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.btrfs-list.o.d,-MT,btrfs-list.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c btrfs-list.c
ls btrfsctl.c
btrfsctl.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.btrfsctl.o.d,-MT,btrfsctl.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c btrfsctl.c
ls mkfs.c
ls debug-tree.c
mkfs.c
debug-tree.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.mkfs.o.d,-MT,mkfs.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c mkfs.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.debug-tree.o.d,-MT,debug-tree.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c debug-tree.c
ls btrfs-show.c
btrfs-show.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.btrfs-show.o.d,-MT,btrfs-show.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c btrfs-show.c
ls btrfs-vol.c
btrfs-vol.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.btrfs-vol.o.d,-MT,btrfs-vol.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c btrfs-vol.c
ls btrfsck.c
btrfsck.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.btrfsck.o.d,-MT,btrfsck.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c btrfsck.c
ls btrfs.c
btrfs.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.btrfs.o.d,-MT,btrfs.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c btrfs.c
ls btrfs_cmds.c
btrfs_cmds.c
x86_64-pc-linux-gnu-gcc -Wp,-MMD,./.btrfs_cmds.o.d,-MT,btrfs_cmds.o
-Wall -D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c btrfs_cmds.c
ls btrfs-map-logical.c
btrfs-map-logical.c
x86_64-pc-linux-gnu-gcc
-Wp,-MMD,./.btrfs-map-logical.o.d,-MT,btrfs-map-logical.o -Wall
-D_FILE_OFFSET_BITS=3D64 -D_FORTIFY_SOURCE=3D2 -O2 -march=3Dcore2
-mtune=3Dcore2 -pipe -c btrfs-map-logical.c
cd man; make
make[1]: Entering directory
`/var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-9999/man'
gzip -n -c mkfs.btrfs.8.in > mkfs.btrfs.8.gz
gzip -n -c btrfsctl.8.in > btrfsctl.8.gz
gzip -n -c btrfsck.8.in > btrfsck.8.gz
gzip -n -c btrfs-image.8.in > btrfs-image.8.gz
gzip -n -c btrfs-show.8.in > btrfs-show.8.gz
gzip -n -c btrfs.8.in > btrfs.8.gz
make[1]: Leaving directory
`/var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-9999/man'
btrfsck.c: In function =91maybe_free_inode_rec=92:
btrfsck.c:323:2: warning: implicit declaration of function =91S_ISDIR=92
btrfsck.c:328:2: warning: implicit declaration of function =91S_ISREG=92
btrfsck.c:328:2: warning: implicit declaration of function =91S_ISLNK=92
x86_64-pc-linux-gnu-gcc -O2 -march=3Dcore2 -mtune=3Dcore2 -pipe -o
btrfsctl btrfsctl.o ctree.o disk-io.o radix-tree.o extent-tree.o
print-tree.o root-tree.o dir-item.o file-item.o inode-item.o
inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o
utils.o btrfs-list.o -Wl,-O1 -Wl,--as-needed -luuid
x86_64-pc-linux-gnu-gcc -O2 -march=3Dcore2 -mtune=3Dcore2 -pipe -o
mkfs.btrfs ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o
root-tree.o dir-item.o file-item.o inode-item.o inode-map.o crc32c.o
rbtree.o extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o
mkfs.o -Wl,-O1 -Wl,--as-needed -luuid
x86_64-pc-linux-gnu-gcc -O2 -march=3Dcore2 -mtune=3Dcore2 -pipe -o
btrfs-debug-tree ctree.o disk-io.o radix-tree.o extent-tree.o
print-tree.o root-tree.o dir-item.o file-item.o inode-item.o
inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o
utils.o btrfs-list.o debug-tree.o -Wl,-O1 -Wl,--as-needed -luuid
x86_64-pc-linux-gnu-gcc -O2 -march=3Dcore2 -mtune=3Dcore2 -pipe -o
btrfs-show btrfs-show.o ctree.o disk-io.o radix-tree.o extent-tree.o
print-tree.o root-tree.o dir-item.o file-item.o inode-item.o
inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o
utils.o btrfs-list.o -Wl,-O1 -Wl,--as-needed -luuid
x86_64-pc-linux-gnu-gcc -O2 -march=3Dcore2 -mtune=3Dcore2 -pipe -o
btrfs-vol btrfs-vol.o ctree.o disk-io.o radix-tree.o extent-tree.o
print-tree.o root-tree.o dir-item.o file-item.o inode-item.o
inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o
utils.o btrfs-list.o -Wl,-O1 -Wl,--as-needed -luuid
x86_64-pc-linux-gnu-gcc -O2 -march=3Dcore2 -mtune=3Dcore2 -pipe -o btrf=
s
btrfs.o btrfs_cmds.o \
ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o root-tree.o
dir-item.o file-item.o inode-item.o inode-map.o crc32c.o rbtree.o
extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o -Wl,-O1
-Wl,--as-needed -luuid
x86_64-pc-linux-gnu-gcc -O2 -march=3Dcore2 -mtune=3Dcore2 -pipe -o
btrfs-map-logical ctree.o disk-io.o radix-tree.o extent-tree.o
print-tree.o root-tree.o dir-item.o file-item.o inode-item.o
inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o volumes.o
utils.o btrfs-list.o btrfs-map-logical.o -Wl,-O1 -Wl,--as-needed
-luuid
x86_64-pc-linux-gnu-gcc -O2 -march=3Dcore2 -mtune=3Dcore2 -pipe -o btrf=
sck
btrfsck.o ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o
root-tree.o dir-item.o file-item.o inode-item.o inode-map.o crc32c.o
rbtree.o extent-cache.o extent_io.o volumes.o utils.o btrfs-list.o
-Wl,-O1 -Wl,--as-needed -luuid
btrfsck.o: In function `maybe_free_inode_rec':
btrfsck.c.text+0x1306): undefined reference to `S_ISDIR'
btrfsck.c.text+0x1333): undefined reference to `S_ISREG'
btrfsck.c.text+0x13fb): undefined reference to `S_ISREG'
btrfsck.c.text+0x1462): undefined reference to `S_ISLNK'
btrfsck.c.text+0x1491): undefined reference to `S_ISLNK'
collect2: ld returned 1 exit status
make: *** [btrfsck] Error 1
emake failed
* ERROR: sys-fs/btrfs-progs-9999 failed:
* (no error message)
*
* Call stack:
* ebuild.sh, line 47: Called src_compile
* environment, line 2569: Called die
* The specific snippet of code:
* emake CC=3D"$(tc-getCC)" CFLAGS=3D"${CFLAGS}" LDFLAGS=3D"${LDFLAGS}" =
all || die;
*
* If you need support, post the output of 'emerge --info
=3Dsys-fs/btrfs-progs-9999',
* the complete build log and the output of 'emerge -pqv
=3Dsys-fs/btrfs-progs-9999'.
* The complete build log is located at
'/var/log/portage/sys-fs:btrfs-progs-9999:20100828-102852.log'.
* The ebuild environment file is located at
'/var/tmp/portage/sys-fs/btrfs-progs-9999/temp/environment'.
* S: '/var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-9999'

>>> Failed to emerge sys-fs/btrfs-progs-9999, Log file:

>>> '/var/log/portage/sys-fs:btrfs-progs-9999:20100828-102852.log'

* Messages for package sys-fs/btrfs-progs-9999:

* GIT update -->
* repository: git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs=
-progs-unstable.git
* at the commit: 075587c96c2f39e227847d13ca0ef305b13cd7d3
* branch: master
* storage directory: "/home/distfiles/git-src/btrfs-progs"
* ERROR: sys-fs/btrfs-progs-9999 failed:
* (no error message)
*
* Call stack:
* ebuild.sh, line 47: Called src_compile
* environment, line 2569: Called die
* The specific snippet of code:
* emake CC=3D"$(tc-getCC)" CFLAGS=3D"${CFLAGS}" LDFLAGS=3D"${LDFLAGS}" =
all || die;
*
* If you need support, post the output of 'emerge --info
=3Dsys-fs/btrfs-progs-9999',
* the complete build log and the output of 'emerge -pqv
=3Dsys-fs/btrfs-progs-9999'.
* The complete build log is located at
'/var/log/portage/sys-fs:btrfs-progs-9999:20100828-102852.log'.
* The ebuild environment file is located at
'/var/tmp/portage/sys-fs/btrfs-progs-9999/temp/environment'.
* S: '/var/tmp/portage/sys-fs/btrfs-progs-9999/work/btrfs-progs-9999'
*
* The following package has failed to build or install:
*
* (sys-fs/btrfs-progs-9999, ebuild scheduled for merge), Log file:
* '/var/log/portage/sys-fs:btrfs-progs-9999:20100828-102852.log'
*

Many thanks in advance for your support & thanks a lot for your work on=
 btrfs !

Mat
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
