From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v3 0/6] btrfs: generic readeahead interface
Date: Wed, 29 Jun 2011 18:32:16 +0200
Message-ID: <cover.1309364964.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This series introduces a generic readahead interface for btrfs trees.
The intention is to use it to speed up scrub in a first run, but balance
is another hot candidate. In general, every tree walk could be accompanied
by a readahead. Deletion of large files comes to mind, where the fetching
of the csums takes most of the time.
Also the initial build-ups of free-space-caches and inode-allocator-caches
could be sped up.

To make testing easier, a simple ioctl interface is added to trigger a read-
ahead from user mode. It also implements a tree walk in the traditional way.

A simple demonstration from my 7-disk test btrfs:
 - enumerating the extent tree (traditional): 351s
 - enumerating the extent tree (readahead): 41s
 - enumerating extents+csum tree (readahead): 49s

The implementation is also tested with this tool in various combinations of
parallel reads of the same and of different trees.

The main changes from v1 are:
 - Switch from extent_state flags to extent_buffer flags.
 - Fix a race when triggering the read.
 - Fix a bug where only parts of the requested range where actually prefetched.
   The hit only when requesting parts of a tree, so the above numbers doesn't
   change.
Change from v2:
 - use rcu instead of transaction to protect root->node

Arne Jansen (6):
  btrfs: add READAHEAD extent buffer flag
  btrfs: state information for readahead
  btrfs: initial readahead code and prototypes
  btrfs: hooks for readahead
  btrfs: test ioctl for readahead
  btrfs: use readahead API for scrub

 fs/btrfs/Makefile    |    3 +-
 fs/btrfs/ctree.h     |   13 +
 fs/btrfs/disk-io.c   |   80 ++++
 fs/btrfs/disk-io.h   |    2 +
 fs/btrfs/extent_io.c |    2 +-
 fs/btrfs/extent_io.h |    1 +
 fs/btrfs/ioctl.c     |   93 +++++-
 fs/btrfs/ioctl.h     |   16 +
 fs/btrfs/reada.c     |  994 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/scrub.c     |  116 +++----
 fs/btrfs/volumes.c   |    8 +
 fs/btrfs/volumes.h   |    8 +
 12 files changed, 1267 insertions(+), 69 deletions(-)
 create mode 100644 fs/btrfs/reada.c

-- 
1.7.3.4

