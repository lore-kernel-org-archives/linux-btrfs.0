Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50884 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754130AbeDWHyW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 03:54:22 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 515D8ADE5
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Apr 2018 07:54:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/5] btrfs: Remove delayed_iput parameter of btrfs_start_delalloc_roots
Date: Mon, 23 Apr 2018 10:54:13 +0300
Message-Id: <1524470057-21969-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1524470057-21969-1-git-send-email-nborisov@suse.com>
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This parameter was introduced alongside the function in
eb73c1b7cea7 ("Btrfs: introduce per-subvolume delalloc inode list") to
avoid deadlocks since this function was used in the transaction commit
path. However, commit 8d875f95da43 ("btrfs: disable strict file flushes
for renames and truncates") removed that usage, rendering the parameter
obsolete.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/dev-replace.c | 2 +-
 fs/btrfs/extent-tree.c | 4 ++--
 fs/btrfs/inode.c       | 5 ++---
 fs/btrfs/ioctl.c       | 2 +-
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index aac3a8bfab51..8c5ab06ccc0a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3199,8 +3199,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			       u32 min_type);
 
 int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
-int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
-			       int nr);
+int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int nr);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state, int dedupe);
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index f82be266ba4b..a08b30052e06 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -503,7 +503,7 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 * flush all outstanding I/O and inode extent mappings before the
 	 * copy operation is declared as being finished
 	 */
-	ret = btrfs_start_delalloc_roots(fs_info, 0, -1);
+	ret = btrfs_start_delalloc_roots(fs_info, -1);
 	if (ret) {
 		mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
 		return ret;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 22ba5d500836..cf3cd23f274d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4337,7 +4337,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 			need_commit--;
 
 			if (need_commit > 0) {
-				btrfs_start_delalloc_roots(fs_info, 0, -1);
+				btrfs_start_delalloc_roots(fs_info, -1);
 				btrfs_wait_ordered_roots(fs_info, U64_MAX, 0,
 							 (u64)-1);
 			}
@@ -4790,7 +4790,7 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_fs_info *fs_info,
 		 * the filesystem is readonly(all dirty pages are written to
 		 * the disk).
 		 */
-		btrfs_start_delalloc_roots(fs_info, 0, nr_items);
+		btrfs_start_delalloc_roots(fs_info, nr_items);
 		if (!current->journal_info)
 			btrfs_wait_ordered_roots(fs_info, nr_items, 0, (u64)-1);
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c0a38917539d..74ea63159b93 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10268,8 +10268,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput)
 	return ret;
 }
 
-int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
-			       int nr)
+int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int nr)
 {
 	struct btrfs_root *root;
 	struct list_head splice;
@@ -10292,7 +10291,7 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
 			       &fs_info->delalloc_roots);
 		spin_unlock(&fs_info->delalloc_root_lock);
 
-		ret = __start_delalloc_inodes(root, delay_iput, nr);
+		ret = __start_delalloc_inodes(root, 0, nr);
 		btrfs_put_fs_root(root);
 		if (ret < 0)
 			goto out;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index de5dcdb87e97..ea192378cb3b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5316,7 +5316,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case BTRFS_IOC_SYNC: {
 		int ret;
 
-		ret = btrfs_start_delalloc_roots(fs_info, 0, -1);
+		ret = btrfs_start_delalloc_roots(fs_info, -1);
 		if (ret)
 			return ret;
 		ret = btrfs_sync_fs(inode->i_sb, 1);
-- 
2.7.4

