From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v4 0/8] Balance management
Date: Thu,  7 Apr 2011 18:06:07 +0100
Message-ID: <1302195975-3088-1-git-send-email-hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[Let's try that again in separate emails, shall we? I'm an idiot.]

   Hi, Chris,

   This is a rebased version of my original balance management patches
to the latest kernel. I also include a series of patches which
introduce filtered or partial balances. With these patches, it is
possible to rebalance chunks on the basis of:

 * their chunk flags
 * residency on any device
 * physical block device address
 * logical btrfs-internal address

with a clean infrastructure for implementing further balance filters,
and a forward-compatible ioctl for starting filters.

   Hugo.

---

Hugo Mills (8):
  btrfs: Balance progress monitoring
  btrfs: Cancel filesystem balance
  btrfs: Factor out enumeration of chunks to a separate function
  btrfs: Implement filtered balance ioctl
  btrfs: Balance filter for device ID
  btrfs: Balance filter for virtual address ranges
  btrfs: Replication-type information
  btrfs: Balance filter for physical device address

 fs/btrfs/ctree.h   |   10 ++
 fs/btrfs/disk-io.c |    2 +
 fs/btrfs/ioctl.c   |  102 +++++++++++++++-
 fs/btrfs/ioctl.h   |   49 +++++++
 fs/btrfs/super.c   |   16 +--
 fs/btrfs/volumes.c |  353 ++++++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/volumes.h |   21 +++-
 7 files changed, 465 insertions(+), 88 deletions(-)

-- 
1.7.2.5

