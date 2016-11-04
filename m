Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32612 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933568AbcKDBdx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 21:33:53 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v14 15/15] btrfs: fix false enospc for in-band dedupe
Date: Fri,  4 Nov 2016 09:33:04 +0800
Message-Id: <20161104013304.11365-16-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161104013304.11365-1-quwenruo@cn.fujitsu.com>
References: <20161104013304.11365-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

When testing in-band dedupe, sometimes we got ENOSPC error, but fs still
has much free space. After some debuging work, we found that it's
btrfs_delalloc_reserve_metadata() which sometimes tries to reserve plenty
of metadata space, even for very small data range.

In btrfs_delalloc_reserve_metadata(), the number of metadata bytes we
try to reserve is calculated by the difference between outstanding_extents
and reserved_extents. Please see below case for how ENOSPC occurs:

  1, Buffered write 128MB data in unit of 1MB, so finially we'll have
inode outstanding extents be 1, and reserved_extents be 128.
Note it's btrfs_merge_extent_hook() that merges these 1MB units into
one big outstanding extent, but do not change reserved_extents.

  2, When writing dirty pages, for in-band dedupe, cow_file_range() will
split above big extent in unit of 16KB(assume our in-band dedupe blocksize
is 16KB). When first split opeartion finishes, we'll have 2 outstanding
extents and 128 reserved extents, and just right the currently generated
ordered extent is dispatched to run and complete, then
btrfs_delalloc_release_metadata()(see btrfs_finish_ordered_io()) will be
called to release metadata, after that we will have 1 outstanding extents
and 1 reserved extents(also see logic in drop_outstanding_extent()).
Later cow_file_range() continues to handles left data range[16KB, 128MB), and
if no other ordered extent was dispatched to run, there will be 8191
outstanding extents and 1 reserved extent.

  3, Now if another bufferd write for this file enters, then
btrfs_delalloc_reserve_metadata() will at least try to reserve metadata
for 8191 outstanding extents' metadata, for 64K node size, it'll be
8191*65536*16, about 8GB metadata, this value is insane, it'll return ENOSPC
error easily, especially for small fs.

But indeed when a file goes through in-band dedupe, its max extent size
will no longer be BTRFS_MAX_EXTENT_SIZE(128MB), it'll be limited by
in-band dedupe blocksize, so current metadata reservation method in btrfs
is not appropriate or correct, here we introduce a new metadata reserve
type BTRFS_RESERVE_DEDUPE. Using this flag, metadata reservation will
be calcaulated by in-band dedupe blocksize.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       |  4 +++-
 fs/btrfs/dedupe.h      | 18 ++++++++++++++++++
 fs/btrfs/extent-tree.c | 13 ++++++++-----
 fs/btrfs/extent_io.c   |  7 ++++---
 fs/btrfs/extent_io.h   |  1 +
 fs/btrfs/file.c        |  3 +++
 fs/btrfs/inode.c       | 34 ++++++++++++++++++++++++++++++----
 fs/btrfs/ioctl.c       |  3 +++
 fs/btrfs/relocation.c  |  2 ++
 9 files changed, 72 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0564de6..8805e6a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -107,9 +107,11 @@ static const int btrfs_csum_sizes[] = { 4 };
 enum btrfs_metadata_reserve_type {
 	BTRFS_RESERVE_NORMAL,
 	BTRFS_RESERVE_COMPRESS,
+	BTRFS_RESERVE_DEDUPE,
 };
 int inode_need_compress(struct inode *inode);
-u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type);
+u64 btrfs_max_extent_size(struct inode *inode,
+			  enum btrfs_metadata_reserve_type reserve_type);
 
 #define BTRFS_MAX_EXTENT_SIZE SZ_128M
 
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index b2632ac..67a6759 100644
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
index 0a8f0c4..f68450e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5859,7 +5859,7 @@ static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes,
 	unsigned drop_inode_space = 0;
 	unsigned dropped_extents = 0;
 	unsigned num_extents = 0;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 
 	num_extents = (unsigned)div64_u64(num_bytes + max_extent_size - 1,
 					  max_extent_size);
@@ -5932,12 +5932,15 @@ static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes,
 	return btrfs_calc_trans_metadata_size(root, old_csums - num_csums);
 }
 
-u64 btrfs_max_extent_size(enum btrfs_metadata_reserve_type reserve_type)
+u64 btrfs_max_extent_size(struct inode *inode,
+			  enum btrfs_metadata_reserve_type reserve_type)
 {
 	if (reserve_type == BTRFS_RESERVE_COMPRESS)
 		return SZ_128K;
-
-	return BTRFS_MAX_EXTENT_SIZE;
+	else if (reserve_type == BTRFS_RESERVE_DEDUPE)
+		return btrfs_dedupe_blocksize(inode);
+	else
+		return BTRFS_MAX_EXTENT_SIZE;
 }
 
 /*
@@ -5959,7 +5962,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes,
 	u64 to_free = 0;
 	unsigned dropped;
 	bool release_extra = false;
-	u64 max_extent_size = btrfs_max_extent_size(reserve_type);
+	u64 max_extent_size = btrfs_max_extent_size(inode, reserve_type);
 
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8c07306..11c2525 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -603,7 +603,7 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	if (bits & EXTENT_DELALLOC)
-		bits |= EXTENT_NORESERVE | EXTENT_COMPRESS;
+		bits |= EXTENT_NORESERVE | EXTENT_COMPRESS | EXTENT_DEDUPE;
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
@@ -783,7 +783,7 @@ void adjust_outstanding_extents(struct inode *inode,
 		 * The whole range is locked, so we can safely clear
 		 * EXTENT_COMPRESS flag.
 		 */
