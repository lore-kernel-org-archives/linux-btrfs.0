Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35307 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934247AbdBQOoE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:04 -0500
Received: by mail-wm0-f65.google.com with SMTP id u63so2925832wmu.2
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:04 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <n.borisov.lkml@gmail.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 16/38] btrfs: Make btrfs_drop_extent_cache take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:07 +0200
Message-Id: <1487342609-20652-17-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <n.borisov.lkml@gmail.com>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h      |  2 +-
 fs/btrfs/file.c       | 10 +++++-----
 fs/btrfs/inode.c      | 26 +++++++++++++-------------
 fs/btrfs/ioctl.c      |  2 +-
 fs/btrfs/relocation.c |  6 +++---
 5 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5246cbe4c17f..4db18e5dc8f9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3219,7 +3219,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
 void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info);
 int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync);
-void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
+void btrfs_drop_extent_cache(struct btrfs_inode *inode, u64 start, u64 end,
 			     int skip_pinned);
 extern const struct file_operations btrfs_file_operations;
 int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 18edcc74150c..37458605847a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -529,13 +529,13 @@ int btrfs_dirty_pages(struct inode *inode, struct page **pages,
  * this drops all the extents in the cache that intersect the range
  * [start, end].  Existing extents are split as required.
  */
-void btrfs_drop_extent_cache(struct inode *inode, u64 start, u64 end,
+void btrfs_drop_extent_cache(struct btrfs_inode *inode, u64 start, u64 end,
 			     int skip_pinned)
 {
 	struct extent_map *em;
 	struct extent_map *split = NULL;
 	struct extent_map *split2 = NULL;
-	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_map_tree *em_tree = &inode->extent_tree;
 	u64 len = end - start + 1;
 	u64 gen;
 	int ret;
@@ -720,7 +720,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	int leafs_visited = 0;
 
 	if (drop_cache)
-		btrfs_drop_extent_cache(inode, start, end - 1, 0);
+		btrfs_drop_extent_cache(BTRFS_I(inode), start, end - 1, 0);
 
 	if (start >= BTRFS_I(inode)->disk_i_size && !replace_extent)
 		modify_tree = 0;
@@ -2295,7 +2295,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 
 	hole_em = alloc_extent_map();
 	if (!hole_em) {
-		btrfs_drop_extent_cache(inode, offset, end - 1, 0);
+		btrfs_drop_extent_cache(BTRFS_I(inode), offset, end - 1, 0);
 		set_bit(BTRFS_INODE_NEEDS_FULL_SYNC,
 			&BTRFS_I(inode)->runtime_flags);
 	} else {
@@ -2312,7 +2312,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 		hole_em->generation = trans->transid;
 
 		do {
-			btrfs_drop_extent_cache(inode, offset, end - 1, 0);
+			btrfs_drop_extent_cache(BTRFS_I(inode), offset, end - 1, 0);
 			write_lock(&em_tree->lock);
 			ret = add_extent_mapping(em_tree, hole_em, 1);
 			write_unlock(&em_tree->lock);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4d81f83a2a5d..92e42a063639 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -317,7 +317,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
 	btrfs_delalloc_release_metadata(BTRFS_I(inode), end + 1 - start);
-	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
+	btrfs_drop_extent_cache(BTRFS_I(inode), start, aligned_end - 1, 0);
 out:
 	/*
 	 * Don't forget to free the reserved space, as for inlined extent
@@ -806,7 +806,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 						BTRFS_ORDERED_COMPRESSED,
 						async_extent->compress_type);
 		if (ret) {
-			btrfs_drop_extent_cache(inode, async_extent->start,
+			btrfs_drop_extent_cache(BTRFS_I(inode), async_extent->start,
 						async_extent->start +
 						async_extent->ram_size - 1, 0);
 			goto out_free_reserve;
@@ -971,7 +971,7 @@ static noinline int cow_file_range(struct inode *inode,
 	       btrfs_super_total_bytes(fs_info->super_copy));
 
 	alloc_hint = get_extent_allocation_hint(inode, start, num_bytes);
-	btrfs_drop_extent_cache(inode, start, start + num_bytes - 1, 0);
+	btrfs_drop_extent_cache(BTRFS_I(inode), start, start + num_bytes - 1, 0);
 
 	while (disk_num_bytes > 0) {
 		unsigned long op;
@@ -1039,7 +1039,7 @@ static noinline int cow_file_range(struct inode *inode,
 	return ret;
 
 out_drop_extent_cache:
-	btrfs_drop_extent_cache(inode, start, start + ram_size - 1, 0);
+	btrfs_drop_extent_cache(BTRFS_I(inode), start, start + ram_size - 1, 0);
 out_reserve:
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, 1);
@@ -2935,7 +2935,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		clear_extent_uptodate(io_tree, start, end, NULL, GFP_NOFS);
 
 		/* Drop the cache for the part of the extent we didn't write. */
-		btrfs_drop_extent_cache(inode, start, end, 0);
+		btrfs_drop_extent_cache(BTRFS_I(inode), start, end, 0);
 
 		/*
 		 * If the ordered extent had an IOERR or something else went
@@ -4341,7 +4341,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	 */
 	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
 	    root == fs_info->tree_root)
-		btrfs_drop_extent_cache(inode, ALIGN(new_size,
+		btrfs_drop_extent_cache(BTRFS_I(inode), ALIGN(new_size,
 					fs_info->sectorsize),
 					(u64)-1, 0);
 
@@ -4862,7 +4862,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 						hole_size);
 			if (err)
 				break;
-			btrfs_drop_extent_cache(inode, cur_offset,
+			btrfs_drop_extent_cache(BTRFS_I(inode), cur_offset,
 						cur_offset + hole_size - 1, 0);
 			hole_em = alloc_extent_map();
 			if (!hole_em) {
@@ -4888,7 +4888,7 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 				write_unlock(&em_tree->lock);
 				if (err != -EEXIST)
 					break;
-				btrfs_drop_extent_cache(inode, cur_offset,
+				btrfs_drop_extent_cache(BTRFS_I(inode), cur_offset,
 							cur_offset +
 							hole_size - 1, 0);
 			}
@@ -7160,7 +7160,7 @@ static struct extent_map *btrfs_create_dio_extent(struct inode *inode,
 	if (ret) {
 		if (em) {
 			free_extent_map(em);
-			btrfs_drop_extent_cache(inode, start,
+			btrfs_drop_extent_cache(BTRFS_I(inode), start,
 						start + len - 1, 0);
 		}
 		em = ERR_PTR(ret);
@@ -7527,7 +7527,7 @@ static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
 	}
 
 	do {
-		btrfs_drop_extent_cache(inode, em->start,
+		btrfs_drop_extent_cache(BTRFS_I(inode), em->start,
 				em->start + em->len - 1, 0);
 		write_lock(&em_tree->lock);
 		ret = add_extent_mapping(em_tree, em, 1);
@@ -9331,7 +9331,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	}
 	btrfs_qgroup_check_reserved_leak(inode);
 	inode_tree_del(inode);
-	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
+	btrfs_drop_extent_cache(BTRFS_I(inode), 0, (u64)-1, 0);
 free:
 	call_rcu(&inode->i_rcu, btrfs_i_callback);
 }
@@ -10324,7 +10324,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			break;
 		}
 
-		btrfs_drop_extent_cache(inode, cur_offset,
+		btrfs_drop_extent_cache(BTRFS_I(inode), cur_offset,
 					cur_offset + ins.offset -1, 0);
 
 		em = alloc_extent_map();
@@ -10351,7 +10351,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			write_unlock(&em_tree->lock);
 			if (ret != -EEXIST)
 				break;
-			btrfs_drop_extent_cache(inode, cur_offset,
+			btrfs_drop_extent_cache(BTRFS_I(inode), cur_offset,
 						cur_offset + ins.offset - 1,
 						0);
 		}
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2c964acdc9fb..9f712207a7db 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3349,7 +3349,7 @@ static void clone_update_extent_map(struct inode *inode,
 			free_extent_map(em);
 			break;
 		}
-		btrfs_drop_extent_cache(inode, em->start,
+		btrfs_drop_extent_cache(BTRFS_I(inode), em->start,
 					em->start + em->len - 1, 0);
 	}
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 59ae36df3550..aecdea2e9051 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1714,7 +1714,7 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 				if (!ret)
 					continue;
 
-				btrfs_drop_extent_cache(inode, key.offset, end,
+				btrfs_drop_extent_cache(BTRFS_I(inode), key.offset, end,
 							1);
 				unlock_extent(&BTRFS_I(inode)->io_tree,
 					      key.offset, end);
@@ -2130,7 +2130,7 @@ static int invalidate_extent_cache(struct btrfs_root *root,
 
 		/* the lock_extent waits for readpage to complete */
 		lock_extent(&BTRFS_I(inode)->io_tree, start, end);
-		btrfs_drop_extent_cache(inode, start, end, 1);
+		btrfs_drop_extent_cache(BTRFS_I(inode), start, end, 1);
 		unlock_extent(&BTRFS_I(inode)->io_tree, start, end);
 	}
 	return 0;
@@ -3161,7 +3161,7 @@ int setup_extent_mapping(struct inode *inode, u64 start, u64 end,
 			free_extent_map(em);
 			break;
 		}
-		btrfs_drop_extent_cache(inode, start, end, 0);
+		btrfs_drop_extent_cache(BTRFS_I(inode), start, end, 0);
 	}
 	unlock_extent(&BTRFS_I(inode)->io_tree, start, end);
 	return ret;
-- 
2.7.4

