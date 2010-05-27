From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Thu, 27 May 2010 11:15:15 -0400
Message-ID: <20100527151515.GA3835@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The master branch of the btrfs-unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has the first round of btrfs updates for 2.6.35-rc.  I still have some
pending fixes and patches queued up from other people, but this pull
request has the two major features for this release.

First we've got a large ENOSPC improvement from Yan Zheng.  He hit on
all the difficult corners including space balancing, drive management,
fsync logging and many others.  This has been in the works for sometime
and it has held up very well in testing.

The second batch is O_DIRECT work from Josef Bacik.  We've had a few
different iterations on ENOSPC floating on the btrfs list, and this one
takes a much less complex road by hooking into the generic
fs/direct-io.c code.  Josef added a hook for bio submission to
fs/direct-io.c so that we could do proper block number transaction and
properly do multi-device IO.

There are small changes in here to fs/direct-io.c, mm/filemap.c and
include/linux/fs.h.  These have been sent out for review a few times and
commented on.  The filemap.c change allows O_DIRECT reads to fall back
to buffered IO, which we need to support compression and do checksumming
IOs < 1 page.

My commits here are just integrating the two and fixing a few bugs in
the result.

Zheng Yan (13) commits (+4076/-2679):
    Btrfs: Integrate metadata reservation with start_transaction (+678/-528)
    Btrfs: Update metadata reservation for delayed allocation (+232/-415)
    Btrfs: Shrink delay allocated space in a synchronized (+88/-121)
    Btrfs: Introduce contexts for metadata reservation (+853/-385)
    Btrfs: Link block groups of different raid types (+121/-55)
    Btrfs: Metadata ENOSPC handling for balance (+1163/-747)
    Btrfs: Metadata ENOSPC handling for tree log (+156/-128)
    Btrfs: Metadata reservation for orphan inodes (+365/-66)
    Btrfs: Pre-allocate space for data relocation (+92/-45)
    Btrfs: Introduce global metadata reservation (+241/-76)
    Btrfs: Fix block generation verification race (+1/-1)
    Btrfs: Kill allocate_wait in space_info (+58/-76)
    Btrfs: Kill init_btrfs_i() (+28/-36)

Chris Mason (9) commits (+314/-80):
    Btrfs: fix preallocation and nodatacow checks in O_DIRECT (+140/-16)
    Btrfs: move O_DIRECT space reservation to btrfs_direct_IO (+8/-6)
    Btrfs: don't walk around with task->state != TASK_RUNNING (+4/-3)
    Btrfs: use async helpers for DIO write checksumming (+52/-17)
    Btrfs: add more error checking to btrfs_dirty_inode (+13/-2)
    Btrfs: avoid ENOSPC errors in btrfs_dirty_inode (+11/-3)
    Btrfs: rework O_DIRECT enospc handling (+49/-30)
    Btrfs: drop verbose enospc printk (+2/-0)
    Btrfs: allow unaligned DIO (+35/-3)

Josef Bacik (5) commits (+829/-134):
    direct-io: add a hook for the fs to provide its own submit_bio function (+45/-8)
    fs: allow short direct-io reads to be completed via buffered IO (+31/-5)
    direct-io: do not merge logically non-contiguous requests (+18/-2)
    Btrfs: add basic DIO read/write support (+631/-36)
    Btrfs: do aio_write instead of write (+104/-83)

Total: (27) commits

 fs/btrfs/extent-tree.c  | 2317 ++++++++++++++++++++++++++++--------------------
 fs/btrfs/relocation.c   | 1991 +++++++++++++++++++++++++----------------
 fs/btrfs/inode.c        | 1797 +++++++++++++++++++++++++++++--------
 fs/btrfs/file.c         |  304 +++---
 fs/btrfs/tree-log.c     |  241 +++-
 fs/btrfs/transaction.c  |  232 +++-
 fs/btrfs/ioctl.c        |  206 ++--
 fs/btrfs/disk-io.c      |  171 +--
 fs/btrfs/ctree.h        |  163 ++-
 fs/btrfs/ctree.c        |  109 +-
 fs/btrfs/delayed-ref.c  |  101 --
 fs/btrfs/extent_io.c    |   85 -
 fs/btrfs/ordered-data.c |   82 +
 fs/direct-io.c          |   62 +
 mm/filemap.c            |   36 
 fs/btrfs/super.c        |   30 
 fs/btrfs/file-item.c    |   28 
 fs/btrfs/inode-item.c   |   27 
 fs/btrfs/transaction.h  |   24 
 fs/btrfs/root-tree.c    |   23 
 fs/btrfs/volumes.c      |   17 
 fs/btrfs/extent_io.h    |   14 
 fs/btrfs/xattr.c        |   12 
 include/linux/fs.h      |   11 
 fs/btrfs/ordered-data.h |    9 
 fs/btrfs/tree-defrag.c  |    7 
 fs/btrfs/disk-io.h      |    4 
 fs/btrfs/delayed-ref.h  |    3 
 fs/btrfs/btrfs_inode.h  |    3 
 fs/btrfs/tree-log.h     |    2 
 fs/btrfs/async-thread.c |    1 
 31 files changed, 5219 insertions(+), 2893 deletions(-)
