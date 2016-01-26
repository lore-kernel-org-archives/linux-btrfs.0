Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54594 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934061AbcAZLGM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 06:06:12 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
	by cn.fujitsu.com (Postfix) with ESMTP id 2024D41824FC
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 19:05:33 +0800 (CST)
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/2] btrfs: reada: limit max works count
Date: Tue, 26 Jan 2016 19:04:06 +0800
Message-ID: <84455a12ceda75ad15a97cdbf01f99787eda0b89.1453806157.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

reada create 2 works for each level of tree in recursion.

In case of a tree having many levels, the number of created works
is 2^level_of_tree.
Actually we don't need so many works in parallel, this patch limit
max works to BTRFS_MAX_MIRRORS * 2.

The works_counter will also used for btrfs_reada_wait() to check
is there exist background workers.

Changelog v1->v2:
 Move works_counter from global lobal variable to btrfs_fs_info's
 member variable, to avoid too small workers when more than
 one FS mounted, noticed by: Chris Mason <clm@fb.com>

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/ctree.h   | 3 +++
 fs/btrfs/disk-io.c | 1 +
 fs/btrfs/reada.c   | 9 ++++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index c5592b1..904ed5c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1822,6 +1822,9 @@ struct btrfs_fs_info {
 	spinlock_t reada_lock;
 	struct radix_tree_root reada_tree;
 
+	/* readahead works cnt */
+	atomic_t reada_works_cnt;
+
 	/* Extent buffer radix tree */
 	spinlock_t buffer_lock;
 	struct radix_tree_root buffer_radix;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1e0693b..4656425 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2602,6 +2602,7 @@ int open_ctree(struct super_block *sb,
 	atomic_set(&fs_info->nr_async_bios, 0);
 	atomic_set(&fs_info->defrag_running, 0);
 	atomic_set(&fs_info->qgroup_op_seq, 0);
+	atomic_set(&fs_info->reada_works_cnt, 0);
 	atomic64_set(&fs_info->tree_mod_seq, 0);
 	fs_info->sb = sb;
 	fs_info->max_inline = BTRFS_DEFAULT_MAX_INLINE;
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 13818d8..245a961 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -748,6 +748,8 @@ static void reada_start_machine_worker(struct btrfs_work *work)
 	set_task_ioprio(current, BTRFS_IOPRIO_READA);
 	__reada_start_machine(fs_info);
 	set_task_ioprio(current, old_ioprio);
+
+	atomic_dec(&fs_info->reada_works_cnt);
 }
 
 static void __reada_start_machine(struct btrfs_fs_info *fs_info)
@@ -779,8 +781,12 @@ static void __reada_start_machine(struct btrfs_fs_info *fs_info)
 	 * enqueue to workers to finish it. This will distribute the load to
 	 * the cores.
 	 */
-	for (i = 0; i < 2; ++i)
+	for (i = 0; i < 2; ++i) {
 		reada_start_machine(fs_info);
+		if (atomic_read(&fs_info->reada_works_cnt) >
+		    BTRFS_MAX_MIRRORS * 2)
+			break;
+	}
 }
 
 static void reada_start_machine(struct btrfs_fs_info *fs_info)
@@ -797,6 +803,7 @@ static void reada_start_machine(struct btrfs_fs_info *fs_info)
 	rmw->fs_info = fs_info;
 
 	btrfs_queue_work(fs_info->readahead_workers, &rmw->work);
+	atomic_inc(&fs_info->reada_works_cnt);
 }
 
 #ifdef DEBUG
-- 
1.8.5.1



