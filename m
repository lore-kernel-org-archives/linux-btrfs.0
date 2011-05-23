From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v1 0/5] btrfs: generic readeahead interface
Date: Mon, 23 May 2011 14:59:03 +0200
Message-ID: <cover.1306154794.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This series introduces a generic readahead interface for btrfs trees.
The intention is to use it to speed up scrub in a first run, but balance
is another hot candidate. In general, every tree walk could be accompanied
by a readahead. Deletion of large files comes to mind, where the fetching
of the csums takes most of the time.

To make testing easier, a simple ioctl interface is added to trigger a read-
ahead from user mode. It also implements a tree walk in the traditional way.
A tool to send the ioctl follows shortly.

A simple demonstration from my 7-disk test btrfs:
 - enumerating the extent tree (traditional): 351s
 - enumerating the extent tree (readahead): 41s
 - enumerating extents+csum tree (readahead): 49s

The implementation is also tested with this tool in various combinations of
parallel reads of the same and of different trees.

Arne Jansen (5):
  btrfs: add READAHEAD extent state
  btrfs: state information for readahead
  btrfs: initial readahead code and prototypes
  btrfs: hooks for readahead
  btrfs: test ioctl for readahead

 fs/btrfs/Makefile    |    2 +-
 fs/btrfs/ctree.h     |   13 +
 fs/btrfs/disk-io.c   |   56 +++
 fs/btrfs/disk-io.h   |    2 +
 fs/btrfs/extent_io.c |   12 +-
 fs/btrfs/extent_io.h |    1 +
 fs/btrfs/ioctl.c     |   86 +++++-
 fs/btrfs/ioctl.h     |   16 +
 fs/btrfs/reada.c     |  963 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.c   |    8 +
 fs/btrfs/volumes.h   |    8 +
 11 files changed, 1163 insertions(+), 4 deletions(-)
 create mode 100644 fs/btrfs/reada.c

-- 
1.7.3.4

