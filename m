From: Chris Mason <chris.mason@ORACLE.COM>
Subject: [GIT PULL] Btrfs updates for 2.6.37
Date: Sat, 30 Oct 2010 09:51:11 -0400
Message-ID: <20101030135111.GA2918@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.og, linux-btrfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

There were some minor conflicts with Linus' current tree, so my branch 
is merged with Linus' tree as of this morning.

It includes some new writeback helpers so that btrfs can kick off IO to
reclaim delalloc space.  I bounced a few different interfaces off
Christoph before this one.  It isn't quite perfect for what btrfs is
doing but it just adds a new func that limits the number of pages we'll
send down to writeback_inodes_sb

Otherwise these are all btrfs commits.  The big focus of the work this
time around is performance around ENOSPC and bug fixes.  Josef also has
some block group caching code which writes out the free space cache with
each commit.  This is disabled by default, but you get it with mount -o
space_cache.

After a fresh mount, his new code makes us dramatically faster because
we don't have to scan the btree for free blocks.

Sage has a collection of new ioctls that ceph will be using.  They make
is possible for ceph to stop using the transaction start/top ioctls, so
it's a big cleanup.

Linus, please pull the for-linus branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

The master branch has all of these changes against 2.6.36

Josef Bacik (17) commits (+1775/-254):
    Btrfs: set trans to null in reserve_metadata_bytes if we commit the transaction (+6/-3)
    Btrfs: check cache->caching_ctl before returning if caching has started (+6/-0)
    Btrfs: stop trying to shrink delalloc if there are no inodes to reclaim (+5/-0)
    Btrfs: add support for mixed data+metadata block groups (+28/-4)
    Btrfs: fix reservation code for mixed block groups (+6/-2)
    Btrfs: let the user know space caching is enabled (+2/-0)
    Btrfs: create special free space cache inode (+668/-46)
    Btrfs: rework how we reserve metadata bytes (+136/-127)
    Btrfs: fix the df ioctl to report raid types (+76/-24)
    Btrfs: don't allocate chunks as aggressively (+5/-2)
    Btrfs: load free space cache if it exists (+345/-3)
    Btrfs: fix error handling in btrfs_get_sb (+3/-4)
    Btrfs: remove warn_on from use_block_rsv (+0/-5)
    Btrfs: Add a clear_cache mount option (+8/-3)
    Btrfs: write out free space cache (+420/-13)
    Btrfs: re-work delalloc flushing (+38/-15)
    Btrfs: fix df regression (+23/-3)

Sage Weil (9) commits (+438/-47):
    Btrfs: allow subvol deletion by unprivileged user with -o user_subvol_rm_allowed (+116/-5)
    Btrfs: fix clone ioctl where range is adjacent to extent (+1/-1)
    Btrfs: fix deadlock in btrfs_commit_transaction (+5/-8)
    Btrfs: fix lockdep warning on clone ioctl (+4/-4)
    Btrfs: fix delalloc checks in clone ioctl (+5/-3)
    Btrfs: add START_SYNC, WAIT_SYNC ioctls (+89/-0)
    Btrfs: add SNAP_CREATE_ASYNC ioctl (+93/-25)
    Btrfs: async transaction commit (+124/-0)
    Btrfs: make SNAP_DESTROY async (+1/-1)

Chris Mason (7) commits (+108/-48):
    Btrfs: tune the chunk allocation to 5% of the FS as metadata (+18/-4)
    Btrfs: use the flusher threads for delalloc throttling (+15/-18)
    Btrfs: deal with errors from updating the tree log (+2/-1)
    Add new functions for triggering inode writeback (+44/-10)
    Btrfs: fix raid code for removing missing drives (+1/-2)
    Btrfs: drop unused variable in block_alloc_rsv (+0/-4)
    Btrfs: don't loop forever on bad btree blocks (+28/-9)

Julia Lawall (2) commits (+9/-17):
    Btrfs: use memdup_user helpers (+6/-14)
    Btrfs: Use ERR_CAST helpers (+3/-3)

Andi Kleen (2) commits (+14/-100):
    Btrfs: Fix variables set but not read (bugs found by gcc 4.6) (+10/-6)
    Btrfs: cleanup warnings from gcc 4.6 (nonbugs) (+4/-94)

Miao Xie (2) commits (+86/-80):
    Btrfs: Switch the extent buffer rbtree into a radix tree (+49/-69)
    Btrfs: restructure try_release_extent_buffer() (+37/-11)

Total: (39) commits (+2430/-546)

 fs/btrfs/compression.c      |    2 -
 fs/btrfs/ctree.c            |   57 ++--
 fs/btrfs/ctree.h            |  100 +++++-
 fs/btrfs/dir-item.c         |    2 +-
 fs/btrfs/disk-io.c          |   32 ++-
 fs/btrfs/extent-tree.c      |  694 +++++++++++++++++++++++++++++++---------
 fs/btrfs/extent_io.c        |  168 +++++-----
 fs/btrfs/extent_io.h        |    4 +-
 fs/btrfs/extent_map.c       |    4 +-
 fs/btrfs/free-space-cache.c |  751 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.h |   18 +
 fs/btrfs/inode.c            |  202 +++++++++---
 fs/btrfs/ioctl.c            |  398 ++++++++++++++++++-----
 fs/btrfs/ioctl.h            |   13 +-
 fs/btrfs/ordered-data.c     |    2 -
 fs/btrfs/relocation.c       |  109 ++++++-
 fs/btrfs/root-tree.c        |    2 -
 fs/btrfs/super.c            |   41 ++-
 fs/btrfs/transaction.c      |  234 ++++++++++++--
 fs/btrfs/transaction.h      |    8 +
 fs/btrfs/tree-defrag.c      |    2 -
 fs/btrfs/tree-log.c         |   17 +-
 fs/btrfs/volumes.c          |    7 +-
 fs/btrfs/xattr.c            |    2 -
 fs/btrfs/zlib.c             |    5 -
 fs/fs-writeback.c           |   54 +++-
 include/linux/writeback.h   |    2 +
 27 files changed, 2411 insertions(+), 519 deletions(-)
