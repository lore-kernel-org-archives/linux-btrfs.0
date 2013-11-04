Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8230 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab3KDPMo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 10:12:44 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA4FCVjP031734
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 23:12:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 7/7] Btrfs: rename btrfs_start_all_delalloc_inodes
Date: Mon, 4 Nov 2013 23:13:26 +0800
Message-Id: <1383578006-22691-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

rename the function -- btrfs_start_all_delalloc_inodes(), and make its
name be compatible to btrfs_wait_ordered_roots(), since they are always
used at the same place.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/inode.c       | 3 +--
 fs/btrfs/relocation.c  | 2 +-
 fs/btrfs/transaction.c | 2 +-
 6 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0506f40..1fbfc21 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3675,8 +3675,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       u32 min_type);
 
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
-int btrfs_start_all_delalloc_inodes(struct btrfs_fs_info *fs_info,
-				    int delay_iput);
+int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      struct extent_state **cached_state);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index bc55b36..7436e08 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -470,7 +470,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 * flush all outstanding I/O and inode extent mappings before the
 	 * copy operation is declared as being finished
 	 */
-	ret = btrfs_start_all_delalloc_inodes(root->fs_info, 0);
+	ret = btrfs_start_delalloc_roots(root->fs_info, 0);
 	if (ret) {
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 410d972..0aad9ed 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3998,7 +3998,7 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 		 * the filesystem is readonly(all dirty pages are written to
 		 * the disk).
 		 */
-		btrfs_start_all_delalloc_inodes(root->fs_info, 0);
+		btrfs_start_delalloc_roots(root->fs_info, 0);
 		if (!current->journal_info)
 			btrfs_wait_ordered_roots(root->fs_info, -1);
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f4a6851..da618c4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8276,8 +8276,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	return ret;
 }
 
-int btrfs_start_all_delalloc_inodes(struct btrfs_fs_info *fs_info,
-				    int delay_iput)
+int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput)
 {
 	struct btrfs_root *root;
 	struct list_head splice;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0cec204..af41487 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4241,7 +4241,7 @@ int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
 	printk(KERN_INFO "btrfs: relocating block group %llu flags %llu\n",
 	       rc->block_group->key.objectid, rc->block_group->flags);
 
-	ret = btrfs_start_all_delalloc_inodes(fs_info, 0);
+	ret = btrfs_start_delalloc_roots(fs_info, 0);
 	if (ret < 0) {
 		err = ret;
 		goto out;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0fada5b..840e672 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1596,7 +1596,7 @@ static int btrfs_flush_all_pending_stuffs(struct btrfs_trans_handle *trans,
 static inline int btrfs_start_delalloc_flush(struct btrfs_fs_info *fs_info)
 {
 	if (btrfs_test_opt(fs_info->tree_root, FLUSHONCOMMIT))
-		return btrfs_start_all_delalloc_inodes(fs_info, 1);
+		return btrfs_start_delalloc_roots(fs_info, 1);
 	return 0;
 }
 
-- 
1.8.1.4

