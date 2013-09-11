Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8360 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3IKIvz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 04:51:55 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8B8ppWj019950
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 16:51:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH 0/9] btrfs: Replace the btrfs_workers with kernel workqueue
Date: Wed, 11 Sep 2013 16:52:29 +0800
Message-Id: <1378889558-21514-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use kernel workqueue and kernel workqueue based new btrfs_workqueue_struct to replace
the old btrfs_workers.
The main goal is to reduce the redundant codes(800 lines vs 200 lines) and
try to get benefits from the latest workqueue changes.

About the performance, the test suite I used is bonnie++,
and there seems no significant regression.

The patched kernel get the following difference vs the 3.10 kernel on an HDD
with a two-way 4cores server.(10times each and compare the average)

putc:			-0.97%
getc:			+1.48%
random_del:		+2.38%
random_create:		-2.27%
seq_del			+0.94%

Other changes are smaller than 0.5% and can be ignored.
Since the tests are not enough and maybe unstable,
any further tests are welcome.

Qu Wenruo (9):
  btrfs: Cleanup the unused struct async_sched.
  btrfs: use kernel workqueue to replace the btrfs_workers functions
  btrfs: Added btrfs_workqueue_struct implemented ordered execution
    based on kernel workqueue
  btrfs: Add high priority workqueue support for btrfs_workqueue_struct
  btrfs: Use btrfs_workqueue_struct to replace the fs_info->workers
  btrfs: Use btrfs_workqueue_struct to replace the
    fs_info->delalloc_workers
  btrfs: Replace the fs_info->submit_workers with kernel workqueue.
  btrfs: Cleanup the old btrfs workqueue
  btrfs: Replace thread_pool_size with workqueue default value

 fs/btrfs/Makefile        |   5 +-
 fs/btrfs/async-thread.c  | 714 -----------------------------------------------
 fs/btrfs/async-thread.h  | 119 --------
 fs/btrfs/bwq.c           | 136 +++++++++
 fs/btrfs/bwq.h           |  67 +++++
 fs/btrfs/ctree.h         |  46 ++-
 fs/btrfs/delayed-inode.c |   9 +-
 fs/btrfs/dev-replace.c   |   1 -
 fs/btrfs/disk-io.c       | 238 ++++++----------
 fs/btrfs/extent-tree.c   |   6 +-
 fs/btrfs/inode.c         |  57 ++--
 fs/btrfs/ordered-data.c  |  11 +-
 fs/btrfs/ordered-data.h  |   4 +-
 fs/btrfs/qgroup.c        |  16 +-
 fs/btrfs/raid56.c        |  38 ++-
 fs/btrfs/reada.c         |   8 +-
 fs/btrfs/relocation.c    |   1 -
 fs/btrfs/scrub.c         |  78 +++---
 fs/btrfs/super.c         |  41 ++-
 fs/btrfs/volumes.c       |  25 +-
 fs/btrfs/volumes.h       |   3 +-
 21 files changed, 451 insertions(+), 1172 deletions(-)
 delete mode 100644 fs/btrfs/async-thread.c
 delete mode 100644 fs/btrfs/async-thread.h
 create mode 100644 fs/btrfs/bwq.c
 create mode 100644 fs/btrfs/bwq.h

-- 
1.8.4
