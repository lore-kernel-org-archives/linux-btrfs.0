Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3GKF1G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jul 2013 01:27:06 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6B5QxDQ001051
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jul 2013 13:27:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/5] Btrfs: don't cache the csum value into the extent state tree
Date: Thu, 11 Jul 2013 13:25:38 +0800
Message-Id: <1373520339-13870-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
References: <1373520339-13870-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before applying this patch, we cached the csum value into the extent state
tree when reading some data from the disk, this operation increased the lock
contention of the state tree.

Now, we just store the csum value into the bio structure or other unshared
structure, so we can reduce the lock contention.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |  21 +++++++++
 fs/btrfs/ctree.h       |   4 +-
 fs/btrfs/disk-io.c     |   5 ++-
 fs/btrfs/extent_io.c   | 113 ++++++++++++++++---------------------------------
 fs/btrfs/extent_io.h   |  10 ++---
 fs/btrfs/file-item.c   |  81 +++++++++++++++++++++++------------
 fs/btrfs/inode.c       |  85 +++++++++++++++----------------------
 fs/btrfs/volumes.h     |   7 +++
 8 files changed, 163 insertions(+), 163 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 08b286b..d0ae226 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -218,6 +218,27 @@ static inline int btrfs_inode_in_log(struct inode *inode, u64 generation)
 	return 0;
 }
 
+struct btrfs_dio_private {
+	struct inode *inode;
+	u64 logical_offset;
+	u64 disk_bytenr;
+	u64 bytes;
+	void *private;
+
+	/* number of bios pending for this dio */
+	atomic_t pending_bios;
+
+	/* IO errors */
+	int errors;
+
+	/* orig_bio is our btrfs_io_bio */
+	struct bio *orig_bio;
+
+	/* dio_bio came from fs/direct-io.c */
+	struct bio *dio_bio;
+	u8 csum[0];
+};
+
 /*
  * Disable DIO read nolock optimization, so new dio readers will be forced
  * to grab i_mutex. It is used to avoid the endless truncate due to
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index f5b4b72..d52ec5d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3556,12 +3556,14 @@ int btrfs_find_name_in_ext_backref(struct btrfs_path *path,
 				   struct btrfs_inode_extref **extref_ret);
 
 /* file-item.c */
+struct btrfs_dio_private;
 int btrfs_del_csums(struct btrfs_trans_handle *trans,
 		    struct btrfs_root *root, u64 bytenr, u64 len);
 int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 			  struct bio *bio, u32 *dst);
 int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
-			      struct bio *bio, u64 logical_offset);
+			      struct btrfs_dio_private *dip, struct bio *bio,
+			      u64 logical_offset);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dfe6864..290b83f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -576,8 +576,9 @@ static noinline int check_leaf(struct btrfs_root *root,
 	return 0;
 }
 
-static int btree_readpage_end_io_hook(struct page *page, u64 start, u64 end,
-			       struct extent_state *state, int mirror)
+static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
+				      u64 phy_offset, struct page *page,
+				      u64 start, u64 end, int mirror)
 {
 	struct extent_io_tree *tree;
 	u64 found_start;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c9b28cf..9f4dedf 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1837,64 +1837,6 @@ out:
 	return ret;
 }
 
