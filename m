From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH 0/7] Btrfs: Progs modifications to introduce speed profiles and dedicated log devices
Date: Tue,  1 Feb 2011 14:54:43 +0100
Message-ID: <1296568490-13264-1-git-send-email-list.btrfs@jan-o-sch.net>
Cc: chris.mason@oracle.com, sensille@gmx.net
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch set for progs accompanies the (largish) kernel patch
submitted by Arne Jansen three days ago (Subject: [PATCH] Btrfs:
introducing speed profiles and dedicated log devices). It provides a
first implementation of (yet static) speed profiles:

"mkfs.btrfs" and "btrfs device add" now both support device classes.
Thus, it is posible to dedicate a device to the log tree (e.g. a fast
ssd), or decide another should hold metadata only.

Fully configurable speed profiles can be the next step.


Jan Schmidt (7):
  moved parse_size() to utils.c
  pulled current kernel version of ioctl.h
  check open_ctree() right after it returned
  speed classes (needed for profiles) for device add. subsequent patch
    needed to fix mkfs
  speed classes (needed for profiles) for mkfs
  debug-tree output: device speed added; type output switched to hex
  made btrfs-vol compile. looks unused, so no speed class support here
    for now.

 btrfs-vol.c   |    3 +-
 btrfs.c       |    2 +-
 btrfs_cmds.c  |   93 ++++++++++++++++++++--------------
 ctree.h       |   20 +++++++
 extent-tree.c |   11 +++--
 ioctl-test.c  |    1 +
 ioctl.h       |   57 +++++++++++++++++---
 mkfs.c        |  158 +++++++++++++++++++++++++++++++++++----------------------
 print-tree.c  |    7 ++-
 utils.c       |   55 ++++++++++++++++++--
 utils.h       |   13 ++++-
 volumes.c     |   13 ++++-
 volumes.h     |    6 ++-
 13 files changed, 311 insertions(+), 128 deletions(-)

-- 
1.7.2.2

