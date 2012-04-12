From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH 0/5] btrfs: snapshot deletion via readahead
Date: Thu, 12 Apr 2012 17:54:37 +0200
Message-ID: <cover.1334241664.git.sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patchset reimplements snapshot deletion with the help of the readahead
framework. For this callbacks are added to the framework. The main idea is
to traverse many snapshots at once at read many branches at once. This way
readahead get many requests at once (currently about 50000), giving it the
chance to order disk accesses properly. On a single disk, the effect is
currently spoiled by sync operations that still take place, mainly checksum
deletion. The most benefit can be gained with multiple devices, as all devices
can be fully utilized. It scales quite well with the number of devices.
For more details see the commit messages of the individual patches and the
source code comments.

How it is tested:
I created a test volume using David Sterba's stress-subvol-git-aging.sh. It
checks out randoms version of the kernel git tree, creating a snapshot from it
from time to time and checks out other versions there, and so on. In the end
the fs had 80 subvols with various degrees of sharing between them. The
following tests were conducted on it:
 - delete a subvol using droptree and check the fs with btrfsck afterwards
   for consistency
 - delete all subvols and verify with btrfs-debug-tree that the extent
   allocation tree is clean
 - delete 70 subvols, and in parallel empty the other 10 with rm -rf to get
   a good pressure on locking
 - add various degrees of memory pressure to the previous test to get pages
   to expire early from page cache
 - enable all relevant kernel debugging options during all tests

The performance gain on a single drive was about 20%, on 8 drives about 600%.
It depends vastly on the maximum parallelity of the readahead, that is
currently hardcoded to about 50000. This number is subject to 2 factors, the
available RAM and the size of the saved state for a commit. As the full state
has to be saved on commit, a large parallelity leads to a large state.

Based on this I'll see if I can add delayed checksum deletions and running
the delayed refs via readahead, to gain a maximum ordering of I/O ops.

This patchset is also available at

git://git.kernel.org/pub/scm/linux/kernel/git/arne/linux-btrfs.git droptree

Arne Jansen (5):
  btrfs: extend readahead interface
  btrfs: add droptree inode
  btrfs: droptree structures and initialization
  btrfs: droptree implementation
  btrfs: use droptree for snapshot deletion

 fs/btrfs/Makefile           |    2 +-
 fs/btrfs/btrfs_inode.h      |    4 +
 fs/btrfs/ctree.h            |   78 ++-
 fs/btrfs/disk-io.c          |   19 +
 fs/btrfs/droptree.c         | 1916 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/free-space-cache.c |  131 +++-
 fs/btrfs/free-space-cache.h |   32 +
 fs/btrfs/inode.c            |    3 +-
 fs/btrfs/reada.c            |  494 +++++++++---
 fs/btrfs/scrub.c            |   29 +-
 fs/btrfs/transaction.c      |   35 +-
 11 files changed, 2592 insertions(+), 151 deletions(-)
 create mode 100644 fs/btrfs/droptree.c

-- 
1.7.3.4

