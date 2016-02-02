Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbcBBDIN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Feb 2016 22:08:13 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v5 09/19] btrfs: dedup: Inband in-memory only de-duplication implement
Date: Tue,  2 Feb 2016 11:05:41 +0800
Message-Id: <1454382351-31775-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1454382351-31775-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Core implement for inband de-duplication.
It reuse the async_cow_start() facility to do the calculate dedup hash.
And use dedup hash to do inband de-duplication at extent level.

The work flow is as below:
1) Run delalloc range for an inode
2) Calculate hash for the delalloc range at the unit of dedup_bs
3) For hash match(duplicated) case, just increase source extent ref
   and insert file extent.
   For hash mismatch case, go through the normal cow_file_range()
   fallback, and add hash into dedup_tree.
   Compress for hash miss case is not supported yet.

Current implement restore all dedup hash in memory rb-tree, with LRU
behavior to control the limit.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |  24 +++++++
 fs/btrfs/inode.c       | 174 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 174 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2287c7..f9fc25c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -37,6 +37,7 @@
 #include "math.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "dedup.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -2399,6 +2400,7 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 
 	if (btrfs_delayed_ref_is_head(node)) {
 		struct btrfs_delayed_ref_head *head;
+		struct btrfs_dedup_info *dedup_info;
 		/*
 		 * we've hit the end of the chain and we were supposed
 		 * to insert this extent into the tree.  But, it got
@@ -2409,15 +2411,27 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 		head = btrfs_delayed_node_to_head(node);
 		trace_run_delayed_ref_head(node, head, node->action);
 
+		dedup_info = btrfs_dedup_get_info(root->fs_info);
 		if (insert_reserved) {
 			btrfs_pin_extent(root, node->bytenr,
 					 node->num_bytes, 1);
 			if (head->is_data) {
+				/*
+				 * If insert_reserved is given, it means
+				 * a new extent is revered, then deleted
+				 * in one tran, and inc/dec get merged to 0.
+				 *
+				 * In this case, we need to remove its dedup
+				 * hash.
+				 */
+				btrfs_dedup_del(trans, dedup_info,
+						node->bytenr);
 				ret = btrfs_del_csums(trans, root,
 						      node->bytenr,
 						      node->num_bytes);
 			}
 		}
+		btrfs_dedup_put_info(dedup_info);
 
 		/* Also free its reserved qgroup space */
 		btrfs_qgroup_free_delayed_ref(root->fs_info,
@@ -6707,6 +6721,16 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
+			struct btrfs_dedup_info *dedup_info;
+
+			dedup_info = btrfs_dedup_get_info(info);
+			ret = btrfs_dedup_del(trans, dedup_info, bytenr);
+			btrfs_dedup_put_info(dedup_info);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, extent_root,
+							ret);
+				goto out;
+			}
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, extent_root, ret);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e456545..1e27a71 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,6 +60,7 @@
 #include "hash.h"
 #include "props.h"
 #include "qgroup.h"
+#include "dedup.h"
 
 struct btrfs_iget_args {
 	struct btrfs_key *location;
@@ -106,7 +107,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
 static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
-				   unsigned long *nr_written, int unlock);
+				   unsigned long *nr_written, int unlock,
+				   struct btrfs_dedup_hash *hash);
 static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 					   u64 len, u64 orig_start,
 					   u64 block_start, u64 block_len,
@@ -335,6 +337,7 @@ struct async_extent {
 	struct page **pages;
 	unsigned long nr_pages;
 	int compress_type;
+	struct btrfs_dedup_hash *hash;
 	struct list_head list;
 };
 
@@ -353,7 +356,8 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 compressed_size,
 				     struct page **pages,
 				     unsigned long nr_pages,
-				     int compress_type)
+				     int compress_type,
+				     struct btrfs_dedup_hash *hash)
 {
 	struct async_extent *async_extent;
 
@@ -365,6 +369,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 	async_extent->pages = pages;
 	async_extent->nr_pages = nr_pages;
 	async_extent->compress_type = compress_type;
+	async_extent->hash = hash;
 	list_add_tail(&async_extent->list, &cow->extents);
 	return 0;
 }
@@ -616,7 +621,7 @@ cont:
 		 */
 		add_async_extent(async_cow, start, num_bytes,
 				 total_compressed, pages, nr_pages_ret,
-				 compress_type);
+				 compress_type, NULL);
 
 		if (start + num_bytes < end) {
 			start += num_bytes;
@@ -641,7 +646,7 @@ cleanup_and_bail_uncompressed:
 		if (redirty)
 			extent_range_redirty_for_io(inode, start, end);
 		add_async_extent(async_cow, start, end - start + 1,
-				 0, NULL, 0, BTRFS_COMPRESS_NONE);
+				 0, NULL, 0, BTRFS_COMPRESS_NONE, NULL);
 		*num_added += 1;
 	}
 
@@ -712,7 +717,8 @@ retry:
 					     async_extent->start,
 					     async_extent->start +
 					     async_extent->ram_size - 1,
