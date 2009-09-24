From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs patches for 2.6.32-rc
Date: Thu, 24 Sep 2009 11:48:14 -0400
Message-ID: <20090924154814.GB2662@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

The for-linus branch of the btrfs unstable repo is updated for merging
with mainline:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

There was a trivial conflict against fs/btrfs/super.c, so the for-linus branch
has things fixed up.  The master branch has the pre-merge btrfs
changes against 2.6.31.

The most significant part of this merge is Yan Zheng's work on snapshot
and subvolume deletion.  If you pull the latest from btrfs-progs you'll
be able to delete snapshots and subvolumes without having to resort to
rm -rf.  This is much faster because it does the deletion via btree
walking.  It's also now possible to rename snapshots and subvols.

Most of my patches are around improving write performance.  Streaming
writes on very fast hardware got CPU bound at around 400MB/s, and btrfs
can now push over 1GB/s while using the same CPU as XFS (if you factor out
crcs).  There are also fixes for the btrfs write_cache_pages in there do
a better job of writing large portions of an extent.

The first part of Josef's ENOSPC work is included, but the patch
that starts enforcing space reservations was held back for now.

Another visible change is the btrfs worker threads are more dynamic,
and they die if they have been idle for a while.

Chris Mason (26) commits (+759/-393):
    Btrfs: use a cached state for extent state operations during delalloc (+40/-24)
    Btrfs: fix releasepage to avoid unlocking extents we haven't locked (+7/-2)
    Btrfs: Use PagePrivate2 to track pages in the data=ordered code. (+62/-55)
    Btrfs: fix errors handling cached state in set/clear_extent_bit (+8/-8)
    Btrfs: search for an allocation hint while filling file COW (+59/-1)
    Btrfs: don't lock bits in the extent tree during writepage (+0/-21)
    Btrfs: reduce worker thread spin_lock_irq hold times (+60/-14)
    Btrfs: keep irqs on more often in the worker threads (+16/-10)
    Btrfs: fix btrfs page_mkwrite to return locked page (+3/-0)
    Btrfs: reduce CPU usage in the extent_state tree (+28/-68)
    Btrfs: Fix test_range_bit for whole file extents (+4/-0)
    Btrfs: properly honor wbc->nr_to_write changes (+27/-11)
    Btrfs: use larger nr_to_write for larger extents (+9/-5)
    Btrfs: Allow worker threads to exit when idle (+132/-32)
    Btrfs: zero page past end of inline file items (+5/-0)
    Btrfs: fix worker thread double spin_lock_irq (+2/-2)
    Btrfs: cache values for locking extents (+100/-36)
    Btrfs: fix early enospc during balancing (+7/-13)
    Btrfs: Fix new state initialization order (+2/-2)
    Btrfs: switch extent_map to a rw lock (+57/-60)
    Btrfs: Fix async thread shutdown race (+10/-6)
    Btrfs: fix async worker startup race (+11/-3)
    Btrfs: Fix extent replacment race (+80/-13)
    Btrfs: deal with NULL space info (+16/-2)
    Btrfs: tweak congestion backoff (+1/-1)
    Btrfs: optimize set extent bit (+13/-4)

Zheng Yan (7) commits (+1490/-679):
    Btrfs: check size of inode backref before adding hardlink (+37/-24)
    Btrfs: do not reuse objectid of deleted snapshot/subvol (+31/-116)
    Btrfs: add snapshot/subvolume destroy ioctl (+605/-233)
    Btrfs: change how subvolumes are organized (+459/-168)
    Btrfs: don't rename file into dummy directory (+3/-0)
    Btrfs: relocate file extents in clusters (+148/-89)
    Btrfs: speed up snapshot dropping (+207/-49)

Josef Bacik (6) commits (+207/-748):
    Btrfs: don't keep retrying a block group if we fail to allocate a cluster (+17/-8)
    Btrfs: make balance code choose more wisely when relocating (+148/-18)
    Btrfs: account for space used by the super mirrors (+20/-2)
    Btrfs: fix extent entry threshold calculation (+21/-14)
    Btrfs: fix bitmap size tracking (+1/-0)
    Btrfs: remove dead code (+0/-706)

Yan Zheng (2) commits (+383/-259):
    Btrfs: hash the btree inode during  fill_super (+1/-0)
    Btrfs: improve async block group caching (+382/-259)

Sage Weil (1) commits (+1/-2):
    Btrfs: fix arithmetic error in clone ioctl

Total: (42) commits

 fs/btrfs/async-thread.c     |  264 +++++-
 fs/btrfs/async-thread.h     |   12 
 fs/btrfs/btrfs_inode.h      |    1 
 fs/btrfs/compression.c      |    8 
 fs/btrfs/ctree.c            |    6 
 fs/btrfs/ctree.h            |   78 +
 fs/btrfs/dir-item.c         |   47 +
 fs/btrfs/disk-io.c          |  235 +++--
 fs/btrfs/export.c           |  133 ++-
 fs/btrfs/extent-tree.c      | 1740 ++++++++++++++++++--------------------------
 fs/btrfs/extent_io.c        |  404 +++++-----
 fs/btrfs/extent_io.h        |   18 
 fs/btrfs/extent_map.c       |  103 ++
 fs/btrfs/extent_map.h       |    5 
 fs/btrfs/file.c             |   37 
 fs/btrfs/free-space-cache.c |   36 
 fs/btrfs/inode-item.c       |    4 
 fs/btrfs/inode-map.c        |   93 --
 fs/btrfs/inode.c            |  687 ++++++++++++-----
 fs/btrfs/ioctl.c            |  341 ++++----
 fs/btrfs/ioctl.h            |    3 
 fs/btrfs/ordered-data.c     |   37 
 fs/btrfs/ordered-data.h     |    3 
 fs/btrfs/orphan.c           |   20 
 fs/btrfs/relocation.c       |  284 ++++---
 fs/btrfs/root-tree.c        |  138 ++-
 fs/btrfs/super.c            |    1 
 fs/btrfs/transaction.c      |   38 
 fs/btrfs/tree-log.c         |   25 
 fs/btrfs/volumes.c          |  117 +-
 fs/btrfs/volumes.h          |    3 
 31 files changed, 2840 insertions(+), 2081 deletions(-)
