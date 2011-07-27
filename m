From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates
Date: Wed, 27 Jul 2011 18:46:53 -0400
Message-ID: <1311805265-sup-502@shiny>
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"Linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The for-linus branch of the btrfs-unstable repo is reading for pulling:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git for-linus

This started off as a larger pull, but I had to pull out a number of
cleanups from Fujitsu, Novell and a few others (sorry guys) while
hunting a crash during stress.sh.  It looks like it is unrelated to
those commits, but I had to pull out a bunch of them until I can be sure
I understand the bug.

I'll have another pull request with the fully tested cleanups on Monday.
Depending on how Linus does rc1, they might end up as the start of my
3.2 branch.

This pull has the commits that I've been able to run through extensive
testing.  The biggest change here is switching the btrfs tree locks to a
reader/writer lock.  This has been one of our biggest bottlenecks for
some time, and it was consistently at the top of profiles on large
machines.

The new locks do away with all the adaptive spinning inside of btrfs and
rely on the spinning/blocking hints in the code to decide when it must
block.

The reader/writer locks break the code I had in place to use kmap on
metadata buffers, so all of our metadata is now in lowmem.  I did test
this on a 32 bit VM, but x86-32 users will want to poke gently.

I also adapted Tejun's lockdep fixes for the btrfs locks, and so far I
haven't seen any lockdep warnings.

Josef has a series of enospc fixes and tweaks here as well.  His bigger
patch to start reworking the enospc reservations seems to be causing the
corruptions during stress.sh, so it will wait for 3.2.

Josef Bacik (11) commits (+320/-322):
    Btrfs: use the normal checksumming infrastructure for free space cache (+59/-110)
    Btrfs: do transaction space reservation before joining the transaction (+17/-42)
    Btrfs: fix how we merge extent states and deal with cached states (+11/-12)
    Btrfs: try to only do one btrfs_search_slot in do_setxattr (+42/-33)
    Btrfs: use find_or_create_page instead of grab_cache_page (+9/-7)
    Btrfs: serialize flushers in reserve_metadata_bytes (+51/-21)
    Btrfs: fix deadlock when throttling transactions (+9/-2)
    Btrfs: fix enospc problems with delalloc (+86/-60)
    Btrfs: use a worker thread to do caching (+27/-29)
    Btrfs: don't flush delalloc arbitrarily (+0/-3)
    Btrfs: tag pages for writeback in sync (+9/-3)

Chris Mason (7) commits (+642/-699):
    Btrfs: make sure reserve_metadata_bytes doesn't leak out strange errors (+6/-1)
    Btrfs: use the commit_root for reading free_space_inode crcs (+28/-19)
    Btrfs: reduce extent_state lock contention for metadata (+41/-14)
    Btrfs: switch the btrfs tree locks to reader/writer (+431/-218)
    Btrfs: remove lockdep magic from btrfs_next_leaf (+5/-31)
    Btrfs: stop using highmem for extent_buffers (+52/-378)
    Btrfs: make a lockdep class for each root (+79/-38)

Miao Xie (1) commits (+21/-7):
    Btrfs: fix BUG_ON() caused by ENOSPC when relocating space

Total: (19)

 fs/btrfs/btrfs_inode.h      |   16 ++-
 fs/btrfs/ctree.c            |  457 +++++++++++++++++++------------------------
 fs/btrfs/ctree.h            |   14 +-
 fs/btrfs/delayed-inode.c    |    2 +-
 fs/btrfs/dir-item.c         |    9 +-
 fs/btrfs/disk-io.c          |  116 ++++++++----
 fs/btrfs/disk-io.h          |   10 +-
 fs/btrfs/extent-tree.c      |  285 +++++++++++++++-------------
 fs/btrfs/extent_io.c        |  168 ++++++++--------
 fs/btrfs/extent_io.h        |   35 ++--
 fs/btrfs/file-item.c        |   41 +---
 fs/btrfs/file.c             |   11 +-
 fs/btrfs/free-space-cache.c |  173 ++++++-----------
 fs/btrfs/inode.c            |   90 ++++------
 fs/btrfs/ioctl.c            |    8 +-
 fs/btrfs/locking.c          |  280 ++++++++++++++-------------
 fs/btrfs/locking.h          |   36 ++++-
 fs/btrfs/relocation.c       |    3 +-
 fs/btrfs/struct-funcs.c     |  100 +++-------
 fs/btrfs/transaction.c      |   47 +++--
 fs/btrfs/tree-log.c         |    6 +-
 fs/btrfs/volumes.c          |    2 +-
 fs/btrfs/xattr.c            |   66 ++++---
 23 files changed, 965 insertions(+), 1010 deletions(-)