-					     &page_started, &nr_written, 0);
+					     &page_started, &nr_written, 0,
+					     async_extent->hash);
 
 			/* JDM XXX */
 
@@ -925,7 +931,7 @@ static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
 				   unsigned long *nr_written,
-				   int unlock)
+				   int unlock, struct btrfs_dedup_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 alloc_hint = 0;
@@ -984,11 +990,16 @@ static noinline int cow_file_range(struct inode *inode,
 		unsigned long op;
 
 		cur_alloc_size = disk_num_bytes;
-		ret = btrfs_reserve_extent(root, cur_alloc_size,
+		if (hash && hash->bytenr) {
+			ins.objectid = hash->bytenr;
+			ins.offset = hash->num_bytes;
+		} else {
+			ret = btrfs_reserve_extent(root, cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   &ins, 1, 1);
-		if (ret < 0)
-			goto out_unlock;
+			if (ret < 0)
+				goto out_unlock;
+		}
 
 		em = alloc_extent_map();
 		if (!em) {
@@ -1025,8 +1036,9 @@ static noinline int cow_file_range(struct inode *inode,
 			goto out_reserve;
 
 		cur_alloc_size = ins.offset;
-		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-					       ram_size, cur_alloc_size, 0);
+		ret = btrfs_add_ordered_extent_dedup(inode, start,
+				ins.objectid, cur_alloc_size, ins.offset,
+				0, hash);
 		if (ret)
 			goto out_drop_extent_cache;
 
@@ -1076,6 +1088,67 @@ out_unlock:
 	goto out;
 }
 
+static int hash_file_ranges(struct inode *inode, u64 start, u64 end,
+			    struct async_cow *async_cow, int *num_added)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_dedup_info *dedup_info;
+	struct page *locked_page = async_cow->locked_page;
+	unsigned long nr_pages;
+	u64 actual_end;
+	u64 isize = i_size_read(inode);
+	u64 dedup_bs;
+	u64 cur_offset = start;
+	int ret = 0;
+
+	actual_end = min_t(u64, isize, end + 1);
+	dedup_info = btrfs_dedup_get_info(root->fs_info);
+	if (dedup_info)
+		dedup_bs = dedup_info->blocksize;
+	else
+		dedup_bs = SZ_128M;
+
+	nr_pages = (end >> PAGE_CACHE_SHIFT) - (start >> PAGE_CACHE_SHIFT) + 1;
+	nr_pages = min_t(unsigned long, nr_pages, dedup_bs / PAGE_CACHE_SIZE);
+
+	while (cur_offset < end) {
+		struct btrfs_dedup_hash *hash = NULL;
+		u64 len;
+
+		len = min(end + 1 - cur_offset, dedup_bs);
+		if (len < dedup_bs)
+			goto next;
+
+		hash = btrfs_dedup_alloc_hash(dedup_info->hash_type);
+		if (!hash) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = btrfs_dedup_calc_hash(dedup_info, inode, cur_offset, hash);
+		if (ret < 0)
+			goto out;
+
+		ret = btrfs_dedup_search(dedup_info, inode, cur_offset, hash);
+		if (ret < 0)
+			goto out;
+		ret = 0;
+
+next:
+		/* Redirty the locked page if it corresponds to our extent */
+		if (page_offset(locked_page) >= start &&
+		    page_offset(locked_page) <= end)
+			__set_page_dirty_nobuffers(locked_page);
+
+		add_async_extent(async_cow, cur_offset, len, 0, NULL, 0,
+				 BTRFS_COMPRESS_NONE, hash);
+		cur_offset += len;
+		(*num_added)++;
+	}
+out:
+	btrfs_dedup_put_info(dedup_info);
+	return ret;
+}
+
 /*
  * work queue call back to started compression on a file and pages
  */
@@ -1083,11 +1156,18 @@ static noinline void async_cow_start(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
 	int num_added = 0;
+	int ret = 0;
 	async_cow = container_of(work, struct async_cow, work);
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
-			    async_cow->start, async_cow->end, async_cow,
-			    &num_added);
+	if (inode_need_compress(async_cow->inode))
+		compress_file_range(async_cow->inode, async_cow->locked_page,
+				    async_cow->start, async_cow->end, async_cow,
+				    &num_added);
+	else
+		ret = hash_file_ranges(async_cow->inode, async_cow->start,
+				       async_cow->end, async_cow, &num_added);
+	WARN_ON(ret);
+
 	if (num_added == 0) {
 		btrfs_add_delayed_iput(async_cow->inode);
 		async_cow->inode = NULL;
@@ -1134,6 +1214,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 				u64 start, u64 end, int *page_started,
 				unsigned long *nr_written)
 {
+	struct btrfs_dedup_info *dedup_info;
 	struct async_cow *async_cow;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	unsigned long nr_pages;
@@ -1150,11 +1231,17 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 
-		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
+		dedup_info = btrfs_dedup_get_info(root->fs_info);
+		if (dedup_info) {
+			u64 len = max_t(u64, SZ_512K, dedup_info->blocksize);
+
+			cur_end = min(end, start + len - 1);
+		} else if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
 		    !btrfs_test_opt(root, FORCE_COMPRESS))
 			cur_end = end;
 		else
 			cur_end = min(end, start + SZ_512K - 1);
+		btrfs_dedup_put_info(dedup_info);
 
 		async_cow->end = cur_end;
 		INIT_LIST_HEAD(&async_cow->extents);
@@ -1407,7 +1494,7 @@ out_check:
 		if (cow_start != (u64)-1) {
 			ret = cow_file_range(inode, locked_page,
 					     cow_start, found_key.offset - 1,
-					     page_started, nr_written, 1);
+					     page_started, nr_written, 1, NULL);
 			if (ret) {
 				if (!nolock && nocow)
 					btrfs_end_write_no_snapshoting(root);
@@ -1486,7 +1573,7 @@ out_check:
 
 	if (cow_start != (u64)-1) {
 		ret = cow_file_range(inode, locked_page, cow_start, end,
-				     page_started, nr_written, 1);
+				     page_started, nr_written, 1, NULL);
 		if (ret)
 			goto error;
 	}
@@ -1537,22 +1624,26 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 {
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_dedup_info *dedup_info;
 
+	dedup_info = btrfs_dedup_get_info(root->fs_info);
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode)) {
+	} else if (!inode_need_compress(inode) && !dedup_info) {
 		ret = cow_file_range(inode, locked_page, start, end,
-				      page_started, nr_written, 1);
+				      page_started, nr_written, 1, NULL);
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
 			&BTRFS_I(inode)->runtime_flags);
 		ret = cow_file_range_async(inode, locked_page, start, end,
 					   page_started, nr_written);
 	}