-void extent_cache_csums_dio(struct extent_io_tree *tree, u64 start, u32 csums[],
-			    int count)
-{
-	struct rb_node *node;
-	struct extent_state *state;
-
-	spin_lock(&tree->lock);
-	/*
-	 * this search will find all the extents that end after
-	 * our range starts.
-	 */
-	node = tree_search(tree, start);
-	BUG_ON(!node);
-
-	state = rb_entry(node, struct extent_state, rb_node);
-	BUG_ON(state->start != start);
-
-	while (count) {
-		state->private = *csums++;
-		count--;
-		state = next_state(state);
-	}
-	spin_unlock(&tree->lock);
-}
-
-static inline u64 __btrfs_get_bio_offset(struct bio *bio, int bio_index)
-{
-	struct bio_vec *bvec = bio->bi_io_vec + bio_index;
-
-	return page_offset(bvec->bv_page) + bvec->bv_offset;
-}
-
-void extent_cache_csums(struct extent_io_tree *tree, struct bio *bio, int bio_index,
-			u32 csums[], int count)
-{
-	struct rb_node *node;
-	struct extent_state *state = NULL;
-	u64 start;
-
-	spin_lock(&tree->lock);
-	do {
-		start = __btrfs_get_bio_offset(bio, bio_index);
-		if (state == NULL || state->start != start) {
-			node = tree_search(tree, start);
-			BUG_ON(!node);
-
-			state = rb_entry(node, struct extent_state, rb_node);
-			BUG_ON(state->start != start);
-		}
-		state->private = *csums++;
-		count--;
-		bio_index++;
-
-		state = next_state(state);
-	} while (count);
-	spin_unlock(&tree->lock);
-}
-
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 {
 	struct rb_node *node;
@@ -2201,8 +2143,9 @@ out:
  * needed
  */
 
-static int bio_readpage_error(struct bio *failed_bio, struct page *page,
-				u64 start, u64 end, int failed_mirror)
+static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
+			      struct page *page, u64 start, u64 end,
+			      int failed_mirror)
 {
 	struct io_failure_record *failrec = NULL;
 	u64 private;
@@ -2211,8 +2154,9 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	struct extent_state *state;
 	struct bio *bio;
+	struct btrfs_io_bio *btrfs_failed_bio;
+	struct btrfs_io_bio *btrfs_bio;
 	int num_copies;
 	int ret;
 	int read_mode;
@@ -2303,13 +2247,6 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 		return -EIO;
 	}
 
-	spin_lock(&tree->lock);
-	state = find_first_extent_bit_state(tree, failrec->start,
-					    EXTENT_LOCKED);
-	if (state && state->start != failrec->start)
-		state = NULL;
-	spin_unlock(&tree->lock);
-
 	/*
 	 * there are two premises:
 	 *	a) deliver good data to the caller
@@ -2346,9 +2283,8 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 		read_mode = READ_SYNC;
 	}
 
-	if (!state || failrec->this_mirror > num_copies) {
-		pr_debug("bio_readpage_error: (fail) state=%p, num_copies=%d, "
-			 "next_mirror %d, failed_mirror %d\n", state,
+	if (failrec->this_mirror > num_copies) {
+		pr_debug("bio_readpage_error: (fail) num_copies=%d, next_mirror %d, failed_mirror %d\n",
 			 num_copies, failrec->this_mirror, failed_mirror);
 		free_io_failure(inode, failrec, 0);
 		return -EIO;
@@ -2359,12 +2295,24 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 		free_io_failure(inode, failrec, 0);
 		return -EIO;
 	}
-	bio->bi_private = state;
 	bio->bi_end_io = failed_bio->bi_end_io;
 	bio->bi_sector = failrec->logical >> 9;
 	bio->bi_bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 	bio->bi_size = 0;
 
+	btrfs_failed_bio = btrfs_io_bio(failed_bio);
+	if (btrfs_failed_bio->csum) {
+		struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+		u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
+
+		btrfs_bio = btrfs_io_bio(bio);
+		btrfs_bio->csum = btrfs_bio->csum_inline;
+		phy_offset >>= inode->i_sb->s_blocksize_bits;
+		phy_offset *= csum_size;
+		memcpy(btrfs_bio->csum, btrfs_failed_bio->csum + phy_offset,
+		       csum_size);
+	}
+
 	bio_add_page(bio, page, failrec->len, start - page_offset(page));
 
 	pr_debug("bio_readpage_error: submitting new read[%#x] to "
@@ -2463,9 +2411,12 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
 	struct bio_vec *bvec = bio->bi_io_vec;
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	struct extent_io_tree *tree;
+	u64 offset = 0;
 	u64 start;
 	u64 end;
+	u64 len;
 	int mirror;
 	int ret;
 
@@ -2476,7 +2427,6 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		struct page *page = bvec->bv_page;
 		struct extent_state *cached = NULL;
 		struct extent_state *state;
-		struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 		struct inode *inode = page->mapping->host;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
@@ -2497,6 +2447,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 		start = page_offset(page);
 		end = start + bvec->bv_offset + bvec->bv_len - 1;
+		len = bvec->bv_len;
 
 		if (++bvec <= bvec_end)
 			prefetchw(&bvec->bv_page->flags);
@@ -2515,8 +2466,9 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		mirror = io_bio->mirror_num;
 		if (likely(uptodate && tree->ops &&
 			   tree->ops->readpage_end_io_hook)) {
-			ret = tree->ops->readpage_end_io_hook(page, start, end,
-							      state, mirror);
+			ret = tree->ops->readpage_end_io_hook(io_bio, offset,
+							      page, start, end,
+							      mirror);
 			if (ret)
 				uptodate = 0;
 			else
@@ -2542,7 +2494,8 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			 * can't handle the error it will return -EIO and we
 			 * remain responsible for that page.
 			 */
