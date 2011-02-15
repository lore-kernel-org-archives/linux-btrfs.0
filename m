From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Mon, 14 Feb 2011 22:49:04 -0500
Message-ID: <1297740560-sup-7799@think>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"Linux Btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The master branch of the btrfs unstable tree has some important btrfs
fixes:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

I was seeing very rare metadata corruptions during long stress runs, and
eventually tracked it down to two different races in the btrfs
releasepage code.  One was making btrfs think pages were up to date when
they really weren't and the other lead to corrupted csum fields in
metadata.

Chris Mason (2) commits (+50/-6):
    Btrfs: don't release pages when we can't clear the uptodate bits (+9/-1)
    Btrfs: fix page->private races (+41/-5)

Zheng Yan (1) commits (+1/-0):
    Btrfs: Fix balance panic

Dan Rosenberg (1) commits (+8/-2):
    btrfs: prevent heap corruption in btrfs_ioctl_space_info()

Tsutomu Itoh (1) commits (+7/-3):
    Btrfs: check return value of alloc_extent_map()

Ilya Dryomov (1) commits (+2/-0):
    Btrfs - Fix memory leak in btrfs_init_new_device()

Total: (6) commits (+68/-11)

 fs/btrfs/disk-io.c     |    8 ++++++--
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/extent_io.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/extent_map.c  |    4 ++--
 fs/btrfs/file.c        |    1 +
 fs/btrfs/inode.c       |    3 +++
 fs/btrfs/ioctl.c       |   10 ++++++++--
 fs/btrfs/relocation.c  |    1 +
 fs/btrfs/volumes.c     |    2 ++
 9 files changed, 68 insertions(+), 11 deletions(-)
