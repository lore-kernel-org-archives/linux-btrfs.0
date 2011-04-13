From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: [PATCH 0/5] Add user-space support for read-only snapshot creation.
Date: Wed, 13 Apr 2011 11:12:09 +0200
Message-ID: <1302685934-15737-1-git-send-email-philipp.andreas@gmail.com>
Cc: Andreas Philipp <philipp.andreas@gmail.com>, lizf@cn.fujitsu.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There is kernel side support for the creation of read-only snapshots
for some time now, but I did not find any patches for the userspace
btrfs utilites. Thus I created this patchset which is tested and
working with kernel version 2.6.39-rc2.

Andreas Philipp (5):
  Add support for read-only subvolumes.
  Support the new parameters in do_clone(int argc, char** argv).
  Added support for an additional ioctl.
  Test the additional ioctl.
  Updated documentation for btrfs subvolume snapshot.

 btrfs.c        |    6 +++---
 btrfs_cmds.c   |   44 ++++++++++++++++++++++++++++++++++++--------
 ioctl-test.c   |    1 +
 ioctl.h        |   14 ++++++++++++++
 man/btrfs.8.in |   11 ++++++-----
 5 files changed, 60 insertions(+), 16 deletions(-)

-- 
1.7.4.1

