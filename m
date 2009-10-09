From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.32-rc
Date: Fri, 9 Oct 2009 13:29:44 -0400
Message-ID: <20091009172944.GB2632@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Btrfs updates are in the master branch of the btrfs-unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

This branch is still against 2.6.31, but git merging lets it work with
the code Linus has already pulled and merged into 2.6.32-rc

This bunch fine tunes the enospc support, removing a window where the
accounting would let people allocate even though space wasn't yet
available.

There is a deadlock fix where the worker threads would get stuck waiting
for memory while trying to start more worker threads, and an important
fix for the file clone ioctl where it can incorrectly setup extents on the
clone.

Alexey Dobriyan (1) commits (+2/-2):
    Btrfs: constify dentry_operations

Chris Mason (5) commits (+166/-73):
    Btrfs: delay clearing EXTENT_DELALLOC for compressed extents (+4/-2)
    Btrfs: fix uninit compiler warning in cow_file_range_nocow (+1/-0)
    Btrfs: cleanup extent_clear_unlock_delalloc flags (+51/-37)
    Btrfs: fix file clone ioctl for bookend extents (+4/-2)
    Btrfs: fix deadlock on async thread startup (+106/-32)

Josef Bacik (4) commits (+225/-55):
    Btrfs: release delalloc reservations on extent item insertion (+107/-37)
    Btrfs: async delalloc flushing under space pressure (+88/-11)
    Btrfs: optimize fsync for the single writer case (+13/-1)
    Btrfs: fix possible softlockup in the allocator (+17/-6)

Zheng Yan (2) commits (+61/-34):
    Btrfs: optimize back reference update during btrfs_drop_snapshot (+53/-29)
    Btrfs: remove negative dentry when deleting subvolumne (+8/-5)

Total: (12) commits

 fs/btrfs/async-thread.c |   81 ++++++++++++++--
 fs/btrfs/async-thread.h |   10 +-
 fs/btrfs/btrfs_inode.h  |   12 +-
 fs/btrfs/ctree.h        |   21 ++--
 fs/btrfs/disk-io.c      |   48 +++++----
 fs/btrfs/extent-tree.c  |  239 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/extent_io.c    |   46 ++++-----
 fs/btrfs/extent_io.h    |   18 ++-
 fs/btrfs/file.c         |    3 
 fs/btrfs/inode.c        |  111 ++++++++++++++--------
 fs/btrfs/ioctl.c        |    7 +
 fs/btrfs/ordered-data.c |    6 +
 fs/btrfs/relocation.c   |    4 
 fs/btrfs/tree-log.c     |   12 ++
 14 files changed, 454 insertions(+), 164 deletions(-)