-			ret = bio_readpage_error(bio, page, start, end, mirror);
+			ret = bio_readpage_error(bio, offset, page, start, end,
+						 mirror);
 			if (ret == 0) {
 				uptodate =
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -2574,8 +2527,11 @@ readpage_ok:
 			SetPageError(page);
 		}
 		unlock_page(page);
+		offset += len;
 	} while (bvec <= bvec_end);
 
+	if (io_bio->end_io)
+		io_bio->end_io(io_bio, err);
 	bio_put(bio);
 }
 
@@ -2587,6 +2543,7 @@ struct bio *
 btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		gfp_t gfp_flags)
 {
+	struct btrfs_io_bio *btrfs_bio;
 	struct bio *bio;
 
 	bio = bio_alloc_bioset(gfp_flags, nr_vecs, btrfs_bioset);
@@ -2602,6 +2559,10 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		bio->bi_size = 0;
 		bio->bi_bdev = bdev;
 		bio->bi_sector = first_sector;
+		btrfs_bio = btrfs_io_bio(bio);
+		btrfs_bio->csum = NULL;
+		btrfs_bio->csum_allocated = NULL;
+		btrfs_bio->end_io = NULL;
 	}
 	return bio;
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3b8c4e2..f7544af 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -62,6 +62,7 @@
 
 struct extent_state;
 struct btrfs_root;
