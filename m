From: WuBo <wu.bo@cn.fujitsu.com>
Subject: [RFC][PATCH] Btrfs: Fix the write error into prealloc file
Date: Thu, 29 Sep 2011 14:51:11 +0800
Message-ID: <4E84155F.509@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

reproduce:
dd if=/dev/zero of=prealloc_test bs=4K count=1
fallocate -n -o 4K -l 1M prealloc_test
dd if=/dev/zero of=tmpfile1 bs=1M
dd if=/dev/zero of=tmpfile2 bs=4K
dd if=/dev/zero of=prealloc_test seek=1 bs=4K count=2 conv=notrunc

Although the prealloc_test file still has space, the write will be
failed. Because the reserve code think the space is full.
Before reserve the data space for writing, checking whether the inode
has prealloc extent or not. If match the range, it's means we don't 
need reserve the space. I also use a extra bit EXTENT_PREALLOC to
record the NO-need-reserve-space extent_state.

There is a another dangerous that if after we don't reserve the 
prealloc range, there is a writeback thread change the prealloc range
into regular range nicely. The reserve space will wrong, what we do
is waiting all the dirty pages in prealloc range to write back.

I made it for RFC because this patch will lead to performance decay
also with disk fragment growth.

Signed-off-by: Wu Bo <wu.bo@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |    6 ++-
 fs/btrfs/extent-tree.c |   30 ++++++++++--
 fs/btrfs/extent_io.c   |   17 +++++++
 fs/btrfs/extent_io.h   |    6 +++
 fs/btrfs/file.c        |    2 +-
 fs/btrfs/inode.c       |  114 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/ioctl.c       |    2 +-
 7 files changed, 161 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8b99c79..030cd28 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2234,7 +2234,8 @@ int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_pending_snapshot *pending);
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
 void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes);
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 start,
+				 u64 num_bytes);
 void btrfs_delalloc_release_space(struct inode *inode, u64 num_bytes);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root);
@@ -2595,6 +2596,9 @@ int btrfs_prealloc_file_range_trans(struct inode *inode,
 				    u64 start, u64 num_bytes, u64 min_size,
 				    loff_t actual_len, u64 *alloc_hint);
 extern const struct dentry_operations btrfs_dentry_operations;
+extern int btrfs_search_prealloc_file_range(struct inode *inode,
+					    u64 start, u64 len,
+					    u64 *need_reserve);
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 80d6148..2a37571 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4054,17 +4054,37 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 				to_free);
 }
 
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 num_bytes)
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 num_bytes)
 {
 	int ret;
+	u64 need_reserve = num_bytes;
 
-	ret = btrfs_check_data_free_space(inode, num_bytes);
-	if (ret)
-		return ret;
+	if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC) {
+		struct extent_state *cached_state = NULL;
+
+		lock_extent_bits(&BTRFS_I(inode)->io_tree, start,
+				 start + num_bytes - 1, 0,
+				 &cached_state, GFP_NOFS);
+
+		ret = btrfs_search_prealloc_file_range(inode,
+				start, num_bytes, &need_reserve);
+
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, start,
+				     start + num_bytes - 1,
+				     &cached_state, GFP_NOFS);
+		if (ret)
+			return ret;
+	}
+
+	if (need_reserve != 0) {
+		ret = btrfs_check_data_free_space(inode, need_reserve);
+		if (ret)
+			return ret;
+	}
 
 	ret = btrfs_delalloc_reserve_metadata(inode, num_bytes);
 	if (ret) {
-		btrfs_free_reserved_data_space(inode, num_bytes);
+		btrfs_free_reserved_data_space(inode, need_reserve);
 		return ret;
 	}
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8491712..b872a04 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -953,6 +953,20 @@ static int clear_extent_uptodate(struct extent_io_tree *tree, u64 start,
 				cached_state, mask);
 }
 
