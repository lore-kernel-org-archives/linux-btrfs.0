From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH 0/3] apply the Probabilistic Skiplist on btrfs
Date: Thu, 5 Jan 2012 17:48:06 +0800
Message-ID: <1325756889-13294-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since we are inclined to apply a lockless scheme on some objects of btrfs for
higher performance, we want to build a RCU version the Probabilistic Skiplist.

Here our skiplist algorithm is based on the skiplist experiments of
Con Kolivas <kernel@kolivas.org> for BFS cpu scheduler.
And more details about skiplist design are in patch 1.

Right now we have a plan to apply skiplist on extent_map and extent_state.

Here we choose extent_map firstly, since it is a "read mostly" thing,
and the change is quite direct, all we need to do is
a) to replace rbtree with skiplist,
b) to add rcu support.
And more details are in patch 2 and patch 3.

I've done some simple tests for performance on my 2-core box, there is no
obvious difference, but I want to focus on the design side and make sure
there is no more bug in it firstly.

For long term goals, we want to ship skiplist to lib, like lib/rbtree.c.

MORE TESTS ARE WELCOME!

Liu Bo (3):
  Btrfs: add the Probabilistic Skiplist
  Btrfs: rebuild extent_map based on skiplist
  Btrfs: convert rwlock to RCU for extent_map

 fs/btrfs/Makefile      |    2 +-
 fs/btrfs/compression.c |    8 +-
 fs/btrfs/disk-io.c     |   15 ++-
 fs/btrfs/extent_io.c   |   13 +-
 fs/btrfs/extent_map.c  |  296 ++++++++++++++++++++++++++++++------------------
 fs/btrfs/extent_map.h  |   21 +++-
 fs/btrfs/file.c        |   23 +++-
 fs/btrfs/inode.c       |   69 ++++++++----
 fs/btrfs/ioctl.c       |    8 +-
 fs/btrfs/relocation.c  |    9 +-
 fs/btrfs/scrub.c       |    4 +-
 fs/btrfs/skiplist.c    |   98 ++++++++++++++++
 fs/btrfs/skiplist.h    |  217 +++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c     |   68 ++++++-----
 14 files changed, 651 insertions(+), 200 deletions(-)
 create mode 100644 fs/btrfs/skiplist.c
 create mode 100644 fs/btrfs/skiplist.h

