From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 0/3] Btrfs: add IO error device stats
Date: Fri,  9 Dec 2011 17:40:25 +0100
Message-ID: <cover.1323448299.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The goal is to detect when drives start to get an increased error rate,
when drives should be replaced soon. Therefore statistic counters are
added that count IO errors (read, write and flush). Additionally, the
software detected errors like checksum errors and corrupted blocks are
counted.

An ioctl interface is added to get the device statistic counters.
A second ioctl is added to atomically get and reset these counters.

The device statistics are written into the device tree with each
transaction commit. Only modified statistics are written.
When a filesystem is mounted, the device statistic for each involved
device are read from the device tree and used to initialize the
counters.

A patch for the btrfs-progs world will also be sent.

The patches are based on v3.1-161-gf4a8e65 (btrfs pull request from
12/1/2011).

Stefan Behrens (3):
  Btrfs: add device counters for detected IO and checksum errors
  Btrfs: add ioctl to get and reset the device stats
  Btrfs: read device stats on mount, write modified ones during commit

 fs/btrfs/ctree.h       |   51 ++++++++
 fs/btrfs/disk-io.c     |   25 +++-
 fs/btrfs/extent_io.c   |   27 ++++-
 fs/btrfs/ioctl.c       |   26 ++++
 fs/btrfs/ioctl.h       |   27 ++++
 fs/btrfs/print-tree.c  |    3 +
 fs/btrfs/scrub.c       |   52 ++++++--
 fs/btrfs/transaction.c |    4 +
 fs/btrfs/volumes.c     |  335 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h     |   43 ++++++
 10 files changed, 575 insertions(+), 18 deletions(-)

-- 
1.7.3.4