+int set_extent_prealloc(struct extent_io_tree *tree, u64 start, u64 end,
+			gfp_t mask)
+{
+	return set_extent_bit(tree, start, end, EXTENT_PREALLOC, 0, NULL,
+			      NULL, mask);
+}
+
+int clear_extent_prealloc(struct extent_io_tree *tree, u64 start, u64 end,
+			  gfp_t mask)
+{
+	return clear_extent_bit(tree, start, end, EXTENT_PREALLOC, 0, 0,
+				NULL, mask);
+}
+
 /*
  * either insert or lock state struct between start and end use mask to tell
  * us if waiting is desired.
@@ -1348,6 +1362,9 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 	if (op & EXTENT_CLEAR_DELALLOC)
 		clear_bits |= EXTENT_DELALLOC;
 
+	if (op & EXTENT_CLEAR_PREALLOC)
+		clear_bits |= EXTENT_PREALLOC;
+
 	clear_extent_bit(tree, start, end, clear_bits, 1, 0, NULL, GFP_NOFS);
 	if (!(op & (EXTENT_CLEAR_UNLOCK_PAGE | EXTENT_CLEAR_DIRTY |
 		    EXTENT_SET_WRITEBACK | EXTENT_END_WRITEBACK |
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7b2f0c3..dec16a4 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -17,6 +17,7 @@
 #define EXTENT_NODATASUM (1 << 10)
 #define EXTENT_DO_ACCOUNTING (1 << 11)
 #define EXTENT_FIRST_DELALLOC (1 << 12)
+#define EXTENT_PREALLOC (1 << 13)
 #define EXTENT_IOBITS (EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS (EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -42,6 +43,7 @@
 #define EXTENT_END_WRITEBACK	 0x20
 #define EXTENT_SET_PRIVATE2	 0x40
 #define EXTENT_CLEAR_ACCOUNTING  0x80
+#define EXTENT_CLEAR_PREALLOC	 0x100
 
 /*
  * page->private values.  Every page that is controlled by the extent
@@ -216,6 +218,10 @@ int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask);
 int set_extent_delalloc(struct extent_io_tree *tree, u64 start, u64 end,
 			struct extent_state **cached_state, gfp_t mask);
+int set_extent_prealloc(struct extent_io_tree *tree, u64 start, u64 end,
+			gfp_t mask);
+int clear_extent_prealloc(struct extent_io_tree *tree, u64 start, u64 end,
+			  gfp_t mask);
 int find_first_extent_bit(struct extent_io_tree *tree, u64 start,
 			  u64 *start_ret, u64 *end_ret, int bits);
 struct extent_state *find_first_extent_bit_state(struct extent_io_tree *tree,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 15e5a1c..ffc72fb 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1195,7 +1195,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			break;
 		}
 
-		ret = btrfs_delalloc_reserve_space(inode,
+		ret = btrfs_delalloc_reserve_space(inode, pos,
 					num_pages << PAGE_CACHE_SHIFT);
 		if (ret)
 			break;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 34195f9..d28c028 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1230,7 +1230,7 @@ out_check:
 				cur_offset, cur_offset + num_bytes - 1,
 				locked_page, EXTENT_CLEAR_UNLOCK_PAGE |
 				EXTENT_CLEAR_UNLOCK | EXTENT_CLEAR_DELALLOC |
-				EXTENT_SET_PRIVATE2);
+				EXTENT_CLEAR_PREALLOC | EXTENT_SET_PRIVATE2);
 		cur_offset = extent_end;
 		if (cur_offset > end)
 			break;
@@ -1380,7 +1380,8 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 			btrfs_delalloc_release_metadata(inode, len);
 
 		if (root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
-		    && do_list)
+		    && do_list
+		    && !(state->state & EXTENT_PREALLOC))
 			btrfs_free_reserved_data_space(inode, len);
 
 		spin_lock(&root->fs_info->delalloc_lock);
@@ -3374,7 +3375,7 @@ static int btrfs_truncate_page(struct address_space *mapping, loff_t from)
 
 	if ((offset & (blocksize - 1)) == 0)
 		goto out;
-	ret = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	ret = btrfs_delalloc_reserve_space(inode, offset, PAGE_CACHE_SIZE);
 	if (ret)
 		goto out;
 
@@ -6161,15 +6162,15 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 		return 0;
 	}
 
-	lockstart = offset;
-	lockend = offset + count - 1;
-
 	if (writing) {
-		ret = btrfs_delalloc_reserve_space(inode, count);
+		ret = btrfs_delalloc_reserve_space(inode, offset, count);
 		if (ret)
 			goto out;
 	}
 
+	lockstart = offset;
+	lockend = offset + count - 1;
+
 	while (1) {
 		lock_extent_bits(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 				 0, &cached_state, GFP_NOFS);
@@ -6395,7 +6396,8 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	u64 page_start;
 	u64 page_end;
 
-	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
+	ret  = btrfs_delalloc_reserve_space(inode, page_offset(page),
+					    PAGE_CACHE_SIZE);
 	if (ret) {
 		if (ret == -ENOMEM)
 			ret = VM_FAULT_OOM;
@@ -7228,6 +7230,102 @@ out_unlock:
 	return err;
 }
 
+/*
+ * If the file has prealloc area, the reserve code should not reserve
+ * bytes covered over the prealloc range. But if another writeback
+ * thread change prealloc range to regular range, that made our reserve
+ * wrong. Here what we do is write back all the dirty pages in prealloc
+ * range.
+ */
+static void btrfs_writeback_prealloc_file_range(struct inode *inode,
+						loff_t pos, size_t len)
+{
+	struct btrfs_ordered_extent *ordered;
+
+	while (1) {
+		btrfs_wait_ordered_range(inode, pos, len);
+
+		/*
+		 * During btrfs_search_prealloc_file_range,
+		 * we already lock the extent.
+		 */
+		ordered = btrfs_lookup_ordered_extent(inode, pos);
+		if (!ordered)
+			break;
+
+		btrfs_put_ordered_extent(ordered);
+	}
+}
+
+/*
+ * helper to calc the real space need to reserve.
+ * if the range is in prealloc range, this range don't need reserve
+ * also the prealloc range will be set PREALLOC bit and writeback
+ */
+int btrfs_search_prealloc_file_range(struct inode *inode, u64 start, u64 len,
+				     u64 *need_reserve)
+{
+	struct extent_map *em = NULL;
+	u64 search_start;
+	u64 end;
+	u64 last_byte;
+	u64 mask;
+	int ret = 0;
+
+	*need_reserve = len;
+	mask = BTRFS_I(inode)->root->sectorsize - 1;
+	start = start & ~mask;
+	end = (start + len + mask) & ~mask;
+	search_start = start;
+	while (1) {
+		em = btrfs_get_extent(inode, NULL, 0, search_start,
+				      end - search_start, 0);
+		BUG_ON(IS_ERR_OR_NULL(em));
+
+		last_byte = min(extent_map_end(em), end);
+		last_byte = (last_byte + mask) & ~mask;
+		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
+			u64 em_start = em->start;
+			u64 em_end = extent_map_end(em);
+
+			if (start > em_start && end < em_end) {
+				*need_reserve = 0;
+				set_extent_prealloc(&BTRFS_I(inode)->io_tree,
+					start, end, GFP_NOFS);
+				btrfs_writeback_prealloc_file_range(inode,
+					start, end - start);
+			} else if (start <= em_start && end < em_end) {
+				*need_reserve = len - end + em_start;
+				set_extent_prealloc(&BTRFS_I(inode)->io_tree,
+					em_start, end, GFP_NOFS);
+				btrfs_writeback_prealloc_file_range(inode,
+					em_start, end - em_start);
+			} else if (start > em_start && end >= em_end) {
+				*need_reserve = len - em_end + start;
+				set_extent_prealloc(&BTRFS_I(inode)->io_tree,
+					start, em_end, GFP_NOFS);
+				btrfs_writeback_prealloc_file_range(inode,
+					start, em_end - start);
+			} else {
+				*need_reserve = em_end - em_start;
+				set_extent_prealloc(&BTRFS_I(inode)->io_tree,
+					em_start, em_end, GFP_NOFS);
+				btrfs_writeback_prealloc_file_range(inode,
+					em_start, em_end - em_start);
+			}
+		}
+
+		free_extent_map(em);
+		em = NULL;
+		search_start = last_byte;
+		if (search_start >= end)
+			break;
+	}
+
+	free_extent_map(em);
+	return ret;
+}
+
 static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 				       u64 start, u64 num_bytes, u64 min_size,
 				       loff_t actual_len, u64 *alloc_hint,
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b3d249d..bb16613 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -856,7 +856,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 		return 0;
 	file_end = (isize - 1) >> PAGE_CACHE_SHIFT;
 
-	ret = btrfs_delalloc_reserve_space(inode,
+	ret = btrfs_delalloc_reserve_space(inode, page_offset(pages[0]),
 					   num_pages << PAGE_CACHE_SHIFT);
 	if (ret)
 		return ret;
-- 
1.7.3.1
