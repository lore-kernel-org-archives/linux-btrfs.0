From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH v6 0/8] Balance management userspace
Date: Sun,  1 May 2011 16:47:08 +0100
Message-ID: <cover.1304262467.git.hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

   Hi, Chris,

   This series is the userspace patches corresponding to the
kernel-side balance management stuff. This iteration fixes a
use-after-free bug in the filtering code, and tidies up some of the
man pages/help.

   The patches are against the master branch of the tools repo.

   Hugo.

Hugo Mills (8):
  Balance progress monitoring.
  Add --monitor option to btrfs balance progress.
  User-space tool for cancelling balance operations.
  Run userspace tool in background for balances.
  Initial implementation of userspace interface for filtered balancing.
  Balance filter by device ID
  Balance filter for virtual address range
  Interface for device range balance filter

 btrfs.c        |   19 ++-
 btrfs_cmds.c   |  460 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 btrfs_cmds.h   |    2 +
 ioctl.h        |   46 ++++++
 man/btrfs.8.in |   81 +++++++++-
 5 files changed, 595 insertions(+), 13 deletions(-)

-- 
1.7.2.5