+struct btrfs_io_bio;
 
 typedef	int (extent_submit_bio_hook_t)(struct inode *inode, int rw,
 				       struct bio *bio, int mirror_num,
@@ -77,8 +78,9 @@ struct extent_io_ops {
 			      size_t size, struct bio *bio,
 			      unsigned long bio_flags);
 	int (*readpage_io_failed_hook)(struct page *page, int failed_mirror);
-	int (*readpage_end_io_hook)(struct page *page, u64 start, u64 end,
-				    struct extent_state *state, int mirror);
+	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
+				    struct page *page, u64 start, u64 end,
+				    int mirror);
 	int (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
 				      struct extent_state *state, int uptodate);
 	void (*set_bit_hook)(struct inode *inode, struct extent_state *state,
@@ -262,10 +264,6 @@ int extent_readpages(struct extent_io_tree *tree,
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent);
 int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
-void extent_cache_csums_dio(struct extent_io_tree *tree, u64 start, u32 csums[],
-			    int count);
-void extent_cache_csums(struct extent_io_tree *tree, struct bio *bio,
-			int bvec_index, u32 csums[], int count);
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
 void set_page_extent_mapped(struct page *page);
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index a7bfc95..f87d09a 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -23,6 +23,7 @@
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
+#include "volumes.h"
 #include "print-tree.h"
 
 #define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
@@ -152,28 +153,54 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static void btrfs_io_bio_endio_readpage(struct btrfs_io_bio *bio, int err)
+{
+	kfree(bio->csum_allocated);
+}
+
 static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				   struct inode *inode, struct bio *bio,
 				   u64 logical_offset, u32 *dst, int dio)
 {
-	u32 sum[16];
-	int len;
 	struct bio_vec *bvec = bio->bi_io_vec;
-	int bio_index = 0;
+	struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
+	struct btrfs_csum_item *item = NULL;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct btrfs_path *path;
+	u8 *csum;
 	u64 offset = 0;
 	u64 item_start_offset = 0;
 	u64 item_last_offset = 0;
 	u64 disk_bytenr;
 	u32 diff;
-	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+	int nblocks;
+	int bio_index = 0;
 	int count;
-	struct btrfs_path *path;
-	struct btrfs_csum_item *item = NULL;
-	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
+
+	nblocks = bio->bi_size >> inode->i_sb->s_blocksize_bits;
+	if (!dst) {
+		if (nblocks * csum_size > BTRFS_BIO_INLINE_CSUM_SIZE) {
+			btrfs_bio->csum_allocated = kmalloc(nblocks * csum_size,
+							    GFP_NOFS);
+			if (!btrfs_bio->csum_allocated) {
+				btrfs_free_path(path);
+				return -ENOMEM;
+			}
+			btrfs_bio->csum = btrfs_bio->csum_allocated;
+			btrfs_bio->end_io = btrfs_io_bio_endio_readpage;
+		} else {
+			btrfs_bio->csum = btrfs_bio->csum_inline;
+		}
+		csum = btrfs_bio->csum;
+	} else {
+		csum = (u8 *)dst;
+	}
+
 	if (bio->bi_size > PAGE_CACHE_SIZE * 8)
 		path->reada = 2;
 
@@ -194,11 +221,10 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	if (dio)
 		offset = logical_offset;
 	while (bio_index < bio->bi_vcnt) {
-		len = min_t(int, ARRAY_SIZE(sum), bio->bi_vcnt - bio_index);
 		if (!dio)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
-		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr, sum,
-					       len);
+		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
+					       (u32 *)csum, nblocks);
 		if (count)
 			goto found;
 
@@ -213,7 +239,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 						 path, disk_bytenr, 0);
 			if (IS_ERR(item)) {
 				count = 1;
-				sum[0] = 0;
+				memset(csum, 0, csum_size);
 				if (BTRFS_I(inode)->root->root_key.objectid ==
 				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 					set_extent_bits(io_tree, offset,
@@ -249,23 +275,14 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 		diff = disk_bytenr - item_start_offset;
 		diff = diff / root->sectorsize;
 		diff = diff * csum_size;
-		count = min_t(int, len, (item_last_offset - disk_bytenr) >>
-					inode->i_sb->s_blocksize_bits);
-		read_extent_buffer(path->nodes[0], sum,
+		count = min_t(int, nblocks, (item_last_offset - disk_bytenr) >>
+					    inode->i_sb->s_blocksize_bits);
+		read_extent_buffer(path->nodes[0], csum,
 				   ((unsigned long)item) + diff,
 				   csum_size * count);
 found:
-		if (dst) {
-			memcpy(dst, sum, count * csum_size);
-			dst += count;
-		} else {
-			if (dio)
-				extent_cache_csums_dio(io_tree, offset, sum,
-						       count);
-			else
-				extent_cache_csums(io_tree, bio, bio_index, sum,
-					    count);
-		}
+		csum += count * csum_size;
+		nblocks -= count;
 		while (count--) {
 			disk_bytenr += bvec->bv_len;
 			offset += bvec->bv_len;
@@ -284,9 +301,19 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 }
 
 int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
-			      struct bio *bio, u64 offset)
+			      struct btrfs_dio_private *dip, struct bio *bio,
+			      u64 offset)
 {
-	return __btrfs_lookup_bio_sums(root, inode, bio, offset, NULL, 1);
+	int len = (bio->bi_sector << 9) - dip->disk_bytenr;
+	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+	int ret;
+
+	len >>= inode->i_sb->s_blocksize_bits;
+	len *= csum_size;
+
+	ret = __btrfs_lookup_bio_sums(root, inode, bio, offset,
+				      (u32 *)(dip->csum + len), 1);
+	return ret;
 }
 
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3332424..2b79026 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2826,16 +2826,16 @@ static int btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
  * if there's a match, we allow the bio to finish.  If not, the code in
  * extent_io.c will try to find good copies for us.
  */
-static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
-			       struct extent_state *state, int mirror)
+static int btrfs_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
+				      u64 phy_offset, struct page *page,
+				      u64 start, u64 end, int mirror)
 {
 	size_t offset = start - page_offset(page);
 	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	char *kaddr;
-	u64 private = ~(u32)0;
-	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	u32 csum_expected;
 	u32 csum = ~(u32)0;
 	static DEFINE_RATELIMIT_STATE(_rs, DEFAULT_RATELIMIT_INTERVAL,
 	                              DEFAULT_RATELIMIT_BURST);
@@ -2855,19 +2855,13 @@ static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 		return 0;
 	}
 
