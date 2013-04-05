Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:36434 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1765525Ab3DEHTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Apr 2013 03:19:43 -0400
Message-ID: <515E7B58.7050904@cn.fujitsu.com>
Date: Fri, 05 Apr 2013 15:20:56 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH V3 1/2] Btrfs: improve the performance of the csums lookup
References: <5153FB01.9030506@cn.fujitsu.com> <515BF138.90309@cn.fujitsu.com> <20130404131204.GQ1876@localhost.localdomain>
In-Reply-To: <20130404131204.GQ1876@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It is very likely that there are several blocks in bio, it is very
inefficient if we get their csums one by one. This patch improves
this problem by getting the csums in batch.

According to the result of the following test, the execute time of
__btrfs_lookup_bio_sums() is down by ~28%(300us -> 217us).

 # dd if=<mnt>/file of=/dev/null bs=1M count=1024

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v2 -> v3:
- address the problem that the logical offset of the pages in the same bio is
  not contiguous.

Changelog v1 -> v2:
- fix 64bit division problem on i386 machine
---
 fs/btrfs/extent_io.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h    |  4 ++++
 fs/btrfs/file-item.c    | 49 +++++++++++++++++++++++++----------------
 fs/btrfs/ordered-data.c | 28 ++++++++++++++----------
 fs/btrfs/ordered-data.h |  3 ++-
 5 files changed, 111 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cdee391..19dd3da 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1777,6 +1777,64 @@ out:
 	return ret;
 }
 
