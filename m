From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Mon, 13 Dec 2010 20:54:04 -0500
Message-ID: <1292291131-sup-859@think>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The master branch of the btrfs unstable tree:
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has an assortment of bug fixes.  It includes some corruption fixes when
mounting the filesystem in degraded mode, and related oopsen as we try
to mount damaged filesystems.

The async snapshot ioctl added in rc1 is fixed to properly do
synchronous snapshots unless the new async ioctl is used.  It is also
updated to be ready for the readonly snapshot feature we'll add in
2.6.38.

Xin Zhong from Intel pitched in a deadlock during copy_from_user and
Josef has fixes for the new fast caching code and a few other bugs.

Josef Bacik (5) commits (+38/-21):
    Btrfs: do not BUG if we fail to remove the orphan item for dead snapshots (+7/-3)
    Btrfs: do not do fast caching if we are allocating blocks for tree_root (+12/-6)
    Btrfs: fixup return code for btrfs_del_orphan_item (+5/-1)
    Btrfs: deal with space cache errors better (+13/-9)
    Btrfs: fix use after free in O_DIRECT (+1/-2)

Chris Mason (3) commits (+59/-5):
    Btrfs: account for missing devices in RAID allocation profiles (+36/-3)
    Btrfs: prevent RAID level downgrades when space is low (+19/-1)
    Btrfs: EIO when we fail to read tree roots (+4/-1)

Li Zefan (2) commits (+37/-23):
    Btrfs: Make async snapshot ioctl more generic (+36/-22)
    Btrfs: Fix a crash when mounting a subvolume (+1/-1)

Zheng Yan (1) commits (+1/-1):
    Btrfs: Fix page leak in compressed writeback path

Xin Zhong (1) commits (+60/-32):
    Btrfs: pwrite blocked when writing from the mmaped buffer of the same page

Sage Weil (1) commits (+11/-9):
    Btrfs: fix sync subvol/snapshot creation

Jan Beulich (1) commits (+5/-7):
    Btrfs: fix compiler warnings

Total: (14) commits (+211/-98)

 fs/btrfs/disk-io.c          |   11 +++--
 fs/btrfs/extent-tree.c      |   75 +++++++++++++++++++++++++++-------
 fs/btrfs/file.c             |   92 ++++++++++++++++++++++++++++---------------
 fs/btrfs/free-space-cache.c |   12 +++--
 fs/btrfs/inode.c            |   11 ++---
 fs/btrfs/ioctl.c            |   56 ++++++++++++++++----------
 fs/btrfs/ioctl.h            |   14 ++++--
 fs/btrfs/orphan.c           |    6 ++-
 fs/btrfs/super.c            |    2 +-
 fs/btrfs/volumes.c          |   20 +++++++++-
 fs/btrfs/volumes.h          |    2 +
 11 files changed, 207 insertions(+), 94 deletions(-)
