From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 11/12] Btrfs: Pre-allocate space for data relocation
Date: Mon, 19 Apr 2010 18:34:37 +0800
Message-ID: <4BCC31BD.9040905@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Pre-allocate space for data relocation. This can detect ENOPSC
condition caused by fragmentation of free space.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 11/fs/btrfs/ctree.h 12/fs/btrfs/ctree.h
--- 11/fs/btrfs/ctree.h	2010-04-18 10:50:26.565702000 +0800
+++ 12/fs/btrfs/ctree.h	2010-04-18 10:55:07.771696917 +0800
@@ -2406,6 +2406,9 @@ int btrfs_cont_expand(struct inode *inod
 int btrfs_invalidate_inodes(struct btrfs_root *root);
 void btrfs_add_delayed_iput(struct inode *inode);
 void btrfs_run_delayed_iputs(struct btrfs_root *root);
+int btrfs_prealloc_file_range(struct inode *inode, int mode,
+			      u64 start, u64 num_bytes, u64 min_size,
+			      loff_t actual_len, u64 *alloc_hint);
 extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
diff -urp 11/fs/btrfs/inode.c 12/fs/btrfs/inode.c
--- 11/fs/btrfs/inode.c	2010-04-18 11:03:00.450703636 +0800
+++ 12/fs/btrfs/inode.c	2010-04-18 11:03:39.602698880 +0800
@@ -1174,6 +1174,13 @@ out_check:
 					       num_bytes, num_bytes, type);
 		BUG_ON(ret);
 
+		if (root->root_key.objectid ==
+		    BTRFS_DATA_RELOC_TREE_OBJECTID) {
+			ret = btrfs_reloc_clone_csums(inode, cur_offset,
+						      num_bytes);
+			BUG_ON(ret);
+		}
+
 		extent_clear_unlock_delalloc(inode, &BTRFS_I(inode)->io_tree,
 				cur_offset, cur_offset + num_bytes - 1,
 				locked_page, EXTENT_CLEAR_UNLOCK_PAGE |
@@ -5904,16 +5911,15 @@ out_unlock:
 	return err;
 }
 
-static int prealloc_file_range(struct inode *inode, u64 start, u64 end,
-			u64 alloc_hint, int mode, loff_t actual_len)
+int btrfs_prealloc_file_range(struct inode *inode, int mode,
+			      u64 start, u64 num_bytes, u64 min_size,
+			      loff_t actual_len, u64 *alloc_hint)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key ins;
 	u64 cur_offset = start;
-	u64 num_bytes = end - start;
 	int ret = 0;
