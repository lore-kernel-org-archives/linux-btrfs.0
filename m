From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2 0/3] Btrfs: add IO error device stats
Date: Wed, 21 Dec 2011 17:05:07 +0100
Message-ID: <cover.1324480889.git.sbehrens@giantdisaster.de>
References: <4EE602E1.4020206@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE602E1.4020206@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Changes v1-v2:
- Remove restriction that BTRFS_IOC_GET_DEVICE_STATS is a privileged
  operation
- Cast u64 to unsigned long long for printf()

The goal is to detect when drives start to get an increased error rate,
when drives should be replaced soon. Therefore statistic counters are
added that count IO errors (read, write and flush). Additionally, the
software detected errors like checksum errors and corrupted blocks are
counted.

An ioctl interface is added to get the device statistic counters.
A second ioctl is added to atomically get and reset these counters.

The device statistics are written into the device tree with each
transaction commit. Only modified statistics are written.
When a filesystem is mounted, the device statistics for each involved
device are read from the device tree and used to initialize the
counters.

A patch for the btrfs-progs world will also be sent.

The patches are based on v3.1-182-gd85c8a6.

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