-	if (state && state->start == start) {
-		private = state->private;
-		ret = 0;
-	} else {
-		ret = get_state_private(io_tree, start, &private);
-	}
-	kaddr = kmap_atomic(page);
-	if (ret)
-		goto zeroit;
+	phy_offset >>= inode->i_sb->s_blocksize_bits;
+	csum_expected = *(((u32 *)io_bio->csum) + phy_offset);
 
+	kaddr = kmap_atomic(page);
 	csum = btrfs_csum_data(kaddr + offset, csum,  end - start + 1);
 	btrfs_csum_final(csum, (char *)&csum);
-	if (csum != private)
+	if (csum != csum_expected)
 		goto zeroit;
 
 	kunmap_atomic(kaddr);
@@ -2876,14 +2870,13 @@ good:
 
 zeroit:
 	if (__ratelimit(&_rs))
-		btrfs_info(root->fs_info, "csum failed ino %llu off %llu csum %u private %llu",
+		btrfs_info(root->fs_info, "csum failed ino %llu off %llu csum %u expected csum %u",
 			(unsigned long long)btrfs_ino(page->mapping->host),
-			(unsigned long long)start, csum,
-			(unsigned long long)private);
+			(unsigned long long)start, csum, csum_expected);
 	memset(kaddr + offset, 1, end - start + 1);
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr);
-	if (private == 0)
+	if (csum_expected == 0)
 		return 0;
 	return -EIO;
 }
@@ -6837,26 +6830,6 @@ unlock_err:
 	return ret;
 }
 
-struct btrfs_dio_private {
-	struct inode *inode;
-	u64 logical_offset;
-	u64 disk_bytenr;
-	u64 bytes;
-	void *private;
-
-	/* number of bios pending for this dio */
-	atomic_t pending_bios;
-
-	/* IO errors */
-	int errors;
-
-	/* orig_bio is our btrfs_io_bio */
-	struct bio *orig_bio;
-
-	/* dio_bio came from fs/direct-io.c */
-	struct bio *dio_bio;
-};
-
 static void btrfs_endio_direct_read(struct bio *bio, int err)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
@@ -6865,6 +6838,8 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct bio *dio_bio;
+	u32 *csums = (u32 *)dip->csum;
+	int index = 0;
 	u64 start;
 
 	start = dip->logical_offset;
@@ -6873,12 +6848,8 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			struct page *page = bvec->bv_page;
 			char *kaddr;
 			u32 csum = ~(u32)0;
