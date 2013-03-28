Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:11981 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3C1IJl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 04:09:41 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r2S89ZkG021890
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 16:09:37 +0800
Message-ID: <5153FB01.9030506@cn.fujitsu.com>
Date: Thu, 28 Mar 2013 16:10:41 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/4] Btrfs: improve the performance of the csums lookup
Content-Type: text/plain; charset=UTF-8
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
 fs/btrfs/extent_io.c    | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h    |  2 ++
 fs/btrfs/file-item.c    | 45 ++++++++++++++++++++++++++-------------------
 fs/btrfs/ordered-data.c | 24 ++++++++++++++----------
 fs/btrfs/ordered-data.h |  3 ++-
 5 files changed, 75 insertions(+), 30 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f173c5a..3da8da5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1744,6 +1744,37 @@ out:
 	return ret;
 }
 
+void cache_csums(struct extent_io_tree *tree, u64 start, u32 csums[],
+		 int count, int sectorsize)
+{
+	struct rb_node *node;
+	struct extent_state *state, *next;
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
+		BUG_ON(state->end + 1 - state->start != sectorsize);
+
+		state->private = *csums++;
+		count--;
+		next = next_state(state);
+
+		BUG_ON(count && (!next || next->start != state->end + 1));
+
+		state = next;
+	}
+	spin_unlock(&tree->lock);
+}
+
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private)
 {
 	struct rb_node *node;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 6068a19..b95fb6a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -261,6 +261,8 @@ int extent_readpages(struct extent_io_tree *tree,
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent);
 int set_state_private(struct extent_io_tree *tree, u64 start, u64 private);
+void cache_csums(struct extent_io_tree *tree, u64 start, u32 csums[],
+		 int count, int sectorsize);
 int get_state_private(struct extent_io_tree *tree, u64 start, u64 *private);
 void set_page_extent_mapped(struct page *page);
 
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index b7e529d..3e2f080 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -175,7 +175,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				   struct inode *inode, struct bio *bio,
 				   u64 logical_offset, u32 *dst, int dio)
 {
-	u32 sum;
+	u32 sum[16];
+	int len;
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int bio_index = 0;
 	u64 offset = 0;
@@ -184,7 +185,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	u64 disk_bytenr;
 	u32 diff;
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
-	int ret;
+	int count;
+	int index;
 	struct btrfs_path *path;
 	struct btrfs_csum_item *item = NULL;
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
@@ -212,10 +214,11 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 	if (dio)
 		offset = logical_offset;
 	while (bio_index < bio->bi_vcnt) {
+		len = min_t(int, ARRAY_SIZE(sum), bio->bi_vcnt - bio_index);
 		if (!dio)
 			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
-		ret = btrfs_find_ordered_sum(inode, offset, disk_bytenr, &sum);
-		if (ret == 0)
+		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr, sum, len);
+		if (count)
 			goto found;
 
 		if (!item || disk_bytenr < item_start_offset ||
@@ -228,10 +231,8 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
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
@@ -267,19 +268,25 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 		diff = disk_bytenr - item_start_offset;
 		diff = diff / root->sectorsize;
 		diff = diff * csum_size;
-
-		read_extent_buffer(path->nodes[0], &sum,
+		count = min_t(int, len, (item_last_offset - disk_bytenr) /
+					root->sectorsize);
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
+			for (index = 0; index < count; index++)
+				*dst++ = sum[index];
+		} else {
+			cache_csums(io_tree, offset, sum, count,
+				    root->sectorsize);
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
index dc08d77..2b959b6 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -984,7 +984,7 @@ out:
  * be reclaimed before their checksum is actually put into the btree
  */
 int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
-			   u32 *sum)
+			   u32 *sum, int len)
 {
 	struct btrfs_ordered_sum *ordered_sum;
 	struct btrfs_sector_sum *sector_sums;
@@ -993,22 +993,26 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
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
+		if (disk_bytenr >= ordered_sum->bytenr &&
+		    disk_bytenr < ordered_sum->bytenr + ordered_sum->len) {
+			i = (disk_bytenr - ordered_sum->bytenr) / sectorsize;
+			sector_sums = ordered_sum->sums + i;
 			num_sectors = ordered_sum->len / sectorsize;
-			sector_sums = ordered_sum->sums;
-			for (i = 0; i < num_sectors; i++) {
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
@@ -1016,7 +1020,7 @@ int btrfs_find_ordered_sum(struct inode *inode, u64 offset, u64 disk_bytenr,
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