-		state->state &= ~EXTENT_COMPRESS;
+		state->state &= ~(EXTENT_COMPRESS | EXTENT_DEDUPE);
 		adjust_one_outstanding_extent(inode,
 				state->end - state->start + 1);
 		node = rb_next(node);
@@ -1575,7 +1575,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
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
index d9f846c..c226d62 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -22,6 +22,7 @@
 #define EXTENT_QGROUP_RESERVED	(1U << 16)
 #define EXTENT_CLEAR_DATA_RESV	(1U << 17)
 #define	EXTENT_COMPRESS		(1U << 18)
+#define EXTENT_DEDUPE		(1U << 19)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f2b07ba..cb7c371 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -42,6 +42,7 @@
 #include "volumes.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "dedupe.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
@@ -1537,6 +1538,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	while (iov_iter_count(i) > 0) {
 		size_t offset = pos & (PAGE_SIZE - 1);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ff35baa..728af50 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1734,20 +1734,23 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
-	int need_compress;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	int need_compress, need_dedupe;
 
 	need_compress = test_range_bit(io_tree, start, end,
 				       EXTENT_COMPRESS, 1, NULL);
+	need_dedupe = test_range_bit(io_tree, start, end,
+				     EXTENT_DEDUPE, 1, NULL);
+
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
-		if (need_compress)
+		if (need_compress || need_dedupe)
 			adjust_outstanding_extents(inode, start, end);
 
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
-		if (need_compress)
+		if (need_compress || need_dedupe)
 			adjust_outstanding_extents(inode, start, end);
 
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
@@ -1779,6 +1782,8 @@ static void btrfs_split_extent_hook(struct inode *inode,
 
 	if (orig->state & EXTENT_COMPRESS)
 		max_extent_size = SZ_128K;
+	else if (orig->state & EXTENT_DEDUPE)
+		max_extent_size = btrfs_dedupe_blocksize(inode);
 
 	size = orig->end - orig->start + 1;
 	if (size > max_extent_size) {
@@ -1828,6 +1833,8 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 
 	if (other->state & EXTENT_COMPRESS)
 		max_extent_size = SZ_128K;
+	else if (other->state & EXTENT_DEDUPE)
+		max_extent_size = btrfs_dedupe_blocksize(inode);
 
 	if (new->start > other->start)
 		new_size = new->end - other->start + 1;
@@ -1940,6 +1947,9 @@ static void btrfs_set_bit_hook(struct inode *inode,
 
 		if (*bits & EXTENT_COMPRESS)
 			max_extent_size = SZ_128K;
+		else if (*bits & EXTENT_DEDUPE)
+			max_extent_size = btrfs_dedupe_blocksize(inode);
+
 		num_extents = div64_u64(len + max_extent_size - 1,
 					max_extent_size);
 
@@ -1998,6 +2008,9 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		if (state->state & EXTENT_COMPRESS) {
 			max_extent_size = SZ_128K;
 			reserve_type = BTRFS_RESERVE_COMPRESS;
+		} else if (state->state & EXTENT_DEDUPE) {
+			max_extent_size = btrfs_dedupe_blocksize(inode);
+			reserve_type = BTRFS_RESERVE_DEDUPE;
 		}
 
 		num_extents = div64_u64(len + max_extent_size - 1,
@@ -2216,6 +2229,8 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 
 	if (flag == 1)
 		max_extent_size = SZ_128K;
+	else if (flag == 2)
+		max_extent_size = btrfs_dedupe_blocksize(inode);
 
 	num_extents = div64_u64(end - start + max_extent_size,
 				    max_extent_size);
@@ -2223,6 +2238,8 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 	/* compression path */
 	if (flag == 1)
 		bits = EXTENT_DELALLOC | EXTENT_COMPRESS | EXTENT_UPTODATE;
+	else if (flag == 2)
+		bits = EXTENT_DELALLOC | EXTENT_DEDUPE | EXTENT_UPTODATE;
 	else
 		bits = EXTENT_DELALLOC | EXTENT_UPTODATE;
 
@@ -2333,6 +2350,9 @@ again:
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
 					   PAGE_SIZE, reserve_type);
 	if (ret) {
@@ -3269,7 +3289,8 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags)) {
 		compress_type = ordered_extent->compress_type;
 		reserve_type = BTRFS_RESERVE_COMPRESS;
-	}
+	} else if (ordered_extent->hash)
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	if (test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
 		BUG_ON(compress_type);
@@ -5038,6 +5059,8 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	if ((offset & (blocksize - 1)) == 0 &&
 	    (!len || ((len & (blocksize - 1)) == 0)))
@@ -9322,6 +9345,9 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	/*
 	 * Reserving delalloc space after obtaining the page lock can lead to
 	 * deadlock. For example, if a dirty page is locked by this function
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3dd093b..2fc17b5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1143,6 +1143,9 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
+
 	ret = btrfs_delalloc_reserve_space(inode,
 			start_index << PAGE_SHIFT,
 			page_cnt << PAGE_SHIFT, reserve_type);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 3cba053..9cf2bbd 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3164,6 +3164,8 @@ static int relocate_file_extent_cluster(struct inode *inode,
 
 	if (inode_need_compress(inode))
 		reserve_type = BTRFS_RESERVE_COMPRESS;
+	else if (inode_need_dedupe(inode))
+		reserve_type = BTRFS_RESERVE_DEDUPE;
 
 	ra = kzalloc(sizeof(*ra), GFP_NOFS);
 	if (!ra)
-- 
2.10.1



