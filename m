Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7138 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933108AbcKNIAB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 03:00:01 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v14.1 13/16] btrfs: Introduce DEDUPE reserve type to fix false enospc for in-band dedupe
Date: Mon, 14 Nov 2016 15:58:36 +0800
Message-Id: <20161114075839.23587-14-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161114075839.23587-1-quwenruo@cn.fujitsu.com>
References: <20161114075839.23587-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

We can trigger false ENOSPC error if enabling in-band dedupe.
This is the same reason of compress false ENOSPC error:
Difference in max extent size can lead to too much space reserved for
metadata.

Since we already have type-based reserve facilities, add DEDUP reserve
type to fix such false ENOSPC error.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  4 ++-
 fs/btrfs/dedupe.h      | 18 +++++++++++++
 fs/btrfs/extent-tree.c | 14 +++++-----
 fs/btrfs/extent_io.c   |  9 ++++---
 fs/btrfs/extent_io.h   |  1 +
 fs/btrfs/file.c        |  3 +++
 fs/btrfs/inode.c       | 72 ++++++++++++++++++++++++++++++++++----------------
 fs/btrfs/ioctl.c       |  2 ++
 fs/btrfs/relocation.c  |  2 ++
 9 files changed, 91 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e21b315..d09d924 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -110,9 +110,11 @@ static const int btrfs_csum_sizes[] = { 4 };
 enum btrfs_metadata_reserve_type {
 	BTRFS_RESERVE_NORMAL,
 	BTRFS_RESERVE_COMPRESS,
+	BTRFS_RESERVE_DEDUPE,
 };
 
-u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type);
+u64 btrfs_max_extent_size(struct inode *inode,
+			  enum btrfs_metadata_reserve_type reserve_type);
 int inode_need_compress(struct inode *inode);
 
 struct btrfs_mapping_tree {
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index 8311ee1..50977c4 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -22,6 +22,7 @@
 #include <linux/btrfs.h>
 #include <linux/wait.h>
 #include <crypto/hash.h>
+#include "btrfs_inode.h"
 
 static const int btrfs_hash_sizes[] = { 32 };
 
@@ -63,6 +64,23 @@ struct btrfs_dedupe_info {
 
 struct btrfs_trans_handle;
 
+static inline u64 btrfs_dedupe_blocksize(struct inode *inode)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+
+	return fs_info->dedupe_info->blocksize;
+}
+
+static inline int inode_need_dedupe(struct inode *inode)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+
+	if (!fs_info->dedupe_enabled)
+		return 0;
+
+	return 1;
+}
+
 static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
 {
 	return (hash && hash->bytenr);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3c82730..77a7d41 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5862,7 +5862,7 @@ static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes,
 	unsigned drop_inode_space = 0;
 	unsigned dropped_extents = 0;
 	unsigned num_extents = 0;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 
 	num_extents = (unsigned)div64_u64(num_bytes + max_extent_size - 1,
 					  max_extent_size);
@@ -5935,15 +5935,17 @@ static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes,
 	return btrfs_calc_trans_metadata_size(root, old_csums - num_csums);
 }
 
-u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type)
+u64 btrfs_max_extent_size(struct inode *inode,
+			  enum btrfs_metadata_reserve_type reserve_type)
 {
 	if (reserve_type == BTRFS_RESERVE_NORMAL)
 		return BTRFS_MAX_EXTENT_SIZE;
 	else if (reserve_type == BTRFS_RESERVE_COMPRESS)
 		return SZ_128K;
-
-	ASSERT(0);
-	return BTRFS_MAX_EXTENT_SIZE;
+	else if (reserve_type == BTRFS_RESERVE_DEDUPE)
+		return btrfs_dedupe_blocksize(inode);
+	else
+		return BTRFS_MAX_EXTENT_SIZE;
 }
 
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes,
@@ -5958,7 +5960,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes,
 	int ret = 0;
 	bool delalloc_lock = true;
 	u64 to_free = 0;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 	unsigned dropped;
 	bool release_extra = false;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 854379d..d59e91d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -603,7 +603,7 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	if (bits & EXTENT_DELALLOC)
