From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fixes for 2.6.31
Date: Tue, 28 Jul 2009 11:49:49 -0400
Message-ID: <20090728154949.GB6830@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

This pull request is much bigger than I had planned on sending.  The
large changes come from patches that Josef Bacik has been refining since
2.6.28 or so, and they include important fixes.

First they change the way we track which extents are free in ram,
significantly reducing slab usage.  Before his code, a weekend stress
run could end up using over 1GB of slab for the free extent records, and
now it is 10MB.

After mount, Btrfs has to read in parts of extent allocation tree to
find free extents.  This can be somewhat slow, leading to long stalls
right after a mount (multiple minutes in the worst case).  Josef has
commits in this pull request that switch us to an async block group
caching, which gets rid of the stalls entirely.

I was planning on leaving these out until 2.6.32, but they work well
and it seems much better to have these issues fixed in .31 than
leaving them pending.  I'd rather not see fc12 need to carry a backport
of this for their .31 based kernels.

There are a number of other bug fixes included, including avoiding some
of the ENOSPC oopsen.

Linus, please pull the master branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Chris Mason (2) commits (+12/-3):
    Btrfs: find smallest available device extent during chunk allocation (+10/-2)
    Btrfs: clear all space_info->full after removing a block group (+2/-1)

Daniel Cadete (1) commits (+3/-3):
    Btrfs: remove of redundant btrfs_header_level

David Woodhouse (2) commits (+10/-20):
    Btrfs: Remove broken sanity check from btrfs_rmap_block() (+0/-20)
    Btrfs: Fix crash on read failures at mount (+10/-0)

Diego Calleja (1) commits (+1/-13):
    Btrfs: Remove code duplication in comp_keys

Josef Bacik (3) commits (+1311/-453):
    Btrfs: use hybrid extents+bitmap rb tree for free space (+826/-216)
    Btrfs: change how we unpin extents (+46/-113)
    Btrfs: async block group caching (+439/-124)

Julia Lawall (3) commits (+4/-4):
    Btrfs: convert nested spin_lock_irqsave to spin_lock (+2/-2)
    Btrfs: Correct redundant test in add_inode_ref (+1/-1)
    Btrfs: adjust NULL test (+1/-1)

Sage Weil (1) commits (+5/-3):
    Btrfs: make flushoncommit mount option correctly wait on ordered_extents

Yan Zheng (9) commits (+128/-84):
    Btrfs: find_free_dev_extent doesn't handle holes at the start of the device (+7/-3)
    Btrfs: fix double increment of path->slots[0] in btrfs_next_leaf (+2/-1)
    Btrfs: properly update space information after shrinking device. (+2/-2)
    Btrfs: Fix ordering of key field checks in btrfs_previous_item (+2/-2)
    Btrfs: make sure all dirty blocks are written at commit time (+42/-37)
    Btrfs: fix definition of struct btrfs_extent_inline_ref (+1/-1)
    Btrfs: Fix async caching interaction with unmount (+6/-1)
    Btrfs: fix locking issue in btrfs_find_next_key (+65/-33)
    Btrfs: Avoid delayed reference update looping (+1/-4)

Total: (22) commits

 fs/btrfs/async-thread.c     |    4 
 fs/btrfs/ctree.c            |  121 ++---
 fs/btrfs/ctree.h            |   37 +
 fs/btrfs/disk-io.c          |   19 
 fs/btrfs/extent-tree.c      |  722 ++++++++++++++++++++----------
 fs/btrfs/free-space-cache.c | 1043 ++++++++++++++++++++++++++++++++++----------
 fs/btrfs/free-space-cache.h |    8 
 fs/btrfs/inode.c            |    2 
 fs/btrfs/print-tree.c       |    6 
 fs/btrfs/relocation.c       |    3 
 fs/btrfs/transaction.c      |   40 -
 fs/btrfs/tree-log.c         |    6 
 fs/btrfs/volumes.c          |   46 -
 13 files changed, 1474 insertions(+), 583 deletions(-)
