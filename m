From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] hold trans_mutex when using btrfs_record_root_in_trans
Date: Mon, 09 Feb 2009 21:31:45 +0800
Message-ID: <49903041.3060503@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: ukernel@gmail.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

we should hold the trans_mutex when using
btrfs_record_root_in_trans. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-02-05 07:27:07.330888295 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-02-09 10:40:22.000000000 +0800
@@ -5640,7 +5640,9 @@ static noinline int relocate_one_extent(
 			prev_block = block_start;
 		}
 
+		mutex_lock(&extent_root->fs_info->trans_mutex);
 		btrfs_record_root_in_trans(found_root);
+		mutex_unlock(&extent_root->fs_info->trans_mutex);
 		if (ref_path->owner_objectid >= BTRFS_FIRST_FREE_OBJECTID) {
 			/*
 			 * try to update data extent references while
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2009-01-23 06:01:32.800379519 +0800
+++ 2/fs/btrfs/transaction.c	2009-02-09 10:39:24.000000000 +0800
@@ -688,7 +688,9 @@ static noinline int drop_dirty_roots(str
 		num_bytes -= btrfs_root_used(&dirty->root->root_item);
 		bytes_used = btrfs_root_used(&root->root_item);
 		if (num_bytes) {
+			mutex_lock(&root->fs_info->trans_mutex);
 			btrfs_record_root_in_trans(root);
+			mutex_unlock(&root->fs_info->trans_mutex);
 			btrfs_set_root_used(&root->root_item,
 					    bytes_used - num_bytes);
 		}
diff -urp 1/fs/btrfs/tree-log.c 2/fs/btrfs/tree-log.c
--- 1/fs/btrfs/tree-log.c	2009-02-05 07:27:07.336888569 +0800
+++ 2/fs/btrfs/tree-log.c	2009-02-09 10:40:36.000000000 +0800
@@ -2832,7 +2832,9 @@ again:
 		BUG_ON(!wc.replay_dest);
 
 		wc.replay_dest->log_root = log;
+		mutex_lock(&fs_info->trans_mutex);
 		btrfs_record_root_in_trans(wc.replay_dest);
+		mutex_unlock(&fs_info->trans_mutex);
 		ret = walk_log_tree(trans, log, &wc);
 		BUG_ON(ret);
 
