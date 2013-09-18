Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47628 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab3IRIaV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 04:30:21 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8I8UFxS030186
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 16:30:16 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] add super-recover tool to recover bad supers
Date: Wed, 18 Sep 2013 16:27:32 +0800
Message-Id: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Until now if one of device's first superblock is corrupt,btrfs will
fail to mount. Luckily, btrfs have at least two superblocks for
every disk.

In theory, if silent corrupting happens when we are writting
superblocks into disk, we must hold at least one good superblock.

One side effect is that user must gurantee that the disk must be
a btrfs disk. Otherwise, this tool may destroy other fs.(This is
also reason why btrfs only use first superblock in every disk to mount)

This little program will scan devices and find good superblocks
(max generation, checksum matched). And use this superblock to
recover bad superblocks.The process is:

Step1: scan btrfs devices
Step2: find good supers
Step3: open ctree
Step4: writ all supers

We pass the latest good supers into open_ctree() and open_ctree()
will recalucate every superblock's dev_item by searching chunk tree.

Notice: This patchset based on David's dev/rescue branch

Wang Shilong (4):
  Btrfs-progs: do not run ioctls in check_mounted_where()
  Btrfs-progs: pass flag to control whether run ioctl in
    btrfs_scan_for_fsid()
  Btrfs-progs: move ask_user() to utils.c
  Btrfs-progs: add super-recover to recover bad supers

 Makefile          |   2 +-
 btrfs-find-root.c |   2 +-
 chunk-recover.c   |  20 +---
 cmds-rescue.c     |  55 ++++++++++
 commands.h        |   2 +
 disk-io.c         |  37 +++++--
 disk-io.h         |   5 +-
 super-recover.c   | 323 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.c           |  20 +++-
 utils.h           |   1 +
 10 files changed, 437 insertions(+), 30 deletions(-)
 create mode 100644 super-recover.c

-- 
1.8.3.1

