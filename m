From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v4 0/6] btrfs: scrub
Date: Fri, 18 Mar 2011 16:55:03 +0100
Message-ID: <cover.1300462778.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This series adds an initial implementation for scrub. It works quite
straightforward. The usermode issues an ioctl for each device in the
fs. For each device, it enumerates the allocated device chunks. For
each chunk, the contained extents are enumerated and the data checksums
fetched. The extents are read sequentially and the checksums verified.
If an error occurs (checksum or EIO), a good copy is searched for. If
one is found, the bad copy will be rewritten.
All enumerations happen from the commit roots. During a transaction
commit, the scrubs get paused and afterwards continue from the new
roots.
For future improvements please see the inline comments.

The full scrub code with incremental changes is also available at:

git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne.git scrub
  and
git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-progs-unstable-arne.git scrub

based on chris' current master (36e39c40b3f).


Change log:

Updates v2:
 - mainly changes to the dev_info ioctl interface

Updates v3:
 - fixed EIO handling, need to reallocate bio instead of reusing it
 - Updated according to David Sterba's review
 - don't clobber bi_flags on reuse, just set UPTODATE
 - allocate long living bios with bio_kmalloc instead of bio_alloc

Updates v4:
 - don't restart chunk on commit
 - each EIO leaked a bio
 - the BIO_UPTODATE check was wrong
 - removed some trailing whitespace
 - nstripes int -> u64
 - %lld -> %llu
 - extent_map reference not freed, leaking them on unmount
 - remove unnecessary mutex locks around 'scrubs_running'


Thanks,
Arne

Arne Jansen (5):
  btrfs: add parameter to btrfs_lookup_csum_range
  btrfs: make struct map_lookup public
  btrfs: add scrub code and prototypes
  btrfs: sync scrub with commit & device removal
  btrfs: add state information for scrub

Jan Schmidt (1):
  btrfs: new ioctls for scrub

 fs/btrfs/Makefile      |    2 +-
 fs/btrfs/ctree.h       |   45 ++-
 fs/btrfs/disk-io.c     |   16 +
 fs/btrfs/file-item.c   |    8 +-
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/ioctl.c       |  131 +++++
 fs/btrfs/ioctl.h       |   55 ++
 fs/btrfs/relocation.c  |    2 +-
 fs/btrfs/scrub.c       | 1496 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c |    3 +
 fs/btrfs/tree-log.c    |    6 +-
 fs/btrfs/volumes.c     |   16 +-
 fs/btrfs/volumes.h     |   17 +
 13 files changed, 1775 insertions(+), 24 deletions(-)
 create mode 100644 fs/btrfs/scrub.c

-- 
1.7.3.4

