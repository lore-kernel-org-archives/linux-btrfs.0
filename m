From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 0/5] fix bugs of sub transid
Date: Mon, 21 Nov 2011 18:10:19 +0800
Message-ID: <1321870224-20241-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <sensille@gmx.net>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

NOTE:
This patchset is based on "danger" branch.

We've been sufferring two big bugs with sub transid:
one is a bug related to root's last_snapshot, the other is a bug related to
disk extent refs' generation.

1) The first patch fixes a warning,
2) the second one fixes the last_snapshot bug,
3) the third one has already been in for-linus branch, but not in "danger"
   branch, so I add it here for the integrity,
4) the fourth one fixes a transid mismatch bug,
5) the fifth one fixes the disk extent refs' generation bug.

Any advices and tests are welcome!


Liu Bo (5):
  Btrfs: fix btrfs_copy_root warning
  Btrfs: fix bug with heavy snapshot and heavy fsync
  Btrfs: fix inconsistent tree
  Btrfs: filter shared blocks in should_cow_block
  Btrfs: update disk extent ref generation

 fs/btrfs/ctree.c       |   69 +++++++++++++++++++++++++++++++++------------
 fs/btrfs/ctree.h       |    8 ++++-
 fs/btrfs/delayed-ref.c |    7 ++++-
 fs/btrfs/delayed-ref.h |    2 +
 fs/btrfs/disk-io.c     |    3 +-
 fs/btrfs/extent-tree.c |   72 ++++++++++++++++++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/transaction.c |   10 ++++++-
 8 files changed, 137 insertions(+), 36 deletions(-)

