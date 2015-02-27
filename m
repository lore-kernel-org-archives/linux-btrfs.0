Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33515 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754624AbbB0I0k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:26:40 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8Pl22019912
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:25:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/7] btrfs-progs: qgroup related enhance.
Date: Fri, 27 Feb 2015 16:26:32 +0800
Message-ID: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patchset include the following bugfix:
1) Update qgroup status flags to keep consistent with kernel

And the following enhancement:
1) debug-tree: Add human readable qgroup status flag.
2) qgroup show: Check status and print warning before if INCONSISTENT or
RESCANNING(*1)
3) parse_qgroup: Accept path and resolve it into qgroupid.
4) qgroup assign/remove: Auto schedule a rescan if the assign/remove
needs.(*2)

*1: The kernel has a bug that never clear INCONSISTENT flag, so need to
cooperate with the kernel patchset or warning is always output.

*2: Need to cooperate with the kernel patchset to detect such change.

Qu Wenruo (7):
  btrfs-progs: Update qgroup status flags and replace qgroup
    level/subvid     calculation with inline function.
  btrfs-progs: Allow btrfs-debug-tree to print human readable qgroup    
    status flag.
  btrfs-progs: Move parse_qgroupid() to utils.c
  btrfs-progs: Allow parse_qgroupid() to resolve subvolume path into    
    qgroupid.
  btrfs-progs: Add stack get/set functions for btrfs_qgroup_status_item.
  btrfs-progs: Print warning message if qgroup data is inconsistent.
  btrfs-progs: Schedule quota rescan if qgroup assign caused    
    inconsistence.

 cmds-qgroup.c | 26 ++++++++++++++++---
 ctree.h       | 26 ++++++++++++++++---
 print-tree.c  | 38 +++++++++++++++++++--------
 qgroup.c      | 82 +++++++++++++++++++++++++++++------------------------------
 qgroup.h      |  1 -
 utils.c       | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 utils.h       |  1 +
 7 files changed, 179 insertions(+), 61 deletions(-)

-- 
2.3.0

