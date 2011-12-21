From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 0/4] Btrfs: runtime integrity check tool
Date: Wed, 21 Dec 2011 19:17:33 +0100
Message-ID: <cover.1324489705.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Changes v1-v2:
- Merge with updated disk flush code
- Use bdevname to print the bdev's name instead of the disk's name
- Fix v1 formatting issue (labels, and a few casts still had been
  wrong)
- Merge with current scrub.c
- Cast all u64 parameters to unsigned long long for printk
- Fix issue with read errors on lower layers (caused by one
  signed / unsigned mixup)
- Fix comment in check-integrity.c
- Check that data that is referenced from a newly written superblock
  was FLUSHed before
- Change the way the hash keys are calculated
- Add code to runtime integrity check tool that verifies that all
  written meta blocks contain a logical bytenr that maps to the
  device and physical bytenr that is used to submit the bio
- Shrink Kconfig help entry to 14 lines

This patch series adds a new module to the btrfs kernel mode
code. This new module can be used to catch cases when the
btrfs kernel code executes write requests to the disk that
bring the file system in an inconsistent state. In such a
state, a power-loss or kernel panic event would cause that
the data on disk is lost or at least damaged.

Code is added that examines all block write requests during
runtime (including writes of the super block). Three rules
are verified and an error is printed on violation of the
rules:
1. It is not allowed to write a disk block which is
   currently referenced by the super block (either directly
   or indirectly).
2. When a super block is written, it is verified that all
   referenced (directly or indirectly) blocks fulfill the
   following requirements:
   2a. All referenced blocks have either been present when
       the file system was mounted, (i.e., they have been
       referenced by the super block) or they have been
       written since then and the write completion callback
       was called.
   2b. All referenced blocks need to have a generation
       number which is equal to the parent's number.

Before commit v3.1-83-g5ff921b from Chris Mason, the
xfstests 013 and 083 used to trigger integrity issues in the
log tree. Disk blocks that had been in use for the log tree
had been freed and reused too early, while being referenced
by the written super block.

Since this issue with the log tree is fixed, no more issues
with the on-disk file system have been found while running
all currently available xfstests for btrfs and generic.

The search term in the kernel log that can be used to filter
on the existence of detected integrity issues is
"btrfs: attempt".

The integrity check is enabled via mount options. These
mount options are only supported if the integrity check
tool is compiled by defining BTRFS_FS_CHECK_INTEGRITY.

Example #1, apply integrity checks to all metadata:
mount /dev/sdb1 /mnt -o check_int

Example #2, apply integrity checks to all metadata and
to data extents:
mount /dev/sdb1 /mnt -o check_int_data

Example #3, apply integrity checks to all metadata and dump
the tree that the super block references to kernel messages
each time after a super block was written:
mount /dev/sdb1 /mnt -o check_int,check_int_print_mask=263

If the integrity check tool is included and activated in
the mount options, plenty of kernel memory is used, and
plenty of additional CPU cycles are spent. Enabling this
functionality is not intended for normal use. In most
cases, unless you are a btrfs developer who needs to verify
the integrity of (super)-block write requests, do not
enable the config option BTRFS_FS_CHECK_INTEGRITY to
include and compile the integrity check tool.

The patches are based on Chris Mason's v3.1-182-gd85c8a6.

Stefan Behrens (4):
  Btrfs: add optional integrity check code
  Btrfs: add config option to enable btrfs integrity check
  Btrfs: Makefile changes to optionally include btrfs integrity check
  Btrfs: integrate integrity check module into btrfs

 fs/btrfs/Kconfig           |   19 +
 fs/btrfs/Makefile          |    1 +
 fs/btrfs/check-integrity.c | 3068 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/check-integrity.h |   36 +
 fs/btrfs/ctree.h           |    8 +-
 fs/btrfs/disk-io.c         |   26 +-
 fs/btrfs/extent_io.c       |    5 +-
 fs/btrfs/scrub.c           |    5 +-
 fs/btrfs/super.c           |   39 +-
 fs/btrfs/volumes.c         |    7 +-
 10 files changed, 3203 insertions(+), 11 deletions(-)
 create mode 100644 fs/btrfs/check-integrity.c
 create mode 100644 fs/btrfs/check-integrity.h

-- 
1.7.3.4

