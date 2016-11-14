Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7138 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932343AbcKNIAG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 03:00:06 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v14.1 12/16] btrfs: dedupe: Inband in-memory only de-duplication implement
Date: Mon, 14 Nov 2016 15:58:35 +0800
Message-Id: <20161114075839.23587-13-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161114075839.23587-1-quwenruo@cn.fujitsu.com>
References: <20161114075839.23587-1-quwenruo@cn.fujitsu.com>
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
 fs/btrfs/extent-tree.c |  20 ++++
 fs/btrfs/inode.c       | 253 +++++++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/relocation.c  |  16 ++++
 3 files changed, 258 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d5691b0..3c82730 100644
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
@@ -2414,6 +2417,18 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
 			btrfs_pin_extent(root, node->bytenr,
 					 node->num_bytes, 1);
 			if (head->is_data) {
+				/*
+				 * If insert_reserved is given, it means
+				 * a new extent is revered, then deleted
+				 * in one tran, and inc/dec get merged to 0.
+				 *
+				 * In this case, we need to remove its dedupe
+				 * hash.
+				 */
+				ret = btrfs_dedupe_del(trans, fs_info,
+						       node->bytenr);
+				if (ret < 0)
+					return ret;
 				ret = btrfs_del_csums(trans, root,
 						      node->bytenr,
 						      node->num_bytes);
@@ -7087,6 +7102,11 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 
 		if (is_data) {
+			ret = btrfs_dedupe_del(trans, info, bytenr);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, ret);
+				goto out;
+			}
 			ret = btrfs_del_csums(trans, root, bytenr, num_bytes);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f3ea0e0..1f384e1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -338,6 +338,7 @@ struct async_extent {
 	struct page **pages;
 	unsigned long nr_pages;
 	int compress_type;
+	struct btrfs_dedupe_hash *hash;
 	struct list_head list;
 };
 
@@ -349,6 +350,7 @@ struct async_cow {
 	u64 end;
 	struct list_head extents;
 	struct btrfs_work work;
+	enum btrfs_metadata_reserve_type reserve_type;
 };
 
 static noinline int add_async_extent(struct async_cow *cow,
@@ -356,7 +358,8 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 compressed_size,
 				     struct page **pages,
 				     unsigned long nr_pages,
-				     int compress_type)
+				     int compress_type,
+				     struct btrfs_dedupe_hash *hash)
 {
 	struct async_extent *async_extent;
 
@@ -368,6 +371,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 	async_extent->pages = pages;
 	async_extent->nr_pages = nr_pages;
 	async_extent->compress_type = compress_type;
+	async_extent->hash = hash;
 	list_add_tail(&async_extent->list, &cow->extents);
 	return 0;
 }
@@ -600,7 +604,7 @@ cont:
 			 */
 			add_async_extent(async_cow, start, num_bytes,
 					total_compressed, pages, nr_pages_ret,
-					compress_type);
+					compress_type, NULL);
 
 			if (start + num_bytes < end) {
 				start += num_bytes;
@@ -646,7 +650,7 @@ cleanup_and_bail_uncompressed:
 	if (redirty)
 		extent_range_redirty_for_io(inode, start, end);
 	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
-			 BTRFS_COMPRESS_NONE);
+			 BTRFS_COMPRESS_NONE, NULL);
 	*num_added += 1;
 
 	return;
@@ -675,6 +679,38 @@ static void free_async_extent_pages(struct async_extent *async_extent)
 	async_extent->pages = NULL;
 }
 
