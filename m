From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs updates for 2.6.31-rc
Date: Thu, 11 Jun 2009 16:44:56 -0400
Message-ID: <20090611204456.GA3834@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

This is a large pull request for btrfs, and it includes a forward
rolling format change.   This means that once this code mounts a btrfs
filesystem, the older kernels won't be able to read it.  Btrfs progs
v0.19 is required to read the new format.

Existing filesystems will be upgraded to the new format on the first
mount.  All of your old data will still be there and still work
properly, but I strongly recommend a full backup before going to the new
code.

Since I don't want to lock testers into 2.6.31-rc, a stable branch of
btrfs changes for 2.6.30 that includes this new format will be
maintained under the newformat2 branch name on the btrfs git repo.

The format changes significantly lower the overhead of tracking data and
metadata extents, and make a big difference in almost every benchmark.
One example is a random O_DIRECT write workload went from 6,000 ops/sec
on 2.6.30 to 23,000 ops/sec, with most of the gain being less IO
tracking the extents during COW.

Yan Zheng did all the heavy lifting on making these format changes work,
including the backward compatibility.

The pull request includes an assortment of other fixes, and a
number of buffered IO optimizations.

Linus, the master branch of the btrfs-unstable repo:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

Has these changes:

Chris Mason (14) commits (+136/-36):
    Btrfs: avoid IO stalls behind congested devices in a multi-device FS (+4/-1)
    Btrfs: avoid races between super writeout and device list updates (+45/-2)
    Btrfs: fix oops when btrfs_inherit_iflags called with a NULL dir (+6/-1)
    Btrfs: don't allow WRITE_SYNC bios to starve out regular writes (+15/-7)
    Btrfs: stop avoiding balancing at the end of the transaction. (+4/-7)
    Btrfs: add mount -o ssd_spread to spread allocations out (+22/-6)
    Btrfs: avoid allocation clusters that are too spread out (+2/-1)
    Btrfs: fix extent_buffer leak during tree log replay (+1/-0)
    Btrfs: fix metadata dirty throttling limits (+2/-5)
    Btrfs: fix -o nodatasum printk spelling (+1/-1)
    Btrfs: reduce mount -o ssd CPU usage (+1/-1)
    Btrfs: balance btree more often (+2/-2)
    Btrfs: autodetect SSD devices (+24/-0)
    Btrfs: Add mount -o nossd (+7/-2)

Yan Zheng (3) commits (+6946/-2058):
    Btrfs: Mixed back reference  (FORWARD ROLLING FORMAT CHANGE) (+6928/-2043)
    Btrfs: check duplicate backrefs for both data and metadata (+4/-11)
    btrfs: Fix set/clear_extent_bit for 'end == (u64)-1' (+14/-4)

Hisashi Hifumi (2) commits (+31/-14):
    Btrfs: fdatasync should skip metadata writeout (+2/-0)
    Btrfs: pin buffers during write_dev_supers (+29/-14)

David Woodhouse (1) commits (+7/-37):
    Btrfs: remove crc32c.h and use libcrc32c directly.

Shin Hong (1) commits (+1/-1):
    Btrfs: init worker struct fields before kthread-run

Christoph Hellwig (1) commits (+200/-21):
    Btrfs: implement FS_IOC_GETFLAGS/SETFLAGS/GETVERSION

Al Viro (1) commits (+4/-5):
    Fix btrfs when ACLs are configured out

Total: (23) commits

 fs/btrfs/Makefile           |    4 
 fs/btrfs/acl.c              |    5 
 fs/btrfs/async-thread.c     |    2 
 fs/btrfs/btrfs_inode.h      |    4 
 fs/btrfs/compression.c      |    6 
 fs/btrfs/crc32c.h           |   29 
 fs/btrfs/ctree.c            |  700 +++-----
 fs/btrfs/ctree.h            |  330 ++-
 fs/btrfs/delayed-ref.c      |  509 ++++--
 fs/btrfs/delayed-ref.h      |   85 -
 fs/btrfs/disk-io.c          |  164 +
 fs/btrfs/export.c           |    4 
 fs/btrfs/extent-tree.c      | 2638 +++++++++++++++++++++----------
 fs/btrfs/extent_io.c        |   18 
 fs/btrfs/file.c             |   78 
 fs/btrfs/free-space-cache.c |   10 
 fs/btrfs/free-space-cache.h |    1 
 fs/btrfs/hash.h             |    4 
 fs/btrfs/inode.c            |  159 +
 fs/btrfs/ioctl.c            |  199 ++
 fs/btrfs/print-tree.c       |  155 +
 fs/btrfs/relocation.c       | 3711 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/root-tree.c        |   17 
 fs/btrfs/super.c            |   59 
 fs/btrfs/transaction.c      |  410 +---
 fs/btrfs/transaction.h      |   12 
 fs/btrfs/tree-log.c         |  103 -
 fs/btrfs/volumes.c          |   69 
 fs/btrfs/volumes.h          |   12 
 29 files changed, 7325 insertions(+), 2172 deletions(-)
