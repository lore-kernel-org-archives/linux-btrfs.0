Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaCFFxh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:37 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265rUfd009849
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:53:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 08/10] Btrfs: split the global ordered extents mutex
Date: Thu, 6 Mar 2014 13:55:02 +0800
Message-Id: <1394085304-32589-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
References: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we create a snapshot, we just need wait the ordered extents in
the source fs/file root, but because we use the global mutex to protect
this ordered extents list of the source fs/file root to avoid accessing
a empty list, if someone got the mutex to access the ordered extents list
of the other fs/file root, we had to wait.

This patch splits the above global mutex, now every fs/file root has
its own mutex to protect its own list.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- New patch.
---
 fs/btrfs/ctree.h        |  2 ++
 fs/btrfs/disk-io.c      |  1 +
 fs/btrfs/ordered-data.c | 17 ++++-------------
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2f3949b..7bae97e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1806,6 +1806,8 @@ struct btrfs_root {
 	struct list_head delalloc_inodes;
 	struct list_head delalloc_root;
 	u64 nr_delalloc_inodes;
+
+	struct mutex ordered_extent_mutex;
 	/*
 	 * this is used by the balancing code to wait for all the pending
 	 * ordered extents
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index de6a48f..65fe26e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1197,6 +1197,7 @@ static void __setup_root(u32 nodesize, u32 leafsize, u32 sectorsize,
 	spin_lock_init(&root->log_extents_lock[1]);
 	mutex_init(&root->objectid_mutex);
 	mutex_init(&root->log_mutex);
+	mutex_init(&root->ordered_extent_mutex);
 	init_waitqueue_head(&root->log_writer_wait);
 	init_waitqueue_head(&root->log_commit_wait[0]);
 	init_waitqueue_head(&root->log_commit_wait[1]);
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 067e129..2849485 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -595,7 +595,7 @@ static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
  * wait for all the ordered extents in a root.  This is done when balancing
  * space between drives.
  */
-static int __btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
+int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
 {
 	struct list_head splice, works;
 	struct btrfs_ordered_extent *ordered, *next;
@@ -604,6 +604,7 @@ static int __btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
 	INIT_LIST_HEAD(&splice);
 	INIT_LIST_HEAD(&works);
 
+	mutex_lock(&root->ordered_extent_mutex);
 	spin_lock(&root->ordered_extent_lock);
 	list_splice_init(&root->ordered_extents, &splice);
 	while (!list_empty(&splice) && nr) {
@@ -634,17 +635,7 @@ static int __btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
 		btrfs_put_ordered_extent(ordered);
 		cond_resched();
 	}
-
-	return count;
-}
-
-int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
-{
-	int count;
-
-	mutex_lock(&root->fs_info->ordered_operations_mutex);
-	count = __btrfs_wait_ordered_extents(root, nr);
-	mutex_unlock(&root->fs_info->ordered_operations_mutex);
+	mutex_unlock(&root->ordered_extent_mutex);
 
 	return count;
 }
@@ -669,7 +660,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr)
 			       &fs_info->ordered_roots);
 		spin_unlock(&fs_info->ordered_root_lock);
 
-		done = __btrfs_wait_ordered_extents(root, nr);
+		done = btrfs_wait_ordered_extents(root, nr);
 		btrfs_put_fs_root(root);
 
 		spin_lock(&fs_info->ordered_root_lock);
-- 
1.8.1.4