+static void end_dedupe_extent(struct inode *inode, u64 start,
+			      u32 len, unsigned long page_ops)
+{
+	int i;
+	unsigned int nr_pages = len / PAGE_SIZE;
+	struct page *page;
+
+	for (i = 0; i < nr_pages; i++) {
+		page = find_get_page(inode->i_mapping,
+				     start >> PAGE_SHIFT);
+		/* page should be already locked by caller */
+		if (WARN_ON(!page))
+			continue;
+
+		/* We need to do this by ourselves as we skipped IO */
+		if (page_ops & PAGE_CLEAR_DIRTY)
+			clear_page_dirty_for_io(page);
+		if (page_ops & PAGE_SET_WRITEBACK)
+			set_page_writeback(page);
+
+		end_extent_writepage(page, 0, start,
+				     start + PAGE_SIZE - 1);
+		if (page_ops & PAGE_END_WRITEBACK)
+			end_page_writeback(page);
+		if (page_ops & PAGE_UNLOCK)
+			unlock_page(page);
+
+		start += PAGE_SIZE;
+		put_page(page);
+	}
+}
+
 /*
  * phase two of compressed writeback.  This is the ordered portion
  * of the code, which only gets called in the order the work was
@@ -691,6 +727,7 @@ static noinline void submit_compressed_extents(struct inode *inode,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree;
+	struct btrfs_dedupe_hash *hash;
 	int ret = 0;
 
 again:
@@ -700,6 +737,7 @@ again:
 		list_del(&async_extent->list);
 
 		io_tree = &BTRFS_I(inode)->io_tree;
+		hash = async_extent->hash;
 
 retry:
 		/* did the compression code fall back to uncompressed IO? */
@@ -730,7 +768,7 @@ retry:
 					     async_extent->start +
 					     async_extent->ram_size - 1,
 					     &page_started, &nr_written, 0,
-					     NULL);
+					     hash);
 
 			/* JDM XXX */
 
@@ -740,15 +778,26 @@ retry:
 			 * and IO for us.  Otherwise, we need to submit
 			 * all those pages down to the drive.
 			 */
-			if (!page_started && !ret)
-				extent_write_locked_range(io_tree,
-						  inode, async_extent->start,
-						  async_extent->start +
-						  async_extent->ram_size - 1,
-						  btrfs_get_extent,
-						  WB_SYNC_ALL);
-			else if (ret)
+			if (!page_started && !ret) {
+				/* Skip IO for dedupe async_extent */
+				if (btrfs_dedupe_hash_hit(hash))
+					end_dedupe_extent(inode,
+						async_extent->start,
+						async_extent->ram_size,
+						PAGE_CLEAR_DIRTY |
+						PAGE_SET_WRITEBACK |
+						PAGE_END_WRITEBACK |
+						PAGE_UNLOCK);
+				else
+					extent_write_locked_range(io_tree,
+						inode, async_extent->start,
+						async_extent->start +
+						async_extent->ram_size - 1,
+						btrfs_get_extent,
+						WB_SYNC_ALL);
+			} else if (ret)
 				unlock_page(async_cow->locked_page);
+			kfree(hash);
 			kfree(async_extent);
 			cond_resched();
 			continue;
@@ -878,6 +927,7 @@ retry:
 			free_async_extent_pages(async_extent);
 		}
 		alloc_hint = ins.objectid + ins.offset;
+		kfree(hash);
 		kfree(async_extent);
 		cond_resched();
 	}
@@ -897,6 +947,7 @@ out_free:
 				     PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK |
 				     PAGE_SET_ERROR);
 	free_async_extent_pages(async_extent);
+	kfree(hash);
 	kfree(async_extent);
 	goto again;
 }