-		bits |= EXTENT_NORESERVE | EXTENT_COMPRESS;
+		bits |= EXTENT_NORESERVE | EXTENT_COMPRESS | EXTENT_DEDUPE;
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
@@ -746,7 +746,7 @@ static void adjust_one_outstanding_extent(struct inode *inode, u64 len,
 				enum btrfs_metadata_reserve_type reserve_type)
 {
 	unsigned old_extents, new_extents;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 
 	old_extents = div64_u64(len + max_extent_size - 1, max_extent_size);
 	new_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
@@ -785,7 +785,7 @@ void adjust_outstanding_extents(struct inode *inode, u64 start, u64 end,
 		 * The whole range is locked, so we can safely clear
 		 * EXTENT_COMPRESS flag.
 		 */
-		state->state &= ~EXTENT_COMPRESS;
+		state->state &= ~(EXTENT_COMPRESS | EXTENT_DEDUPE);
 		adjust_one_outstanding_extent(inode,
 				state->end - state->start + 1, reserve_type);
 		node = rb_next(node);
@@ -1577,7 +1577,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		state = rb_entry(node, struct extent_state, rb_node);
 		if (found && (state->start != cur_start ||
 			      (state->state & EXTENT_BOUNDARY) ||
-			      (state->state ^ pre_state) & EXTENT_COMPRESS)) {
+			      (state->state ^ pre_state) & (EXTENT_COMPRESS |
+			       EXTENT_DEDUPE))) {
 			goto out;
 		}
 		if (!(state->state & EXTENT_DELALLOC)) {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 09dbdd7..ae636d1 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -22,6 +22,7 @@
 #define EXTENT_QGROUP_RESERVED	(1U << 16)
 #define EXTENT_CLEAR_DATA_RESV	(1U << 17)
 #define EXTENT_COMPRESS		(1U << 18)
+#define EXTENT_DEDUPE		(1U << 19)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4abd280..b20ff44 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -42,6 +42,7 @@
 #include "volumes.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "dedupe.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
@@ -1534,6 +1535,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_SIZE - 1);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1f384e1..8959493 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -338,6 +338,7 @@ struct async_extent {
 	struct page **pages;
 	unsigned long nr_pages;
 	int compress_type;
+	int dedupe;
 	struct btrfs_dedupe_hash *hash;
 	struct list_head list;
 };
@@ -358,7 +359,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 				     u64 compressed_size,
 				     struct page **pages,
 				     unsigned long nr_pages,
-				     int compress_type,
+				     int compress_type, int dedupe,
 				     struct btrfs_dedupe_hash *hash)
 {
 	struct async_extent *async_extent;
@@ -371,6 +372,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 	async_extent->pages = pages;
 	async_extent->nr_pages = nr_pages;
 	async_extent->compress_type = compress_type;
+	async_extent->dedupe = dedupe;
 	async_extent->hash = hash;
 	list_add_tail(&async_extent->list, &cow->extents);
 	return 0;
@@ -604,7 +606,7 @@ cont:
 			 */
 			add_async_extent(async_cow, start, num_bytes,
 					total_compressed, pages, nr_pages_ret,
-					compress_type, NULL);
+					compress_type, 0, NULL);
 
 			if (start + num_bytes < end) {
 				start += num_bytes;
@@ -650,7 +652,7 @@ cleanup_and_bail_uncompressed:
 	if (redirty)
 		extent_range_redirty_for_io(inode, start, end);
 	add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0,
-			 BTRFS_COMPRESS_NONE, NULL);
+			 BTRFS_COMPRESS_NONE, 0, NULL);
 	*num_added += 1;
 
 	return;
@@ -756,10 +758,12 @@ retry:
 			 * 128MB as max extent size to re-calculate number of
 			 * outstanding extents for this extent.
 			 */
-			adjust_outstanding_extents(inode, async_extent->start,
-						   async_extent->start +
-						   async_extent->ram_size - 1,
-						   BTRFS_RESERVE_COMPRESS);
+			if (!async_extent->dedupe)
+				adjust_outstanding_extents(inode,
+					async_extent->start,
+					async_extent->start +
+					async_extent->ram_size - 1,
+					BTRFS_RESERVE_COMPRESS);
 			/* allocate blocks */
 			ret = cow_file_range(inode, async_cow->locked_page,
 					     async_extent->start,
@@ -1228,7 +1232,7 @@ next:
 			__set_page_dirty_nobuffers(locked_page);
 
 		add_async_extent(async_cow, cur_offset, len, 0, NULL, 0,
-				 BTRFS_COMPRESS_NONE, hash);
+				 BTRFS_COMPRESS_NONE, 1, hash);
 		cur_offset += len;
 		(*num_added)++;
 	}
@@ -1332,10 +1336,11 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 
 		if (reserve_type == BTRFS_RESERVE_COMPRESS)
 			cur_end = min(end, start + SZ_512K - 1);
-		else if (fs_info->dedupe_enabled && dedupe_info) {
+		else if (reserve_type == BTRFS_RESERVE_DEDUPE) {
 			u64 len = max_t(u64, SZ_512K, dedupe_info->blocksize);
 			cur_end = min(end, start + len - 1);
-		}
+		} else
+			ASSERT(0);
 
 		async_cow->end = cur_end;
 		INIT_LIST_HEAD(&async_cow->extents);
@@ -1735,31 +1740,33 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
-	int need_compress;
 	enum btrfs_metadata_reserve_type reserve_type = BTRFS_RESERVE_NORMAL;
