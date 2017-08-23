Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:35956 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753057AbdHWGqN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 02:46:13 -0400
Received: by mail-pg0-f44.google.com with SMTP id 83so3988056pgb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 23:46:13 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 0/7] Btrfs: bugs found by sparse and RCU strings
Date: Tue, 22 Aug 2017 23:45:58 -0700
Message-Id: <cover.1503470354.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

I came across my ancient RCU string branch [1] and decided to revive it
and finally put it to rest. In the process of checking it with sparse, I
found a handful of other issues.

Patch 1 should probably go in 4.13, as it fixes bugs introduced this
cycle by the conversion to blk_status_t. Patch 2 is an old bug, so it
could wait for 4.14 but it might as well go in for 4.13. Patches 3-5 are
the RCU string series. Patches 6 and 7 are minor cleanups found by
sparse. Patches 3-7 can wait for 4.14 or 4.15.

Based on 4.13-rc6.

Thanks!

1: https://lwn.net/Articles/629048/

Omar Sandoval (7):
  Btrfs: fix blk_status_t/errno confusion
  Btrfs: fix incorrect {node,sector}size endianness from
    BTRFS_IOC_FS_INFO
  Move Btrfs RCU string to common library
  Btrfs: refactor btrfs_device->name updates
  Btrfs: fix suspicious RCU in BTRFS_IOC_DEV_INFO
  Btrfs: make some volumes.c functions static
  Btrfs: fix __user casting in ioctl.c

 fs/btrfs/check-integrity.c |  12 +--
 fs/btrfs/dev-replace.c     |  37 +++++----
 fs/btrfs/disk-io.c         |  10 +--
 fs/btrfs/extent_io.c       |   8 +-
 fs/btrfs/inode.c           |  70 ++++++++--------
 fs/btrfs/ioctl.c           |  30 +++----
 fs/btrfs/raid56.c          |  35 ++++----
 fs/btrfs/rcu-string.h      |  56 -------------
 fs/btrfs/scrub.c           |  42 +++++-----
 fs/btrfs/super.c           |   7 +-
 fs/btrfs/volumes.c         | 199 +++++++++++++++++++++++++++------------------
 fs/btrfs/volumes.h         |   8 +-
 include/linux/rcustring.h  |  97 ++++++++++++++++++++++
 13 files changed, 351 insertions(+), 260 deletions(-)
 delete mode 100644 fs/btrfs/rcu-string.h
 create mode 100644 include/linux/rcustring.h

-- 
2.14.1

