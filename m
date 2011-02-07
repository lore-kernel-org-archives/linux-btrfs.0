From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Mon, 07 Feb 2011 15:12:27 -0500
Message-ID: <1297106906-sup-3@think>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

This pull was delayed by a week because my test rig kept throwing out
corruptions.  After a long series of bisects, it looks like the hardware
is just silently corrupting blocks and btrfs is catching it early and
often.

So, here is our collection of bug fixes since rc1.  We have an
assortment of ENOSPC tweaks, allocator fixes  and better error handling
in general.

Linus please pull the master branch of the btrfs-unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Li Zefan (8) commits (+107/-65):
    btrfs: Fix threshold calculation for block groups smaller than 1GB (+6/-2)
    btrfs: Check mergeable free space when removing a cluster (+20/-6)
    btrfs: Update stats when allocating from a cluster (+14/-3)
    Btrfs: Fix file clone when source offset is not 0 (+4/-1)
    btrfs: Add a helper try_merge_free_space() (+43/-32)
    btrfs: Free fully occupied bitmap in cluster (+2/-0)
    btrfs: Add helper function free_bitmap() (+16/-21)
    Btrfs: Fix memory leak at umount (+2/-0)

Josef Bacik (8) commits (+86/-18):
    Btrfs: do not release more reserved bytes to the global_block_rsv than we need (+14/-2)
    Btrfs: make sure search_bitmap finds something in remove_from_bitmap (+1/-0)
    Btrfs: use the global block reserve if we cannot reserve space (+27/-1)
    Btrfs: fix check_path_shared so it returns the right value (+3/-2)
    Btrfs: exclude super blocks when we read in block groups (+18/-8)
    Btrfs: handle no memory properly in prepare_pages (+6/-2)
    Btrfs: make shrink_delalloc a little friendlier (+14/-3)
    Btrfs: do error checking in btrfs_del_csums (+3/-0)

Tsutomu Itoh (5) commits (+100/-21):
    btrfs: check return value of btrfs_start_ioctl_transaction() properly (+1/-1)
    btrfs: fix return value check of btrfs_start_transaction() (+37/-6)
    btrfs: fix return value check of btrfs_join_transaction() (+51/-13)
    btrfs: cleanup error handling in btrfs_unlink_inode() (+1/-1)
    btrfs: checking NULL or not in some functions (+10/-0)

liubo (3) commits (+59/-4):
    btrfs: fix uncheck memory allocation in btrfs_submit_compressed_read (+25/-4)
    btrfs: fix several uncheck memory allocations (+33/-0)
    btrfs: fix missing break in switch phrase (+1/-0)

Miao Xie (2) commits (+7/-0):
    Btrfs: Don't return acl info when mounting with noacl option (+6/-0)
    Btrfs: Fix memory leak in writepage fixup work (+1/-0)

Chris Mason (2) commits (+3/-2):
    Btrfs: avoid uninit variable warnings in ordered-data.c (+1/-1)
    Btrfs: catch errors from btrfs_sync_log (+2/-1)

Zheng Yan (1) commits (+4/-4):
    Btrfs: Fix page count calculation

Julia Lawall (1) commits (+1/-1):
    fs/btrfs/inode.c: Add missing IS_ERR test

Tero Roponen (1) commits (+3/-2):
    Btrfs: Free correct pointer after using strsep

Ian Kent (1) commits (+2/-0):
    Btrfs: Fix memory leak on finding existing super

Alexey Charkov (1) commits (+1/-1):
    btrfs: Drop __exit attribute on btrfs_exit_compress

Total: (33) commits (+373/-118)

 fs/btrfs/acl.c              |    6 ++
 fs/btrfs/compression.c      |   27 +++++++-
 fs/btrfs/disk-io.c          |    7 ++
 fs/btrfs/export.c           |    2 +
 fs/btrfs/extent-tree.c      |   98 +++++++++++++++++++++-----
 fs/btrfs/extent_io.c        |    6 +-
 fs/btrfs/file-item.c        |    5 ++
 fs/btrfs/file.c             |   20 ++++--
 fs/btrfs/free-space-cache.c |  162 ++++++++++++++++++++++++++----------------
 fs/btrfs/inode.c            |   35 ++++++---
 fs/btrfs/ioctl.c            |   19 ++++--
 fs/btrfs/ordered-data.c     |    2 +-
 fs/btrfs/print-tree.c       |    1 +
 fs/btrfs/relocation.c       |   29 +++++++-
 fs/btrfs/super.c            |    9 ++-
 fs/btrfs/transaction.c      |    5 ++
 fs/btrfs/tree-log.c         |   35 +++++++++-
 fs/btrfs/volumes.c          |   19 +++++-
 18 files changed, 371 insertions(+), 116 deletions(-)