-	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	int need_compress, need_dedupe;
 
 	need_compress = test_range_bit(io_tree, start, end,
 				       EXTENT_COMPRESS, 1, NULL);
+	need_dedupe = test_range_bit(io_tree, start, end,
+				     EXTENT_DEDUPE, 1, NULL);
 	if (need_compress)
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (need_dedupe)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
-		if (need_compress)
+		if (need_compress || need_dedupe)
 			adjust_outstanding_extents(inode, start, end,
 						   reserve_type);
 
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
-		if (need_compress)
+		if (need_compress || need_dedupe)
 			adjust_outstanding_extents(inode, start, end,
 						   reserve_type);
 
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!need_compress && !fs_info->dedupe_enabled) {
+	} else if (!need_compress && !need_dedupe) {
 		ret = cow_file_range(inode, locked_page, start, end, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
@@ -1787,7 +1794,9 @@ static void btrfs_split_extent_hook(struct inode *inode,
 
 	if (orig->state & EXTENT_COMPRESS)
 		reserve_type = BTRFS_RESERVE_COMPRESS;
-	max_extent_size = btrfs_max_extent_size(reserve_type);
+	else if (orig->state & EXTENT_DEDUPE)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+	max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 
 	size = orig->end - orig->start + 1;
 	if (size > max_extent_size) {
@@ -1838,7 +1847,9 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 
 	if (other->state & EXTENT_COMPRESS)
 		reserve_type = BTRFS_RESERVE_COMPRESS;
-	max_extent_size = btrfs_max_extent_size(reserve_type);
+	else if (other->state & EXTENT_DEDUPE)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+	max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 
 	if (new->start > other->start)
 		new_size = new->end - other->start + 1;
@@ -1953,7 +1964,9 @@ static void btrfs_set_bit_hook(struct inode *inode,
 
 		if (*bits & EXTENT_COMPRESS)
 			reserve_type = BTRFS_RESERVE_COMPRESS;
-		max_extent_size = btrfs_max_extent_size(reserve_type);
+		else if (*bits & EXTENT_DEDUPE)
+			reserve_type = BTRFS_RESERVE_DEDUPE;
+		max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 		num_extents = div64_u64(len + max_extent_size - 1,
 					max_extent_size);
 
@@ -2011,7 +2024,9 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 
 		if (state->state & EXTENT_COMPRESS)
 			reserve_type = BTRFS_RESERVE_COMPRESS;
-		max_extent_size = btrfs_max_extent_size(reserve_type);
+		else if (state->state & EXTENT_DEDUPE)
+			reserve_type = BTRFS_RESERVE_DEDUPE;
+		max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 		num_extents = div64_u64(len + max_extent_size - 1,
 					max_extent_size);
 
@@ -2224,13 +2239,15 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 {
 	int ret;
 	unsigned bits;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 	u64 num_extents = div64_u64(end - start + max_extent_size,
 				    max_extent_size);
 
 	/* compression path */
 	if (reserve_type == BTRFS_RESERVE_COMPRESS)
 		bits = EXTENT_DELALLOC | EXTENT_COMPRESS | EXTENT_UPTODATE;
+	else if (reserve_type == BTRFS_RESERVE_DEDUPE)
+		bits = EXTENT_DELALLOC | EXTENT_DEDUPE | EXTENT_UPTODATE;
 	else
 		bits = EXTENT_DELALLOC | EXTENT_UPTODATE;
 
@@ -2264,7 +2281,7 @@ int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
 {
 	int ret;
 	unsigned bits;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 	u64 num_extents = div64_u64(end - start + max_extent_size,
 				    max_extent_size);
 
@@ -2337,6 +2354,9 @@ again:
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
 					   PAGE_SIZE, reserve_type);
 	if (ret) {
@@ -3273,7 +3293,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags)) {
 		compress_type = ordered_extent->compress_type;
 		reserve_type = BTRFS_RESERVE_COMPRESS;
-	}
+	} else if (ordered_extent->hash)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
 		BUG_ON(compress_type);
@@ -5042,6 +5063,8 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
@@ -9332,6 +9355,9 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	/*
 	 * Reserving delalloc space after obtaining the page lock can lead to
 	 * deadlock. For example, if a dirty page is locked by this function
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 492ec2e..d9e87ac 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -61,6 +61,7 @@
 #include "qgroup.h"
 #include "tree-log.h"
 #include "compression.h"
+#include "dedupe.h"
 
 #ifdef CONFIG_64BIT
 /* If we have a 32-bit userspace and 64-bit kernel, then the UAPI
@@ -1142,6 +1143,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+
 	ret = btrfs_delalloc_reserve_space(inode,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, reserve_type);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 972393f..9881a78 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3159,6 +3159,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
 	if (!ra)
-- 
2.10.2



