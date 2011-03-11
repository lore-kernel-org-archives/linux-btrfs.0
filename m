From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v2 0/6] btrfs: scrub
Date: Fri, 11 Mar 2011 15:49:37 +0100
Message-ID: <cover.1299854593.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	jansen@webgods.de
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

The accompanying user mode patches will follow shortly.

This v2 mainly changes the dev_info ioctl interface.

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
 fs/btrfs/ctree.h       |   46 ++-
 fs/btrfs/disk-io.c     |   16 +
 fs/btrfs/file-item.c   |    8 +-
 fs/btrfs/inode.c       |    2 +-
 fs/btrfs/ioctl.c       |  131 +++++
 fs/btrfs/ioctl.h       |   55 ++
 fs/btrfs/relocation.c  |    2 +-
 fs/btrfs/scrub.c       | 1463 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/transaction.c |    3 +
 fs/btrfs/tree-log.c    |    6 +-
 fs/btrfs/volumes.c     |   16 +-
 fs/btrfs/volumes.h     |   17 +
 13 files changed, 1743 insertions(+), 24 deletions(-)
 create mode 100644 fs/btrfs/scrub.c

-- 
1.7.3.4

