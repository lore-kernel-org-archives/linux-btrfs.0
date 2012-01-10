From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [RFC PATCH v2 0/3] Btrfs: apply the Probabilistic Skiplist on btrfs
Date: Tue, 10 Jan 2012 15:31:33 +0800
Message-ID: <1326180696-3614-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>, <dave@jikos.cz>
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

---
changes v2:
- fix a bug reported by David Sterba <dave@jikos.cz>, thanks a lot!
- use mutex lock to protect extent_map updater side, so that we can make
  the reclaim code much easier.
  And I've ran through xfstests, no panic occurred but they failed at
  273 and 274, and I've tested them without my patches and
  found that they still fails on the upstream.
---

Liu Bo (3):
  Btrfs: add the Probabilistic Skiplist
  Btrfs: rebuild extent_map based on skiplist
  Btrfs: convert rwlock to RCU for extent_map

 fs/btrfs/Makefile      |    2 +-
 fs/btrfs/compression.c |    8 +-
 fs/btrfs/disk-io.c     |    9 +-
 fs/btrfs/extent_io.c   |   13 +--
 fs/btrfs/extent_map.c  |  278 +++++++++++++++++++++++++++++++-----------------
 fs/btrfs/extent_map.h  |   19 +++-
 fs/btrfs/file.c        |   11 +-
 fs/btrfs/inode.c       |   28 +++---
 fs/btrfs/ioctl.c       |    8 +-
 fs/btrfs/relocation.c  |    4 +-
 fs/btrfs/scrub.c       |    4 +-
 fs/btrfs/skiplist.c    |  101 +++++++++++++++++
 fs/btrfs/skiplist.h    |  217 +++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c     |   58 +++++-----
 14 files changed, 585 insertions(+), 175 deletions(-)
 create mode 100644 fs/btrfs/skiplist.c
 create mode 100644 fs/btrfs/skiplist.h