+	btrfs_dedup_put_info(dedup_info);
 	return ret;
 }
 
@@ -2075,9 +2166,11 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       u64 disk_bytenr, u64 disk_num_bytes,
 				       u64 num_bytes, u64 ram_bytes,
 				       u8 compression, u8 encryption,
-				       u16 other_encoding, int extent_type)
+				       u16 other_encoding, int extent_type,
+				       struct btrfs_dedup_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_dedup_info *dedup_info;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -2137,10 +2230,39 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
-	ret = btrfs_alloc_reserved_file_extent(trans, root,
+
+	/*
+	 * Only for no-dedup or hash miss case, we need to increase
+	 * extent reference
+	 * For hash hit case, reference is already increased
+	 */
+	if (!hash || hash->bytenr == 0)
+		ret = btrfs_alloc_reserved_file_extent(trans, root,
 					root->root_key.objectid,
 					btrfs_ino(inode), file_pos,
 					ram_bytes, &ins);
+	if (ret < 0)
+		goto out_qgroup;
+
+	dedup_info = btrfs_dedup_get_info(root->fs_info);
+	/*
+	 * Hash hit won't create a new file extent, so its reserved quota
+	 * space won't be freed by new delayed_ref_head.
+	 * Need to free it here.
+	 */
+	if (hash && hash->bytenr)
+		btrfs_qgroup_free_data(inode, file_pos, ram_bytes);
+
+	/* Add missed hash into dedup tree */
+	if (hash && hash->bytenr == 0) {
+		hash->bytenr = ins.objectid;
+		hash->num_bytes = ins.offset;
+		ret = btrfs_dedup_add(trans, dedup_info, hash);
+	}
+	btrfs_dedup_put_info(dedup_info);
+
+out_qgroup:
+
 	/*
 	 * Release the reserved range from inode dirty range map, as it is
 	 * already moved into delayed_ref_head
@@ -2924,7 +3046,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->disk_len,
 						logical_len, logical_len,
 						compress_type, 0, 0,
-						BTRFS_FILE_EXTENT_REG);
+						BTRFS_FILE_EXTENT_REG,
+						ordered_extent->hash);
 		if (!ret)
 			btrfs_release_delalloc_bytes(root,
 						     ordered_extent->start,
@@ -2953,6 +3076,9 @@ out_unlock:
 			     ordered_extent->file_offset +
 			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
 out:
+	/* free dedup hash */
+	kfree(ordered_extent->hash);
+
 	if (root != root->fs_info->tree_root)
 		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
 	if (trans)
@@ -2984,7 +3110,6 @@ out:
 						   ordered_extent->disk_len, 1);
 	}
 
-
 	/*
 	 * This needs to be done to make sure anybody waiting knows we are done
 	 * updating everything for this ordered extent.
@@ -9805,7 +9930,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
 						  ins.offset, 0, 0, 0,
-						  BTRFS_FILE_EXTENT_PREALLOC);
+						  BTRFS_FILE_EXTENT_PREALLOC,
+						  NULL);
 		if (ret) {
 			btrfs_free_reserved_extent(root, ins.objectid,
 						   ins.offset, 0);
-- 
2.7.0



