From: Hubert Kario <kario@wit.edu.pl>
Subject: [PATCH v2 0/5] Allow for quick removing of btrfs signature from block device
Date: Tue,  1 May 2012 14:38:01 +0200
Message-ID: <1335875886-12087-1-git-send-email-kario@wit.edu.pl>
Cc: Hubert Kario <kario@wit.edu.pl>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If there is a btrfs created on a raw block device (raw disk) and later there
are created partitions and btrfs file systems created on partitions, subsequent
`btrfs device scan` won't remove the btrfs signature from the raw block device.

This patch series adds `btrfs device zero super <dev>` command to remove the
btrfs signature from the device as well as fix few minor problems in
btrfs_prepare_device function.

This obsoletes my previous patch "btrfs: add command to zero out superblock".

V1->V2 changes: better error reporting when there are problems with only one
of the devices passed as parameters.

Hubert Kario (5):
  btrfs: add command to zero out superblock
  handle null pointers in btrfs_prepare_device
  Remove unused option in btrfs_prepare_device
  better error handling in btrfs_prepare_device()
  btrfs: remove unused variables

 btrfs-vol.c    |    2 +-
 cmds-device.c  |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 man/btrfs.8.in |    7 +++++++
 mkfs.c         |   12 ++++++------
 utils.c        |   41 ++++++++++++++++++++++++-----------------
 utils.h        |    4 ++--
 6 files changed, 84 insertions(+), 27 deletions(-)

-- 
1.7.10