@@ -1011,11 +1062,17 @@ static noinline int cow_file_range(struct inode *inode,
 		unsigned long op;
 
 		cur_alloc_size = disk_num_bytes;
-		ret = btrfs_reserve_extent(root, cur_alloc_size, cur_alloc_size,
+		if (btrfs_dedupe_hash_hit(hash)) {
+			ins.objectid = hash->bytenr;
+			ins.offset = hash->num_bytes;
+		} else {
+			ret = btrfs_reserve_extent(root, cur_alloc_size,
+					   cur_alloc_size,
 					   root->sectorsize, 0, alloc_hint,
 					   &ins, 1, 1);
-		if (ret < 0)
-			goto out_unlock;
+			if (ret < 0)
+				goto out_unlock;
+		}
 
 		em = alloc_extent_map();
 		if (!em) {
@@ -1052,8 +1109,9 @@ static noinline int cow_file_range(struct inode *inode,
 			goto out_reserve;
 
 		cur_alloc_size = ins.offset;
-		ret = btrfs_add_ordered_extent(inode, start, ins.objectid,
-					       ram_size, cur_alloc_size, 0);
+		ret = btrfs_add_ordered_extent_dedupe(inode, start,
+				ins.objectid, cur_alloc_size, ins.offset,
+				0, hash);
 		if (ret)
 			goto out_drop_extent_cache;
 
@@ -1065,7 +1123,14 @@ static noinline int cow_file_range(struct inode *inode,
 				goto out_drop_extent_cache;
 		}
 
-		btrfs_dec_block_group_reservations(root->fs_info, ins.objectid);
+		/*
+		 * Hash hit didn't allocate extent, no need to dec bg
+		 * reservation.
+		 * Or we will underflow reservations and block balance.
+		 */
+		if (!btrfs_dedupe_hash_hit(hash))
+			btrfs_dec_block_group_reservations(root->fs_info,
+							   ins.objectid);
 
 		if (disk_num_bytes < cur_alloc_size)
 			break;
@@ -1108,6 +1173,79 @@ out_unlock:
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
+	u64 dedupe_bs;
+	u64 cur_offset = start;
+	int ret = 0;
+
+	/* If dedupe is not enabled, don't split extent into dedupe_bs */
+	if (fs_info->dedupe_enabled && dedupe_info) {
+		dedupe_bs = dedupe_info->blocksize;
+		hash_algo = dedupe_info->hash_algo;
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
+		if (ret < 0) {
+			kfree(hash);
+			goto out;
+		}
+
+		ret = btrfs_dedupe_search(fs_info, inode, cur_offset, hash);
+		if (ret < 0) {
+			kfree(hash);
+			goto out;
+		}
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
+	/*
+	 * Caller won't unlock pages, so if error happens, we must unlock
+	 * pages by ourselves.
+	 */
+	if (ret)
+		extent_clear_unlock_delalloc(inode, cur_offset,
+			end, end, NULL, EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
+			EXTENT_DELALLOC | EXTENT_DEFRAG, PAGE_UNLOCK |
+			PAGE_CLEAR_DIRTY | PAGE_SET_WRITEBACK |
+			PAGE_END_WRITEBACK | PAGE_SET_ERROR);
+	return ret;
+}
+
 /*
  * work queue call back to started compression on a file and pages
  */
@@ -1115,11 +1253,17 @@ static noinline void async_cow_start(struct btrfs_work *work)
 {
 	struct async_cow *async_cow;
 	int num_added = 0;
+	int ret = 0;
 	async_cow = container_of(work, struct async_cow, work);
 
-	compress_file_range(async_cow->inode, async_cow->locked_page,
-			    async_cow->start, async_cow->end, async_cow,
-			    &num_added);
+	if (async_cow->reserve_type == BTRFS_RESERVE_COMPRESS)
+		compress_file_range(async_cow->inode, async_cow->locked_page,
+				    async_cow->start, async_cow->end, async_cow,
+				    &num_added);
+	else
+		ret = hash_file_ranges(async_cow->inode, async_cow->start,
+				       async_cow->end, async_cow, &num_added);
+
 	if (num_added == 0) {
 		btrfs_add_delayed_iput(async_cow->inode);
 		async_cow->inode = NULL;
@@ -1169,6 +1313,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 {
 	struct async_cow *async_cow;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
 	unsigned long nr_pages;
 	u64 cur_end;
 	int limit = 10 * SZ_1M;
@@ -1182,11 +1328,14 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
+		async_cow->reserve_type = reserve_type;
 
 		if (reserve_type == BTRFS_RESERVE_COMPRESS)
 			cur_end = min(end, start + SZ_512K - 1);
-		else
-			ASSERT(0);
+		else if (fs_info->dedupe_enabled && dedupe_info) {
+			u64 len = max_t(u64, SZ_512K, dedupe_info->blocksize);
+			cur_end = min(end, start + len - 1);
+		}
 
 		async_cow->end = cur_end;
 		INIT_LIST_HEAD(&async_cow->extents);
@@ -1588,6 +1737,8 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	int need_compress;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	need_compress = test_range_bit(io_tree, start, end,
 				       EXTENT_COMPRESS, 1, NULL);
@@ -1608,7 +1759,7 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!need_compress) {
+	} else if (!need_compress && !fs_info->dedupe_enabled) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
@@ -2250,7 +2401,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       u64 disk_bytenr, u64 disk_num_bytes,
 				       u64 num_bytes, u64 ram_bytes,
 				       u8 compression, u8 encryption,
-				       u16 other_encoding, int extent_type)
+				       u16 other_encoding, int extent_type,
+				       struct btrfs_dedupe_hash *hash)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_file_extent_item *fi;
@@ -2312,10 +2464,43 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
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
+	 * Hash hit won't create a new data extent, so its reserved
+	 * space won't be freed by new delayed_ref_head.
+	 * Need to free it here.
+	 */
+	if (btrfs_dedupe_hash_hit(hash))
+		btrfs_free_reserved_data_space(inode, file_pos, ram_bytes);
+
+	/* Add missed hash into dedupe tree */
+	if (hash && hash->bytenr == 0) {
+		hash->bytenr = ins.objectid;
+		hash->num_bytes = ins.offset;
+
+		/*
+		 * Here we ignore dedupe_add error, as even it failed,
+		 * it won't corrupt the filesystem. It will only only slightly
+		 * reduce dedup rate
+		 */
+		btrfs_dedupe_add(trans, root->fs_info, hash);
+	}
+
+out_qgroup:
+
 	/*
 	 * Release the reserved range from inode dirty range map, as it is
 	 * already moved into delayed_ref_head
@@ -3007,6 +3192,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	bool nolock;
 	bool truncated = false;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
+	int hash_hit = btrfs_dedupe_hash_hit(ordered_extent->hash);
 
 	nolock = btrfs_is_free_space_inode(inode);
 
@@ -3103,8 +3289,10 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 						ordered_extent->disk_len,
 						logical_len, logical_len,
 						compress_type, 0, 0,
-						BTRFS_FILE_EXTENT_REG);
-		if (!ret)
+						BTRFS_FILE_EXTENT_REG,
+						ordered_extent->hash);
+		/* Hash hit case doesn't reserve delalloc bytes */
+		if (!ret && !hash_hit)
 			btrfs_release_delalloc_bytes(root,
 						     ordered_extent->start,
 						     ordered_extent->disk_len);
@@ -3156,15 +3344,17 @@ out:
 		 * wrong we need to return the space for this ordered extent
 		 * back to the allocator.  We only free the extent in the
 		 * truncated case if we didn't write out the extent at all.
+		 *
+		 * For hash hit case, never free that extent, as it's being used
+		 * by others.
 		 */
-		if ((ret || !logical_len) &&
+		if ((ret || !logical_len) && !hash_hit &&
 		    !test_bit(BTRFS_ORDERED_NOCOW, &ordered_extent->flags) &&
 		    !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags))
 			btrfs_free_reserved_extent(root, ordered_extent->start,
 						   ordered_extent->disk_len, 1);
 	}
 
-
 	/*
 	 * This needs to be done to make sure anybody waiting knows we are done
 	 * updating everything for this ordered extent.
@@ -10524,7 +10714,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 						  cur_offset, ins.objectid,
 						  ins.offset, ins.offset,
 						  ins.offset, 0, 0, 0,
-						  BTRFS_FILE_EXTENT_PREALLOC);
+						  BTRFS_FILE_EXTENT_PREALLOC,
+						  NULL);
 		if (ret) {
 			btrfs_free_reserved_extent(root, ins.objectid,
 						   ins.offset, 0);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 08cfb47..972393f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -32,6 +32,7 @@
 #include "free-space-cache.h"
 #include "inode-map.h"
 #include "qgroup.h"
+#include "dedupe.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -4046,6 +4047,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_path *path;
 	struct btrfs_extent_item *ei;
+	struct btrfs_fs_info *fs_info = rc->extent_root->fs_info;
 	u64 flags;
 	u32 item_size;
 	int ret;
@@ -4168,6 +4170,20 @@ restart:
 				rc->search_start = key.objectid;
 			}
 		}
+		/*
+		 * This data extent will be replaced, but normal dedupe_del()
+		 * will only happen at run_delayed_ref() time, which is too
+		 * late, so delete dedupe_hash early to prevent its ref get
+		 * increased during relocation
+		 */
+		if (rc->stage == MOVE_DATA_EXTENTS &&
+		    (flags & BTRFS_EXTENT_FLAG_DATA)) {
+			ret = btrfs_dedupe_del(trans, fs_info, key.objectid);
+			if (ret < 0) {
+				err = ret;
+				break;
+			}
+		}
 
 		btrfs_end_transaction_throttle(trans, rc->extent_root);
 		btrfs_btree_balance_dirty(rc->extent_root);
-- 
2.10.2