-	u64 i_size;
 
 	while (num_bytes > 0) {
 		trans = btrfs_start_transaction(root, 3);
@@ -5922,9 +5928,8 @@ static int prealloc_file_range(struct in
 			break;
 		}
 
-		ret = btrfs_reserve_extent(trans, root, num_bytes,
-					   root->sectorsize, 0, alloc_hint,
-					   (u64)-1, &ins, 1);
+		ret = btrfs_reserve_extent(trans, root, num_bytes, min_size,
+					   0, *alloc_hint, (u64)-1, &ins, 1);
 		if (ret) {
 			btrfs_end_transaction(trans, root);
 			break;
@@ -5941,20 +5946,19 @@ static int prealloc_file_range(struct in
 
 		num_bytes -= ins.offset;
 		cur_offset += ins.offset;
-		alloc_hint = ins.objectid + ins.offset;
+		*alloc_hint = ins.objectid + ins.offset;
 
 		inode->i_ctime = CURRENT_TIME;
 		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
-			(actual_len > inode->i_size) &&
-			(cur_offset > inode->i_size)) {
-
+		    (actual_len > inode->i_size) &&
+		    (cur_offset > inode->i_size)) {
 			if (cur_offset > actual_len)
-				i_size  = actual_len;
+				i_size_write(inode, actual_len);
 			else
-				i_size = cur_offset;
-			i_size_write(inode, i_size);
-			btrfs_ordered_update_i_size(inode, i_size, NULL);
+				i_size_write(inode, cur_offset);
+			i_size_write(inode, cur_offset);
+			btrfs_ordered_update_i_size(inode, cur_offset, NULL);
 		}
 
 		ret = btrfs_update_inode(trans, root, inode);
@@ -6040,16 +6044,16 @@ static long btrfs_fallocate(struct inode
 		if (em->block_start == EXTENT_MAP_HOLE ||
 		    (cur_offset >= inode->i_size &&
 		     !test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
-			ret = prealloc_file_range(inode,
-						  cur_offset, last_byte,
-						alloc_hint, mode, offset+len);
+			ret = btrfs_prealloc_file_range(inode, 0, cur_offset,
+							last_byte - cur_offset,
+							1 << inode->i_blkbits,
+							offset + len,
+							&alloc_hint);
 			if (ret < 0) {
 				free_extent_map(em);
 				break;
 			}
 		}
-		if (em->block_start <= EXTENT_MAP_LAST_BYTE)
-			alloc_hint = em->block_start;
 		free_extent_map(em);
 
 		cur_offset = last_byte;
diff -urp 11/fs/btrfs/relocation.c 12/fs/btrfs/relocation.c
--- 11/fs/btrfs/relocation.c	2010-04-18 10:24:51.294952000 +0800
+++ 12/fs/btrfs/relocation.c	2010-04-18 10:55:07.775699247 +0800
@@ -2545,6 +2545,50 @@ out:
 }
 
 static noinline_for_stack
+int prealloc_file_extent_cluster(struct inode *inode,
+				 struct file_extent_cluster *cluster)
+{
+	u64 alloc_hint = 0;
+	u64 start;
+	u64 end;
+	u64 offset = BTRFS_I(inode)->index_cnt;
+	u64 num_bytes;
+	int nr = 0;
+	int ret = 0;
+
+	BUG_ON(cluster->start != cluster->boundary[0]);
+	mutex_lock(&inode->i_mutex);
+
+	ret = btrfs_check_data_free_space(inode, cluster->end +
+					  1 - cluster->start);
+	if (ret)
+		goto out;
+
+	while (nr < cluster->nr) {
+		start = cluster->boundary[nr] - offset;
+		if (nr + 1 < cluster->nr)
+			end = cluster->boundary[nr + 1] - 1 - offset;
+		else
+			end = cluster->end - offset;
+
+		lock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		num_bytes = end + 1 - start;
+		ret = btrfs_prealloc_file_range(inode, 0, start,
+						num_bytes, num_bytes,
+						end + 1, &alloc_hint);
+		unlock_extent(&BTRFS_I(inode)->io_tree, start, end, GFP_NOFS);
+		if (ret)
+			break;
+		nr++;
+	}
+	btrfs_free_reserved_data_space(inode, cluster->end +
+				       1 - cluster->start);
+out:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
+
+static noinline_for_stack
 int setup_extent_mapping(struct inode *inode, u64 start, u64 end,
 			 u64 block_start)
 {
@@ -2587,7 +2631,6 @@ static int relocate_file_extent_cluster(
 	u64 offset = BTRFS_I(inode)->index_cnt;
 	unsigned long index;
 	unsigned long last_index;
-	unsigned int dirty_page = 0;
 	struct page *page;
 	struct file_ra_state *ra;
 	int nr = 0;
@@ -2600,21 +2643,24 @@ static int relocate_file_extent_cluster(
 	if (!ra)
 		return -ENOMEM;
 
-	index = (cluster->start - offset) >> PAGE_CACHE_SHIFT;
-	last_index = (cluster->end - offset) >> PAGE_CACHE_SHIFT;
+	ret = prealloc_file_extent_cluster(inode, cluster);
+	if (ret)
+		goto out;
 
-	mutex_lock(&inode->i_mutex);
+	file_ra_state_init(ra, inode->i_mapping);
 
-	i_size_write(inode, cluster->end + 1 - offset);
 	ret = setup_extent_mapping(inode, cluster->start - offset,
 				   cluster->end - offset, cluster->start);
 	if (ret)
-		goto out_unlock;
-
-	file_ra_state_init(ra, inode->i_mapping);
+		goto out;
 
-	WARN_ON(cluster->start != cluster->boundary[0]);
+	index = (cluster->start - offset) >> PAGE_CACHE_SHIFT;
+	last_index = (cluster->end - offset) >> PAGE_CACHE_SHIFT;
 	while (index <= last_index) {
+		ret = btrfs_delalloc_reserve_metadata(inode, PAGE_CACHE_SIZE);
+		if (ret)
+			goto out;
+
 		page = find_lock_page(inode->i_mapping, index);
 		if (!page) {
 			page_cache_sync_readahead(inode->i_mapping,
@@ -2622,8 +2668,10 @@ static int relocate_file_extent_cluster(
 						  last_index + 1 - index);
 			page = grab_cache_page(inode->i_mapping, index);
 			if (!page) {
+				btrfs_delalloc_release_metadata(inode,
+							PAGE_CACHE_SIZE);
 				ret = -ENOMEM;
-				goto out_unlock;
+				goto out;
 			}
 		}
 
@@ -2639,8 +2687,10 @@ static int relocate_file_extent_cluster(
 			if (!PageUptodate(page)) {
 				unlock_page(page);
 				page_cache_release(page);
+				btrfs_delalloc_release_metadata(inode,
+							PAGE_CACHE_SIZE);
 				ret = -EIO;
-				goto out_unlock;
+				goto out;
 			}
 		}
 
@@ -2659,10 +2709,9 @@ static int relocate_file_extent_cluster(
 					EXTENT_BOUNDARY, GFP_NOFS);
 			nr++;
 		}
-		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
 
+		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
 		set_page_dirty(page);
-		dirty_page++;
 
 		unlock_extent(&BTRFS_I(inode)->io_tree,
 			      page_start, page_end, GFP_NOFS);
@@ -2670,20 +2719,11 @@ static int relocate_file_extent_cluster(
 		page_cache_release(page);
 
 		index++;
-		if (nr < cluster->nr &&
-		    page_end + 1 + offset == cluster->boundary[nr]) {
-			balance_dirty_pages_ratelimited_nr(inode->i_mapping,
-							   dirty_page);
-			dirty_page = 0;
-		}
-	}
-	if (dirty_page) {
-		balance_dirty_pages_ratelimited_nr(inode->i_mapping,
-						   dirty_page);
+		balance_dirty_pages_ratelimited(inode->i_mapping);
+		btrfs_throttle(BTRFS_I(inode)->root);
 	}
 	WARN_ON(nr != cluster->nr);
-out_unlock:
-	mutex_unlock(&inode->i_mutex);
+out:
 	kfree(ra);
 	return ret;
 }
