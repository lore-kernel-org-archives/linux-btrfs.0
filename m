Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14543 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755018AbbB0IYc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:24:32 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8NbtB019758
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:23:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/7] Qgroup status flag fix and semi-automatic qgroup update on relationship assign
Date: Fri, 27 Feb 2015 16:24:21 +0800
Message-ID: <1425025468-29749-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patchset will do the following bug fix mostly on incorrect flags.
1) INCONSISTENT flag never cleared bug
2) RESCANNING flag never cleared unless umount.

Also add 2 qgroup level related checks:
1) Kernel check on qgroup assign to ensure dst's level is higher than
src.
2) Restrict qgroup id under 1<<48, to ensure qgroup id won't have level
higher than 1.

At last, add semi-automatic qgroup info update on relationship assign.
The automatic part only happens when all extents of src are exclusive.
If not, it will set INCONSISTENT flag and return >0 to info user land
progs to do rescan.

Dongsheng Yang (1):
  btrfs: qgroup: clear STATUS_FLAG_ON in disabling quota.

Qu Wenruo (6):
  btrfs: Check qgroup level in kernel qgroup assign.
  btrfs: Don't allow subvolid >= (1 << BTRFS_QGROUP_LEVEL_SHIFT) to be  
      created
  btrfs: qgroup: Fix dead judgement on qgroup_rescan_leaf() return
    value.
  btrfs: Update btrfs qgroup status item when rescan is done.
  btrfs: quota: Automatically update related qgroups or mark
    INCONSISTENT     flags when assigning/deleting a qgroup relations.
  btrfs: quota: Update quota tree after qgroup relationship change.

 fs/btrfs/ctree.h  |   9 ++-
 fs/btrfs/ioctl.c  |  12 ++++
 fs/btrfs/qgroup.c | 203 ++++++++++++++++++++++++++++++++++++++++--------------
 3 files changed, 170 insertions(+), 54 deletions(-)

-- 
2.3.0

