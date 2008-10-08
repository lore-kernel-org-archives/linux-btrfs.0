From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Count space allocated to file in bytes
Date: Wed, 08 Oct 2008 11:05:32 +0800
Message-ID: <48EC237C.5060204@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes btrfs count space allocated to file in bytes.
Counting allocation in bytes fits better with inline extents.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>
---

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8566eb3..50fbcc9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -411,7 +411,7 @@ struct btrfs_inode_item {
 	/* transid that last touched this inode */
 	__le64 transid;
 	__le64 size;
-	__le64 nblocks;
+	__le64 nbytes;
 	__le64 block_group;
 	__le32 nlink;
 	__le32 uid;
@@ -1017,7 +1017,7 @@ BTRFS_SETGET_FUNCS(inode_ref_index, struct btrfs_inode_ref, index, 64);
 BTRFS_SETGET_FUNCS(inode_generation, struct btrfs_inode_item, generation, 64);
 BTRFS_SETGET_FUNCS(inode_transid, struct btrfs_inode_item, transid, 64);
 BTRFS_SETGET_FUNCS(inode_size, struct btrfs_inode_item, size, 64);
-BTRFS_SETGET_FUNCS(inode_nblocks, struct btrfs_inode_item, nblocks, 64);
+BTRFS_SETGET_FUNCS(inode_nbytes, struct btrfs_inode_item, nbytes, 64);
 BTRFS_SETGET_FUNCS(inode_block_group, struct btrfs_inode_item, block_group, 64);
 BTRFS_SETGET_FUNCS(inode_nlink, struct btrfs_inode_item, nlink, 32);
 BTRFS_SETGET_FUNCS(inode_uid, struct btrfs_inode_item, uid, 32);
@@ -1814,15 +1814,6 @@ void btrfs_invalidate_dcache_root(struct btrfs_root *root, char *name,
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio);
 
-static inline void dec_i_blocks(struct inode *inode, u64 dec)
-{
-	dec = dec >> 9;
-	if (dec <= inode->i_blocks)
-		inode->i_blocks -= dec;
-	else
-		inode->i_blocks = 0;
-}
-
 unsigned long btrfs_force_ra(struct address_space *mapping,
 			      struct file_ra_state *ra, struct file *file,
 			      pgoff_t offset, pgoff_t last_index);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2938046..69db54e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3930,7 +3930,7 @@ next:
 				BUG_ON(ret);
 				btrfs_release_path(root, path);
 
-				inode->i_blocks += extent_len >> 9;
+				inode_add_bytes(inode, extent_len);
 
 				ext_offset = 0;
 				num_bytes -= extent_len;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a03d1bb..18dfdf5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -193,7 +193,7 @@ static int noinline insert_inline_extent(struct btrfs_trans_handle *trans,
 			leaf = path->nodes[0];
 			ei = btrfs_item_ptr(leaf, path->slots[0],
 					    struct btrfs_file_extent_item);
-			inode->i_blocks += (offset + size - found_end) >> 9;
+			inode_add_bytes(inode, offset + size - found_end);
 		}
 		if (found_end < offset) {
 			ptr = btrfs_file_extent_inline_start(ei) + found_size;
@@ -203,7 +203,7 @@ static int noinline insert_inline_extent(struct btrfs_trans_handle *trans,
 insert:
 		btrfs_release_path(root, path);
 		datasize = offset + size - key.offset;
-		inode->i_blocks += datasize >> 9;
+		inode_add_bytes(inode, datasize);
 		datasize = btrfs_file_extent_calc_inline_size(datasize);
 		ret = btrfs_insert_empty_item(trans, root, path, &key,
 					      datasize);
@@ -713,7 +713,8 @@ next_slot:
 								      extent);
 				if (btrfs_file_extent_disk_bytenr(leaf,
 								  extent)) {
-					dec_i_blocks(inode, old_num - new_num);
+					inode_sub_bytes(inode, old_num -
+							new_num);
 				}
 				btrfs_set_file_extent_num_bytes(leaf, extent,
 								new_num);
@@ -724,14 +725,17 @@ next_slot:
 				u32 new_size;
 				new_size = btrfs_file_extent_calc_inline_size(
 						   inline_limit - key.offset);
-				dec_i_blocks(inode, (extent_end - key.offset) -
-					(inline_limit - key.offset));
+				inode_sub_bytes(inode, extent_end -
+						inline_limit);
 				btrfs_truncate_item(trans, root, path,
 						    new_size, 1);
 			}
 		}
 		/* delete the entire extent */
 		if (!keep) {
+			if (found_inline)
+				inode_sub_bytes(inode, extent_end -
+						key.offset);
 			ret = btrfs_del_item(trans, root, path);
 			/* TODO update progress marker and return */
 			BUG_ON(ret);
@@ -743,8 +747,7 @@ next_slot:
 			u32 new_size;
 			new_size = btrfs_file_extent_calc_inline_size(
 						   extent_end - end);
-			dec_i_blocks(inode, (extent_end - key.offset) -
-					(extent_end - end));
+			inode_sub_bytes(inode, end - key.offset);
 			ret = btrfs_truncate_item(trans, root, path,
 						  new_size, 0);
 			BUG_ON(ret);
@@ -791,9 +794,7 @@ next_slot:
 			}
 			btrfs_release_path(root, path);
 			if (disk_bytenr != 0) {
-				inode->i_blocks +=
-				      btrfs_file_extent_num_bytes(leaf,
-								  extent) >> 9;
+				inode_add_bytes(inode, extent_end - end);
 			}
 		}
 
