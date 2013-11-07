Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26709 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3KGFvR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 00:51:17 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA75pE7j008340
	for <linux-btrfs@vger.kernel.org>; Thu, 7 Nov 2013 13:51:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v3 00/17] Replace btrfs_workers with kernel workqueue based btrfs_workqueue_struct
Date: Thu, 7 Nov 2013 13:51:50 +0800
Message-Id: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new btrfs_workqueue_struct which use kernel workqueue to implement
most of the original btrfs_workers, to replace btrfs_workers.

With this patchset, redundant workqueue codes are replaced with kernel
workqueue infrastructure, which not only reduces the code size but also the
effort to maintain it.

More performace tests are ongoing, the result from sysbench shows minor
improvement on the following server:
CPU: two-way Xeon X5660
RAM: 4G 
HDD: SAS HDD, 150G total, 40G partition for btrfs test

Test result:
Mode|Num_threads|block size|extra flags|performance change vs 3.11 kernel
rndrd	1	4K	none		+1.22%
rndrd	1	32K	none		+1.00%
rndrd	8	32K	sync		+1.35%
seqrd	8	4K	direct		+5.56%
seqwr	8	4K	none		-1.26%
seqwr	8	32K	sync		+1.20%

Changes below 1% are not mentioned.
Overall the patchset doesn't change the performance on HDD.

Since more tests are needed, more test result are welcomed.

------
Changelog:
v1->v2:
  - Fix some workqueue flags.
v2->v3:
  - Add the thresholding mechanism to simulate the old behavior
  - Convert all the btrfs_workers to btrfs_workrqueue_struct.
  - Fix some potential deadlock when executed in IRQ handler.
------

Qu Wenruo (17):
  btrfs: Cleanup the unused struct async_sched.
  btrfs: Added btrfs_workqueue_struct implemented ordered execution
    based on kernel workqueue
  btrfs: Add high priority workqueue support for btrfs_workqueue_struct
  btrfs: Add threshold workqueue based on kernel workqueue
  btrfs: Replace fs_info->workers with btrfs_workqueue.
  btrfs: Replace fs_info->delalloc_workers with btrfs_workqueue
  btrfs: Replace fs_info->submit_workers with btrfs_workqueue.
  btrfs: Replace fs_info->flush_workers with btrfs_workqueue.
  btrfs: Replace fs_info->endio_* workqueue with btrfs_workqueue.
  btrfs: Replace fs_info->rmw_workers workqueue with btrfs_workqueue.
  btrfs: Replace fs_info->cache_workers workqueue with btrfs_workqueue.
  btrfs: Replace fs_info->readahead_workers workqueue with
    btrfs_workqueue.
  btrfs: Replace fs_info->fixup_workers workqueue with btrfs_workqueue.
  btrfs: Replace fs_info->delayed_workers workqueue with
    btrfs_workqueue.
  btrfs: Replace fs_info->qgroup_rescan_worker workqueue with
    btrfs_workqueue.
  btrfs: Replace fs_info->scrub_* workqueue with btrfs_workqueue.
  btrfs: Cleanup the old btrfs_worker.

 fs/btrfs/async-thread.c  | 821 ++++++++++-------------------------------------
 fs/btrfs/async-thread.h  | 152 ++++-----
 fs/btrfs/ctree.h         |  45 ++-
 fs/btrfs/delayed-inode.c |  10 +-
 fs/btrfs/disk-io.c       | 238 ++++++--------
 fs/btrfs/extent-tree.c   |   6 +-
 fs/btrfs/inode.c         |  53 ++-
 fs/btrfs/ordered-data.c  |  13 +-
 fs/btrfs/ordered-data.h  |   4 +-
 fs/btrfs/qgroup.c        |  17 +-
 fs/btrfs/raid56.c        |  33 +-
 fs/btrfs/reada.c         |  10 +-
 fs/btrfs/scrub.c         |  94 +++---
 fs/btrfs/super.c         |  36 +--
 fs/btrfs/volumes.c       |  18 +-
 fs/btrfs/volumes.h       |   2 +-
 16 files changed, 503 insertions(+), 1049 deletions(-)

-- 
1.8.4.2