-			u64 private = ~(u32)0;
 			unsigned long flags;
 
-			if (get_state_private(&BTRFS_I(inode)->io_tree,
-					      start, &private))
-				goto failed;
 			local_irq_save(flags);
 			kaddr = kmap_atomic(page);
 			csum = btrfs_csum_data(kaddr + bvec->bv_offset,
@@ -6888,18 +6859,18 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			local_irq_restore(flags);
 
 			flush_dcache_page(bvec->bv_page);
-			if (csum != private) {
-failed:
-				btrfs_err(root->fs_info, "csum failed ino %llu off %llu csum %u private %u",
-					(unsigned long long)btrfs_ino(inode),
-					(unsigned long long)start,
-					csum, (unsigned)private);
+			if (csum != csums[index]) {
+				btrfs_err(root->fs_info, "csum failed ino %llu off %llu csum %u expected csum %u",
+					  (unsigned long long)btrfs_ino(inode),
+					  (unsigned long long)start,
+					  csum, csums[index]);
 				err = -EIO;
 			}
 		}
 
 		start += bvec->bv_len;
 		bvec++;
+		index++;
 	} while (bvec <= bvec_end);
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
@@ -7016,6 +6987,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 					 int rw, u64 file_offset, int skip_sum,
 					 int async_submit)
 {
+	struct btrfs_dio_private *dip = bio->bi_private;
 	int write = rw & REQ_WRITE;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
@@ -7050,7 +7022,8 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 		if (ret)
 			goto err;
 	} else if (!skip_sum) {
-		ret = btrfs_lookup_bio_sums_dio(root, inode, bio, file_offset);
+		ret = btrfs_lookup_bio_sums_dio(root, inode, dip, bio,
+						file_offset);
 		if (ret)
 			goto err;
 	}
@@ -7085,6 +7058,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 		bio_put(orig_bio);
 		return -EIO;
 	}
+
 	if (map_length >= orig_bio->bi_size) {
 		bio = orig_bio;
 		goto submit;
@@ -7180,19 +7154,28 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 	struct btrfs_dio_private *dip;
 	struct bio *io_bio;
 	int skip_sum;
+	int sum_len;
 	int write = rw & REQ_WRITE;
 	int ret = 0;
+	u16 csum_size;
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
 	io_bio = btrfs_bio_clone(dio_bio, GFP_NOFS);
-
 	if (!io_bio) {
 		ret = -ENOMEM;
 		goto free_ordered;
 	}
 
-	dip = kmalloc(sizeof(*dip), GFP_NOFS);
+	if (!skip_sum && !write) {
+		csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
+		sum_len = dio_bio->bi_size >> inode->i_sb->s_blocksize_bits;
+		sum_len *= csum_size;
+	} else {
+		sum_len = 0;
+	}
+
+	dip = kmalloc(sizeof(*dip) + sum_len, GFP_NOFS);
 	if (!dip) {
 		ret = -ENOMEM;
 		goto free_io_bio;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 8670558..08c44d9 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -152,6 +152,8 @@ struct btrfs_fs_devices {
 	int rotating;
 };
 
+#define BTRFS_BIO_INLINE_CSUM_SIZE	64
+
 /*
  * we need the mirror number and stripe index to be passed around
  * the call chain while we are processing end_io (especially errors).
@@ -161,9 +163,14 @@ struct btrfs_fs_devices {
  * we allocate are actually btrfs_io_bios.  We'll cram as much of
  * struct btrfs_bio as we can into this over time.
  */
+typedef void (btrfs_io_bio_end_io_t) (struct btrfs_io_bio *bio, int err);
 struct btrfs_io_bio {
 	unsigned long mirror_num;
 	unsigned long stripe_index;
+	u8 *csum;
+	u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
+	u8 *csum_allocated;
+	btrfs_io_bio_end_io_t *end_io;
 	struct bio bio;
 };
 
-- 
1.8.1.4

