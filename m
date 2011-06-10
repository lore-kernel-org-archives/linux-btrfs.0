From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v2 0/6] btrfs: generic readeahead interface
Date: Fri, 10 Jun 2011 14:57:10 +0200
Message-ID: <cover.1307710254.git.sensille@gmx.net>
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
A tool to send the ioctl follows shortly.

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

Arne Jansen (6):
  btrfs: add an extra wait mode to read_extent_buffer_pages
  btrfs: add READAHEAD extent buffer flag
  btrfs: state information for readahead
  btrfs: initial readahead code and prototypes
  btrfs: hooks for readahead
  btrfs: test ioctl for readahead

 fs/btrfs/Makefile    |    3 +-
 fs/btrfs/ctree.h     |   13 +
 fs/btrfs/disk-io.c   |   84 ++++-
 fs/btrfs/disk-io.h   |    2 +
 fs/btrfs/extent_io.c |    8 +-
 fs/btrfs/extent_io.h |    4 +-
 fs/btrfs/ioctl.c     |   93 +++++-
 fs/btrfs/ioctl.h     |   16 +
 fs/btrfs/reada.c     |  997 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c   |    8 +
 fs/btrfs/volumes.h   |    8 +
 11 files changed, 1225 insertions(+), 11 deletions(-)
 create mode 100644 fs/btrfs/reada.c

-- 
1.7.3.4

