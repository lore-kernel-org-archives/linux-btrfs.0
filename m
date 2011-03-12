From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: [PATCH v1 0/3] btrfs-progs: scrub interface
Date: Sat, 12 Mar 2011 19:31:32 +0100
Message-ID: <cover.1299954564.git.list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch set for btrfs-progs is meant to be used together with the scrub kernel patches submitted by Arne Jansen (latest Subject: [PATCH v3 0/6] btrfs: scrub).

Short usage:
A scrub process for all devices of a (mounted) file system can be startet with:
btrfs filesystem scrub start /mnt/btrfs

A running scrub can be canceled with:
btrfs filesystem scrub cancel /mnt/btrfs

A canceled (manually or due to crash) scrub can be resumed with:
btrfs filesystem scrub start -r /mnt/btrfs

Status of running or finished scrub can be obtained with:
btrfs filesystem scrub status /mnt/btrfs

Any scrub sub-command has a short explanation of options when -h is used instead of a file system.

Thanks,
Jan

Jan Schmidt (3):
  commands added
  scrub ioctls
  added scrub functionality

 Makefile     |    4 +-
 btrfs.c      |   12 +
 btrfs_cmds.c |    3 +-
 btrfs_cmds.h |    4 +
 ctree.h      |    2 +-
 ioctl.h      |   68 +++-
 scrub.c      | 1425 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 1513 insertions(+), 5 deletions(-)
 create mode 100644 scrub.c

-- 
1.7.3.4

