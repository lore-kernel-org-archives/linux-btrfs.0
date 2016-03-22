Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:44502 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755663AbcCVBpc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 21:45:32 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v8 09/27] btrfs: dedupe: Inband in-memory only de-duplication implement
Date: Tue, 22 Mar 2016 09:35:34 +0800
Message-Id: <1458610552-9845-10-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1458610552-9845-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Core implement for inband de-duplication.
It reuse the async_cow_start() facility to do the calculate dedupe hash.
And use dedupe hash to do inband de-duplication at extent level.

The work flow is as below:
1) Run delalloc range for an inode
2) Calculate hash for the delalloc range at the unit of dedupe_bs
3) For hash match(duplicated) case, just increase source extent ref
   and insert file extent.
   For hash mismatch case, go through the normal cow_file_range()
   fallback, and add hash into dedupe_tree.
   Compress for hash miss case is not supported yet.

Current implement restore all dedupe hash in memory rb-tree, with LRU
behavior to control the limit.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |  18 ++++++
 fs/btrfs/inode.c       | 168 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 162 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 53e1297..dabd721 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -37,6 +37,7 @@
 #include "math.h"
 #include "sysfs.h"
 #include "qgroup.h"
+#include "dedupe.h"
 
 #undef SCRAMBLE_DELAYED_REFS
 
@@ -2399,6 +2400,8 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 
 	if (btrfs_delayed_ref_is_head(node)) {
 		struct btrfs_delayed_ref_head *head;
+		struct btrfs_fs_info *fs_info = root->fs_info;
+
 		/*
 		 * we've hit the end of the chain and we were supposed
 		 * to insert this extent into the tree.  But, it got
@@ -2413,6 +2416,15 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
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
+				btrfs_dedupe_del(trans, fs_info, node->bytenr);
 				ret = btrfs_del_csums(trans, root,
 						      node->bytenr,
 						      node->num_bytes);
@@ -6713,6 +6725,12 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
+			ret = btrfs_dedupe_del(trans, info, bytenr);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, extent_root,
+							ret);
+				goto out;
+			}
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, extent_root, ret);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 41a5688..13ae366 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -60,6 +60,7 @@
 #include "hash.h"
 #include "props.h"
 #include "qgroup.h"
+#include "dedupe.h"
 
 struct btrfs_iget_args {
 	struct btrfs_key *location;
@@ -106,7 +107,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent);
 static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
-				   unsigned long *nr_written, int unlock);
+				   unsigned long *nr_written, int unlock,
+				   struct btrfs_dedupe_hash *hash);
 static struct extent_map *create_pinned_em(struct inode *inode, u64 start,
 					   u64 len, u64 orig_start,
 					   u64 block_start, u64 block_len,
@@ -335,6 +337,7 @@ struct async_extent {
 	struct page **pages;
 	unsigned long nr_pages;
 	int compress_type;
+	struct btrfs_dedupe_hash *hash;
 	struct list_head list;
 };
 
@@ -353,7 +356,8 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 compressed_size,
 				     struct page **pages,
 				     unsigned long nr_pages,
-				     int compress_type)
+				     int compress_type,
+				     struct btrfs_dedupe_hash *hash)
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
 
@@ -687,6 +692,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree;
+	struct btrfs_dedupe_hash *hash;
 	int ret = 0;
 
 again:
@@ -696,6 +702,7 @@ again:
 		list_del(&async_extent->list);
 
 		io_tree = &BTRFS_I(inode)->io_tree;
+		hash = async_extent->hash;
 
 retry:
 		/* did the compression code fall back to uncompressed IO? */
@@ -712,7 +719,8 @@ retry:
 					     async_extent->start,
 					     async_extent->start +
 					     async_extent->ram_size - 1,
-					     &page_started, &nr_written, 0);
+					     &page_started, &nr_written, 0,
+					     hash);
 
 			/* JDM XXX */
 