@@ -801,7 +802,8 @@ next_slot:
 			u64 disk_bytenr = le64_to_cpu(old.disk_bytenr);
 
 			if (disk_bytenr != 0) {
-				dec_i_blocks(inode, le64_to_cpu(old.num_bytes));
+				inode_sub_bytes(inode,
+						le64_to_cpu(old.num_bytes));
 				ret = btrfs_free_extent(trans, root,
 						disk_bytenr,
 						le64_to_cpu(old.disk_num_bytes),
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ff0c359..f9df89c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -652,7 +652,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	BUG_ON(ret);
 	btrfs_release_path(root, path);
 
-	inode->i_blocks += ordered_extent->len >> 9;
+	inode_add_bytes(inode, ordered_extent->len);
 	unlock_extent(io_tree, ordered_extent->file_offset,
 		    ordered_extent->file_offset + ordered_extent->len - 1,
 		    GFP_NOFS);
@@ -1104,7 +1104,7 @@ void btrfs_read_locked_inode(struct inode *inode)
 	inode->i_ctime.tv_sec = btrfs_timespec_sec(leaf, tspec);
 	inode->i_ctime.tv_nsec = btrfs_timespec_nsec(leaf, tspec);
 
-	inode->i_blocks = btrfs_inode_nblocks(leaf, inode_item);
+	inode_set_bytes(inode, btrfs_inode_nbytes(leaf, inode_item));
 	BTRFS_I(inode)->generation = btrfs_inode_generation(leaf, inode_item);
 	inode->i_generation = BTRFS_I(inode)->generation;
 	inode->i_rdev = 0;
@@ -1184,7 +1184,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_timespec_nsec(leaf, btrfs_inode_ctime(item),
 				inode->i_ctime.tv_nsec);
 
-	btrfs_set_inode_nblocks(leaf, item, inode->i_blocks);
+	btrfs_set_inode_nbytes(leaf, item, inode_get_bytes(inode));
 	btrfs_set_inode_generation(leaf, item, BTRFS_I(inode)->generation);
 	btrfs_set_inode_transid(leaf, item, trans->transid);
 	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
@@ -1679,7 +1679,7 @@ search_again:
 				num_dec = (orig_num_bytes -
 					   extent_num_bytes);
 				if (root->ref_cows && extent_start != 0)
-					dec_i_blocks(inode, num_dec);
+					inode_sub_bytes(inode, num_dec);
 				btrfs_mark_buffer_dirty(leaf);
 			} else {
 				extent_num_bytes =
@@ -1690,7 +1690,7 @@ search_again:
 				if (extent_start != 0) {
 					found_extent = 1;
 					if (root->ref_cows)
-						dec_i_blocks(inode, num_dec);
+						inode_sub_bytes(inode, num_dec);
 				}
 				root_gen = btrfs_header_generation(leaf);
 				root_owner = btrfs_header_owner(leaf);
@@ -1700,8 +1700,8 @@ search_again:
 				u32 size = new_size - found_key.offset;
 
 				if (root->ref_cows) {
-					dec_i_blocks(inode, item_end + 1 -
-						    found_key.offset - size);
+					inode_sub_bytes(inode, item_end + 1 -
+							new_size);
 				}
 				size =
 				    btrfs_file_extent_calc_inline_size(size);
@@ -1709,8 +1709,8 @@ search_again:
 							  size, 1);
 				BUG_ON(ret);
 			} else if (root->ref_cows) {
-				dec_i_blocks(inode, item_end + 1 -
-					     found_key.offset);
+				inode_sub_bytes(inode, item_end + 1 -
+						found_key.offset);
 			}
 		}
 delete:
@@ -2514,7 +2514,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	inode->i_gid = current->fsgid;
 	inode->i_mode = mode;
 	inode->i_ino = objectid;
-	inode->i_blocks = 0;
+	inode_set_bytes(inode, 0);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
 	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 				  struct btrfs_inode_item);
@@ -3557,7 +3557,8 @@ static int btrfs_getattr(struct vfsmount *mnt,
 	struct inode *inode = dentry->d_inode;
 	generic_fillattr(inode, stat);
 	stat->blksize = PAGE_CACHE_SIZE;
-	stat->blocks = inode->i_blocks + (BTRFS_I(inode)->delalloc_bytes >> 9);
+	stat->blocks = (inode_get_bytes(inode) +
+			BTRFS_I(inode)->delalloc_bytes) >> 9;
 	return 0;
 }
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 04de767..ab7a0f6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -99,7 +99,7 @@ static noinline int create_subvol(struct btrfs_root *root, char *name,
 	inode_item->generation = cpu_to_le64(1);
 	inode_item->size = cpu_to_le64(3);
 	inode_item->nlink = cpu_to_le32(1);
-	inode_item->nblocks = cpu_to_le64(1);
+	inode_item->nbytes = cpu_to_le64(root->leafsize);
 	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
 
 	btrfs_set_root_bytenr(&root_item, leaf->start);
@@ -671,7 +671,7 @@ out:
 	btrfs_release_path(root, path);
 	if (ret == 0) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		inode->i_blocks = src->i_blocks;
+		inode_set_bytes(inode, inode_get_bytes(src));
 		btrfs_i_size_write(inode, src->i_size);
 		BTRFS_I(inode)->flags = BTRFS_I(src)->flags;
 		ret = btrfs_update_inode(trans, root, inode);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 88bbfd9..8df719a 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -113,7 +113,7 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 	inode_item->generation = cpu_to_le64(1);
 	inode_item->size = cpu_to_le64(3);
 	inode_item->nlink = cpu_to_le32(1);
-	inode_item->nblocks = cpu_to_le64(1);
+	inode_item->nbytes = cpu_to_le64(root->leafsize);
 	inode_item->mode = cpu_to_le32(S_IFDIR | 0755);
 
 	btrfs_set_root_bytenr(&root_item, leaf->start);
@@ -598,8 +598,8 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	ret = overwrite_item(trans, root, path, eb, slot, key);
 	BUG_ON(ret);
 
-	/* btrfs_drop_extents changes i_blocks, update it here */
-	inode->i_blocks += (extent_end - start) >> 9;
+	/* btrfs_drop_extents changes i_bytes & i_blocks, update it here */
+	inode_add_bytes(inode, extent_end - start);
 	btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)
