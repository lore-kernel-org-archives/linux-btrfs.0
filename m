Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:51415 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab3LQJbq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 04:31:46 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBH9V6EG027097
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 17:31:09 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: quwenruo@cn.fujitsu.com
Subject: [PATCH v4 00/18] Replace btrfs_workers with kernel workqueue based btrfs_workqueue
Date: Tue, 17 Dec 2013 17:31:41 +0800
Message-Id: <1387272719-11889-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add a new btrfs_workqueue_struct which use kernel workqueue to implement
most of the original btrfs_workers, to replace btrfs_workers.

With this patchset, redundant workqueue codes are replaced with kernel
workqueue infrastructure, which not only reduces the code size but also the
effort to maintain it.

The result from sysbench shows minor improvement on the following server:
CPU: two-way Xeon X5660
RAM: 4G 
HDD: SAS HDD, 150G total, 100G partition for btrfs test

Test result on default mount option:
https://docs.google.com/spreadsheet/ccc?key=0AhpkL3ehzX3pdENjajJTWFg5d1BWbExnYWFpMTJxeUE&usp=sharing

Test result on "-o compress" mount option:
https://docs.google.com/spreadsheet/ccc?key=0AhpkL3ehzX3pdHdTTEJ6OW96SXJFaDR5enB1SzMzc0E&usp=sharing

Changelog:
v1->v2:
  - Fix some workqueue flags.
v2->v3:
  - Add the thresholding mechanism to simulate the old behavior
  - Convert all the btrfs_workers to btrfs_workrqueue_struct.
  - Fix some potential deadlock when executed in IRQ handler.
v3->v4:
  - Change the ordered workqueue implement to fix the performance drop in 32K
    multi thread random write.
  - Change the high priority workqueue implement to get an independent high
    workqueue without starving problem.
  - Simplify the btrfs_alloc_workqueue parameters.
  - Coding style cleanup.
  - Remove the redundant "_struct" suffix.

Qu Wenruo (18):
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
  btrfs: Cleanup the "_struct" suffix in btrfs_workequeue

 fs/btrfs/async-thread.c  | 821 ++++++++++++-----------------------------------
 fs/btrfs/async-thread.h  | 117 ++-----
 fs/btrfs/ctree.h         |  39 ++-
 fs/btrfs/delayed-inode.c |   6 +-
 fs/btrfs/disk-io.c       | 212 +++++-------
 fs/btrfs/extent-tree.c   |   4 +-
 fs/btrfs/inode.c         |  38 +--
 fs/btrfs/ordered-data.c  |  11 +-
 fs/btrfs/qgroup.c        |  15 +-
 fs/btrfs/raid56.c        |  21 +-
 fs/btrfs/reada.c         |   4 +-
 fs/btrfs/scrub.c         |  70 ++--
 fs/btrfs/super.c         |  36 +--
 fs/btrfs/volumes.c       |  16 +-
 14 files changed, 430 insertions(+), 980 deletions(-)

-- 
1.8.5.1