@@ -925,7 +933,7 @@ static noinline int cow_file_range(struct inode *inode,
 				   struct page *locked_page,
 				   u64 start, u64 end, int *page_started,
 				   unsigned long *nr_written,
-				   int unlock)
+				   int unlock, struct btrfs_dedupe_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 alloc_hint = 0;
@@ -984,11 +992,16 @@ static noinline int cow_file_range(struct inode *inode,
 		unsigned long op;
 
 		cur_alloc_size = disk_num_bytes;
-		ret = btrfs_reserve_extent(root, cur_alloc_size,
+		if (btrfs_dedupe_hash_hit(hash)) {
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
@@ -1025,8 +1038,9 @@ static noinline int cow_file_range(struct inode *inode,
 			goto out_reserve;
 
 		cur_alloc_size = ins.offset;
-		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-					       ram_size, cur_alloc_size, 0);
+		ret = btrfs_add_ordered_extent_dedupe(inode, start,
+				ins.objectid, cur_alloc_size, ins.offset,
+				0, hash);
 		if (ret)
 			goto out_drop_extent_cache;
 
@@ -1076,6 +1090,68 @@ out_unlock:
 	goto out;
 }
 
+static int hash_file_ranges(struct inode *inode, u64 start, u64 end,
+			    struct async_cow *async_cow, int *num_added)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+	struct page *locked_page = async_cow->locked_page;
+	u16 hash_algo;
+	u64 actual_end;
+	u64 isize = i_size_read(inode);
+	u64 dedupe_bs;
+	u64 cur_offset = start;
+	int ret = 0;
+
+	actual_end = min_t(u64, isize, end + 1);
+	/* If dedupe is not enabled, don't split extent into dedupe_bs */
+	if (fs_info->dedupe_enabled && dedupe_info) {
+		dedupe_bs = dedupe_info->blocksize;
+		hash_algo = dedupe_info->hash_type;
+	} else {
+		dedupe_bs = SZ_128M;
+		/* Just dummy, to avoid access NULL pointer */
+		hash_algo = BTRFS_DEDUPE_HASH_SHA256;
+	}
+
+	while (cur_offset < end) {
+		struct btrfs_dedupe_hash *hash = NULL;
+		u64 len;
+
+		len = min(end + 1 - cur_offset, dedupe_bs);
+		if (len < dedupe_bs)
+			goto next;
+
+		hash = btrfs_dedupe_alloc_hash(hash_algo);
+		if (!hash) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = btrfs_dedupe_calc_hash(fs_info, inode, cur_offset, hash);
+		if (ret < 0)
+			goto out;
+
+		ret = btrfs_dedupe_search(fs_info, inode, cur_offset, hash);
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
+	return ret;
+}
+
 /*
  * work queue call back to started compression on a file and pages
  */
@@ -1083,11 +1159,18 @@ static noinline void async_cow_start(struct btrfs_work *work)
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
@@ -1136,6 +1219,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 {
 	struct async_cow *async_cow;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
 	unsigned long nr_pages;
 	u64 cur_end;
 	int limit = 10 * SZ_1M;
@@ -1150,7 +1235,11 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
 
-		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
+		if (fs_info->dedupe_enabled && dedupe_info) {
+			u64 len = max_t(u64, SZ_512K, dedupe_info->blocksize);
+
+			cur_end = min(end, start + len - 1);
+		} else if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
 		    !btrfs_test_opt(root, FORCE_COMPRESS))
 			cur_end = end;
 		else
@@ -1407,7 +1496,7 @@ out_check:
 		if (cow_start != (u64)-1) {
 			ret = cow_file_range(inode, locked_page,
 					     cow_start, found_key.offset - 1,
-					     page_started, nr_written, 1);
+					     page_started, nr_written, 1, NULL);
 			if (ret) {
 				if (!nolock && nocow)
 					btrfs_end_write_no_snapshoting(root);
@@ -1486,7 +1575,7 @@ out_check:
 
 	if (cow_start != (u64)-1) {
 		ret = cow_file_range(inode, locked_page, cow_start, end,
-				     page_started, nr_written, 1);
+				     page_started, nr_written, 1, NULL);
 		if (ret)
 			goto error;
 	}
@@ -1537,6 +1626,8 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 {
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
@@ -1544,9 +1635,9 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode)) {
+	} else if (!inode_need_compress(inode) && !fs_info->dedupe_enabled) {
 		ret = cow_file_range(inode, locked_page, start, end,
-				      page_started, nr_written, 1);
+				      page_started, nr_written, 1, NULL);
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
 			&BTRFS_I(inode)->runtime_flags);
@@ -2076,7 +2167,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       u64 disk_bytenr, u64 disk_num_bytes,
 				       u64 num_bytes, u64 ram_bytes,
 				       u8 compression, u8 encryption,
-				       u16 other_encoding, int extent_type)
+				       u16 other_encoding, int extent_type,
+				       struct btrfs_dedupe_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_extent_item *fi;
@@ -2138,10 +2230,37 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.objectid = disk_bytenr;
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
-	ret = btrfs_alloc_reserved_file_extent(trans, root,
+
+	/*
+	 * Only for no-dedupe or hash miss case, we need to increase
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
+	/*
+	 * Hash hit won't create a new data extent, so its reserved quota
+	 * space won't be freed by new delayed_ref_head.
+	 * Need to free it here.
+	 */
+	if (btrfs_dedupe_hash_hit(hash))
+		btrfs_qgroup_free_data(inode, file_pos, ram_bytes);
+
+	/* Add missed hash into dedupe tree */
+	if (hash && hash->bytenr == 0) {
+		hash->bytenr = ins.objectid;
+		hash->num_bytes = ins.offset;
+		ret = btrfs_dedupe_add(trans, root->fs_info, hash);
+	}
+
+out_qgroup:
+
 	/*
 	 * Release the reserved range from inode dirty range map, as it is
 	 * already moved into delayed_ref_head
@@ -2925,7 +3044,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->disk_len,
 						logical_len, logical_len,
 						compress_type, 0, 0,
-						BTRFS_FILE_EXTENT_REG);
+						BTRFS_FILE_EXTENT_REG,
+						ordered_extent->hash);
 		if (!ret)
 			btrfs_release_delalloc_bytes(root,
 						     ordered_extent->start,
@@ -2985,7 +3105,6 @@ out:
 						   ordered_extent->disk_len, 1);
 	}
 
-
 	/*
 	 * This needs to be done to make sure anybody waiting knows we are done
 	 * updating everything for this ordered extent.
@@ -9948,7 +10067,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
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
2.7.3



