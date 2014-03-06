Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20803 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaCFFxh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 00:53:37 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s265rRfV009842
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Mar 2014 13:53:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 01/10] Btrfs: fix early enospc due to the race of the two ordered extent wait
Date: Thu, 6 Mar 2014 13:54:55 +0800
Message-Id: <1394085304-32589-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_wait_ordered_roots() moves all the list entries to a new list,
and then deals with them one by one. But if the other task invokes this
function at that time, it would get a empty list. It makes the enospc
error happens more early. Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- New patch.
---
 fs/btrfs/ordered-data.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 138a7d7..a6ba75e 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -589,7 +589,7 @@ static void btrfs_run_ordered_extent_work(struct btrfs_work *work)
  * wait for all the ordered extents in a root.  This is done when balancing
  * space between drives.
  */
-int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
+static int __btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
 {
 	struct list_head splice, works;
 	struct btrfs_ordered_extent *ordered, *next;
@@ -598,7 +598,6 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
 	INIT_LIST_HEAD(&splice);
 	INIT_LIST_HEAD(&works);
 
-	mutex_lock(&root->fs_info->ordered_operations_mutex);
 	spin_lock(&root->ordered_extent_lock);
 	list_splice_init(&root->ordered_extents, &splice);
 	while (!list_empty(&splice) && nr) {
@@ -629,6 +628,16 @@ int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
 		btrfs_put_ordered_extent(ordered);
 		cond_resched();
 	}
+
+	return count;
+}
+
+int btrfs_wait_ordered_extents(struct btrfs_root *root, int nr)
+{
+	int count;
+
+	mutex_lock(&root->fs_info->ordered_operations_mutex);
+	count = __btrfs_wait_ordered_extents(root, nr);
 	mutex_unlock(&root->fs_info->ordered_operations_mutex);
 
 	return count;
@@ -642,6 +651,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr)
 
 	INIT_LIST_HEAD(&splice);
 
+	mutex_lock(&fs_info->ordered_operations_mutex);
 	spin_lock(&fs_info->ordered_root_lock);
 	list_splice_init(&fs_info->ordered_roots, &splice);
 	while (!list_empty(&splice) && nr) {
@@ -653,7 +663,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr)
 			       &fs_info->ordered_roots);
 		spin_unlock(&fs_info->ordered_root_lock);
 
-		done = btrfs_wait_ordered_extents(root, nr);
+		done = __btrfs_wait_ordered_extents(root, nr);
 		btrfs_put_fs_root(root);
 
 		spin_lock(&fs_info->ordered_root_lock);
@@ -664,6 +674,7 @@ void btrfs_wait_ordered_roots(struct btrfs_fs_info *fs_info, int nr)
 	}
 	list_splice_tail(&splice, &fs_info->ordered_roots);
 	spin_unlock(&fs_info->ordered_root_lock);
+	mutex_unlock(&fs_info->ordered_operations_mutex);
 }
 
 /*
-- 
1.8.1.4

