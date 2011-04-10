From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v5 0/8] Balance management, userspace
Date: Sun, 10 Apr 2011 22:16:26 +0100
Message-ID: <cover.1302469689.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   Hi, Chris,

   These patches form the userspace side of the balance management
work. This includes two patches to add one-off and polled monitoring,
a fork-to-background patch, and a sequence implementing the user
interface to handle the various types of balance filtering implemented
in the kernel-side patches.

   Hugo.

---

Hugo Mills (8):
  Balance progress monitoring.
  Add --monitor option to btrfs balance progress.
  User-space tool for cancelling balance operations.
  Run userspace tool in background for balances.
  Initial implementation of userspace interface for filtered balancing.
  Balance filter by device ID
  Balance filter for virtual address range
  Interface for device range balance filter

 btrfs.c        |   18 ++-
 btrfs_cmds.c   |  463 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 btrfs_cmds.h   |    2 +
 ioctl.h        |   46 ++++++
 man/btrfs.8.in |   79 +++++++++-
 5 files changed, 596 insertions(+), 12 deletions(-)

-- 
1.7.2.5

