Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:23677 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab2INJAF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 05:00:05 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q8E9046u007433
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 09:00:05 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q8E9046U004323
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 09:00:04 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q8E903Vr025573
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 04:00:03 -0500
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] Btrfs: kill obsolete arguments in btrfs_wait_ordered_extents
Date: Fri, 14 Sep 2012 16:58:07 +0800
Message-Id: <1347613087-3489-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

nocow_only is now an obsolete argument.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent-tree.c  |    4 ++--
 fs/btrfs/ordered-data.c |   12 +-----------
 fs/btrfs/ordered-data.h |    3 +--
 fs/btrfs/relocation.c   |    2 +-
 fs/btrfs/super.c        |    2 +-
 fs/btrfs/transaction.c  |    2 +-
 6 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6575f89..2d2aa04 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3693,7 +3693,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	if (delalloc_bytes == 0) {
 		if (trans)
 			return;
-		btrfs_wait_ordered_extents(root, 0, 0);
+		btrfs_wait_ordered_extents(root, 0);
 		return;
 	}
 
@@ -3715,7 +3715,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 
 		loops++;
 		if (wait_ordered && !trans) {
-			btrfs_wait_ordered_extents(root, 0, 0);
+			btrfs_wait_ordered_extents(root, 0);
 		} else {
 			time_left = schedule_timeout_killable(1);
 			if (time_left)
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 643335a..7efedee 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -466,8 +466,7 @@ void btrfs_remove_ordered_extent(struct inode *inode,
  * wait for all the ordered extents in a root.  This is done when balancing
  * space between drives.
  */
-void btrfs_wait_ordered_extents(struct btrfs_root *root,
-				int nocow_only, int delay_iput)
+void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput)
 {
 	struct list_head splice;
 	struct list_head *cur;
@@ -482,15 +481,6 @@ void btrfs_wait_ordered_extents(struct btrfs_root *root,
 		cur = splice.next;
 		ordered = list_entry(cur, struct btrfs_ordered_extent,
 				     root_extent_list);
-		if (nocow_only &&
-		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags) &&
-		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags)) {
-			list_move(&ordered->root_extent_list,
-				  &root->fs_info->ordered_extents);
-			cond_resched_lock(&root->fs_info->ordered_extent_lock);
-			continue;
-		}
-
 		list_del_init(&ordered->root_extent_list);
 		atomic_inc(&ordered->refs);
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index e03c560..fd36800 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -183,6 +183,5 @@ void btrfs_run_ordered_operations(struct btrfs_root *root, int wait);
 void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
 				 struct inode *inode);
-void btrfs_wait_ordered_extents(struct btrfs_root *root,
-				int nocow_only, int delay_iput);
+void btrfs_wait_ordered_extents(struct btrfs_root *root, int delay_iput);
 #endif
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4da0865..cf56929 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4057,7 +4057,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	       (unsigned long long)rc->block_group->flags);
 
 	btrfs_start_delalloc_inodes(fs_info->tree_root, 0);
-	btrfs_wait_ordered_extents(fs_info->tree_root, 0, 0);
+	btrfs_wait_ordered_extents(fs_info->tree_root, 0);
 
 	while (1) {
 		mutex_lock(&fs_info->cleaner_mutex);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 02a3961..f4b4368 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -850,7 +850,7 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
 		return 0;
 	}
 
-	btrfs_wait_ordered_extents(root, 0, 0);
+	btrfs_wait_ordered_extents(root, 0);
 
 	trans = btrfs_join_transaction_only(root);
 	if (IS_ERR(trans))
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index a36ae05..cb791d4 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1429,7 +1429,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 		if (flush_on_commit || snap_pending) {
 			btrfs_start_delalloc_inodes(root, 1);
-			btrfs_wait_ordered_extents(root, 0, 1);
+			btrfs_wait_ordered_extents(root, 1);
 		}
 
 		ret = btrfs_run_delayed_items(trans, root);
-- 
1.7.7.6