+void extent_cache_csums_dio(struct extent_io_tree *tree, u64 start, u32 csums[],
+			    int count)
+{
+	struct rb_node *node;
+	struct extent_state *state;
+
+	spin_lock(&tree->lock);
+	/*
+	 * this search will find all the extents that end after
+	 * our range starts.
+	 */
+	node = tree_search(tree, start);
+	BUG_ON(!node);
+
+	state = rb_entry(node, struct extent_state, rb_node);
+	BUG_ON(state->start != start);
+
+	while (count) {
+		state->private = *csums++;
+		count--;
+		state = next_state(state);
+	}
+	spin_unlock(&tree->lock);
+}
+
+static inline u64 __btrfs_get_bio_offset(struct bio *bio, int bio_index)
+{
+	struct bio_vec *bvec = bio->bi_io_vec + bio_index;
+
+	return page_offset(bvec->bv_page) + bvec->bv_offset;
+}
+
+void extent_cache_csums(struct extent_io_tree *tree, struct bio *bio, int bio_index,
+			u32 csums[], int count)
+{
+	struct rb_node *node;
+	struct extent_state *state = NULL;
+	u64 start;
+
+	spin_lock(&tree->lock);
+	do {
+		start = __btrfs_get_bio_offset(bio, bio_index);
+		if (state == NULL || state->start != start) {
+			node = tree_search(tree, start);
+			BUG_ON(!node);
+
+			state = rb_entry(node, struct extent_state, rb_node);
+			BUG_ON(state->start != start);
+		}
+		state->private = *csums++;
+		count--;
+		bio_index++;
+
+		state = next_state(state);
+	} while (count);
+	spin_unlock(&tree->lock);
+}
+
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 {
 	struct rb_node *node;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 258c921..db009d8 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -261,6 +261,10 @@ int extent_readpages(struct extent_io_tree *tree,
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent);
 int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
+void extent_cache_csums_dio(struct extent_io_tree *tree, u64 start, u32 csums[],
+			    int count);
+void extent_cache_csums(struct extent_io_tree *tree, struct bio *bio,
+			int bvec_index, u32 csums[], int count);
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
 void set_page_extent_mapped(struct page *page);
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index c4628a2..7e4df79 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -177,7 +177,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				   struct inode *inode, struct bio *bio,
 				   u64 logical_offset, u32 *dst, int dio)
 {
-	u32 sum;
+	u32 sum[16];
+	int len;
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int bio_index = 0;
 	u64 offset = 0;
@@ -186,7 +187,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	u64 disk_bytenr;
 	u32 diff;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
-	int ret;
+	int count;
 	struct btrfs_path *path;
 	struct btrfs_csum_item *item = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
@@ -214,10 +215,12 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	if (dio)
 		offset = logical_offset;
 	while (bio_index < bio->bi_vcnt) {
+		len = min_t(int, ARRAY_SIZE(sum), bio->bi_vcnt - bio_index);
 		if (!dio)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
-		ret = btrfs_find_ordered_sum(inode, offset, disk_bytenr, &sum);
-		if (ret == 0)
+		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr, sum,
+					       len);
+		if (count)
 			goto found;
 
 		if (!item || disk_bytenr < item_start_offset ||
@@ -230,10 +233,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 			item = btrfs_lookup_csum(NULL, root->fs_info->csum_root,
 						 path, disk_bytenr, 0);
 			if (IS_ERR(item)) {
-				ret = PTR_ERR(item);
-				if (ret == -ENOENT || ret == -EFBIG)
-					ret = 0;
-				sum = 0;
+				count = 1;
+				sum[0] = 0;
 				if (BTRFS_I(inode)->root->root_key.objectid ==
 				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 					set_extent_bits(io_tree, offset,
@@ -269,19 +270,29 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 		diff = disk_bytenr - item_start_offset;
 		diff = diff / root->sectorsize;
 		diff = diff * csum_size;
-
-		read_extent_buffer(path->nodes[0], &sum,
+		count = min_t(int, len, (item_last_offset - disk_bytenr) >>
+					inode->i_sb->s_blocksize_bits);
+		read_extent_buffer(path->nodes[0], sum,
 				   ((unsigned long)item) + diff,
-				   csum_size);
+				   csum_size * count);
 found:
-		if (dst)
-			*dst++ = sum;
-		else
-			set_state_private(io_tree, offset, sum);
-		disk_bytenr += bvec->bv_len;
-		offset += bvec->bv_len;
-		bio_index++;
-		bvec++;
+		if (dst) {
+			memcpy(dst, sum, count * csum_size);
+			dst += count;
+		} else {
+			if (dio)
+				extent_cache_csums_dio(io_tree, offset, sum,
+						       count);
+			else
+				extent_cache_csums(io_tree, bio, bio_index, sum,
+					    count);
+		}
+		while (count--) {
+			disk_bytenr += bvec->bv_len;
+			offset += bvec->bv_len;
+			bio_index++;
+			bvec++;
+		}
 	}
 	btrfs_free_path(path);
 	return 0;
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 005c45d..1ddd728 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -986,7 +986,7 @@ out:
  * be reclaimed before their checksum is actually put into the btree
  */
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
-			   u32 *sum)
+			   u32 *sum, int len)
 {
 	struct btrfs_ordered_sum *ordered_sum;
 	struct btrfs_sector_sum *sector_sums;
@@ -995,22 +995,28 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 	unsigned long num_sectors;
 	unsigned long i;
 	u32 sectorsize = BTRFS_I(inode)->root->sectorsize;
-	int ret = 1;
+	int index = 0;
 
 	ordered = btrfs_lookup_ordered_extent(inode, offset);
 	if (!ordered)
-		return 1;
+		return 0;
 
 	spin_lock_irq(&tree->lock);
 	list_for_each_entry_reverse(ordered_sum, &ordered->list, list) {
-		if (disk_bytenr >= ordered_sum->bytenr) {
-			num_sectors = ordered_sum->len / sectorsize;
-			sector_sums = ordered_sum->sums;
-			for (i = 0; i < num_sectors; i++) {
+		if (disk_bytenr >= ordered_sum->bytenr &&
+		    disk_bytenr < ordered_sum->bytenr + ordered_sum->len) {
+			i = (disk_bytenr - ordered_sum->bytenr) >>
+			    inode->i_sb->s_blocksize_bits;
+			sector_sums = ordered_sum->sums + i;
+			num_sectors = ordered_sum->len >>
+				      inode->i_sb->s_blocksize_bits;
+			for (; i < num_sectors; i++) {
 				if (sector_sums[i].bytenr == disk_bytenr) {
-					*sum = sector_sums[i].sum;
-					ret = 0;
-					goto out;
+					sum[index] = sector_sums[i].sum;
+					index++;
+					if (index == len)
+						goto out;
+					disk_bytenr += sectorsize;
 				}
 			}
 		}
@@ -1018,7 +1024,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
 out:
 	spin_unlock_irq(&tree->lock);
 	btrfs_put_ordered_extent(ordered);
-	return ret;
+	return index;
 }
 
 
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 8eadfe4..58b0e3b 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -196,7 +196,8 @@ struct btrfs_ordered_extent *btrfs_lookup_ordered_range(struct inode *inode,
 							u64 len);
 int btrfs_ordered_update_i_size(struct inode *inode, u64 offset,
 				struct btrfs_ordered_extent *ordered);
-int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr, u32 *sum);
+int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
+			   u32 *sum, int len);
 int btrfs_run_ordered_operations(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root, int wait);
 void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
-- 
1.8.0.1

