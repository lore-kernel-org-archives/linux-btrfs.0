Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34058 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934390AbdBQOoB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:01 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so2931008wmi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:01 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 13/38] btrfs: ale btrfs_delalloc_release_metadata take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:04 +0200
Message-Id: <1487342609-20652-14-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h            |  2 +-
 fs/btrfs/extent-tree.c      | 18 +++++++++---------
 fs/btrfs/file.c             |  4 ++--
 fs/btrfs/free-space-cache.c |  2 +-
 fs/btrfs/inode-map.c        |  2 +-
 fs/btrfs/inode.c            |  6 +++---
 fs/btrfs/relocation.c       |  4 ++--
 7 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 23dcc42f479b..7f7f3b60a73d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2704,7 +2704,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 				      struct btrfs_block_rsv *rsv);
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes);
-void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
+void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes);
 int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
 void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 746c7700317e..84b61b53ed25 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6081,27 +6081,27 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
  * once we complete IO for a given set of bytes to release their metadata
  * reservations.
  */
-void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
+void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	u64 to_free = 0;
 	unsigned dropped;
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
-	spin_lock(&BTRFS_I(inode)->lock);
-	dropped = drop_outstanding_extent(BTRFS_I(inode), num_bytes);
+	spin_lock(&inode->lock);
+	dropped = drop_outstanding_extent(inode, num_bytes);
 
 	if (num_bytes)
-		to_free = calc_csum_metadata_size(BTRFS_I(inode), num_bytes, 0);
-	spin_unlock(&BTRFS_I(inode)->lock);
+		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
+	spin_unlock(&inode->lock);
 	if (dropped > 0)
 		to_free += btrfs_calc_trans_metadata_size(fs_info, dropped);
 
 	if (btrfs_is_testing(fs_info))
 		return;
 
-	trace_btrfs_space_reservation(fs_info, "delalloc",
-				      btrfs_ino(BTRFS_I(inode)), to_free, 0);
+	trace_btrfs_space_reservation(fs_info, "delalloc", btrfs_ino(inode), 
+								to_free, 0);
 
 	btrfs_block_rsv_release(fs_info, &fs_info->delalloc_block_rsv, to_free);
 }
@@ -6159,7 +6159,7 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
  */
 void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len)
 {
-	btrfs_delalloc_release_metadata(inode, len);
+	btrfs_delalloc_release_metadata(BTRFS_I(inode), len);
 	btrfs_free_reserved_data_space(inode, start, len);
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0e4ac5969f6e..1e98e0673684 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1677,7 +1677,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				spin_unlock(&BTRFS_I(inode)->lock);
 			}
 			if (only_release_metadata) {
-				btrfs_delalloc_release_metadata(inode,
+				btrfs_delalloc_release_metadata(BTRFS_I(inode),
 								release_bytes);
 			} else {
 				u64 __pos;
@@ -1738,7 +1738,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	if (release_bytes) {
 		if (only_release_metadata) {
 			btrfs_end_write_no_snapshoting(root);
-			btrfs_delalloc_release_metadata(inode, release_bytes);
+			btrfs_delalloc_release_metadata(BTRFS_I(inode), release_bytes);
 		} else {
 			btrfs_delalloc_release_space(inode,
 						round_down(pos, fs_info->sectorsize),
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c0f313cbbbf2..b9b5d30bd1a4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3545,7 +3545,7 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 
 	if (ret) {
 		if (release_metadata)
-			btrfs_delalloc_release_metadata(inode, inode->i_size);
+			btrfs_delalloc_release_metadata(BTRFS_I(inode), inode->i_size);
 #ifdef DEBUG
 		btrfs_err(fs_info,
 			  "failed to write free ino cache for root %llu",
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 3bbb8f095953..5c6c20ec64d8 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -499,7 +499,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
 	if (ret) {
-		btrfs_delalloc_release_metadata(inode, prealloc);
+		btrfs_delalloc_release_metadata(BTRFS_I(inode), prealloc);
 		goto out_put;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4b8ba233d20e..34cd64720eda 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -316,7 +316,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	}
 
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
-	btrfs_delalloc_release_metadata(inode, end + 1 - start);
+	btrfs_delalloc_release_metadata(BTRFS_I(inode), end + 1 - start);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 out:
 	/*
@@ -1743,7 +1743,7 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		 */
 		if (*bits & EXTENT_DO_ACCOUNTING &&
 		    root != fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len);
+			btrfs_delalloc_release_metadata(BTRFS_I(inode), len);
 
 		/* For sanity tests. */
 		if (btrfs_is_testing(fs_info))
@@ -2920,7 +2920,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
 out:
 	if (root != fs_info->tree_root)
-		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
+		btrfs_delalloc_release_metadata(BTRFS_I(inode), ordered_extent->len);
 	if (trans)
 		btrfs_end_transaction(trans);
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 33cd6f873834..59ae36df3550 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3215,7 +3215,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			page = find_or_create_page(inode->i_mapping, index,
 						   mask);
 			if (!page) {
-				btrfs_delalloc_release_metadata(inode,
+				btrfs_delalloc_release_metadata(BTRFS_I(inode),
 							PAGE_SIZE);
 				ret = -ENOMEM;
 				goto out;
@@ -3234,7 +3234,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			if (!PageUptodate(page)) {
 				unlock_page(page);
 				put_page(page);
-				btrfs_delalloc_release_metadata(inode,
+				btrfs_delalloc_release_metadata(BTRFS_I(inode),
 							PAGE_SIZE);
 				ret = -EIO;
 				goto out;
-- 
2.7.4

