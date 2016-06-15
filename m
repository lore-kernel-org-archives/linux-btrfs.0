Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62598 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932706AbcFODSM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 23:18:12 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH v11.1 13/13] btrfs: dedupe: fix false ENOSPC
Date: Wed, 15 Jun 2016 11:17:55 +0800
Message-Id: <20160615031755.17494-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <20160615021001.9588-14-quwenruo@cn.fujitsu.com>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

When testing in-band dedupe, sometimes we got ENOSPC error, though fs
still has much free space. After some debuging work, we found that it's
btrfs_delalloc_reserve_metadata() which sometimes tries to reserve
plenty of metadata space, even for very small data range.

In btrfs_delalloc_reserve_metadata(), the number of metadata bytes we try
to reserve is calculated by the difference between outstanding_extents and
reserved_extents. Please see below case for how ENOSPC occurs:

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
and 1 reserved extents(also see logic in drop_outstanding_extent()). Later
cow_file_range() continues to handles left data range[16KB, 128MB), and if
no other ordered extent was dispatched to run, there will be 8191
outstanding extents and 1 reserved extent.

  3, Now if another bufferd write for this file enters, then
btrfs_delalloc_reserve_metadata() will at least try to reserve metadata
for 8191 outstanding extents' metadata, for 64K node size, it'll be
8191*65536*16, about 8GB metadata, so obviously it'll return ENOSPC error.

But indeed when a file goes through in-band dedupe, its max extent size
will no longer be BTRFS_MAX_EXTENT_SIZE(128MB), it'll be limited by in-band
dedupe blocksize, so current metadata reservation method in btrfs is not
appropriate or correct, here we introduce btrfs_max_extent_size(), which
will return max extent size for corresponding files, which go through in-band
and we use this value to do metadata reservation and extent_io merge, split,
clear operations, we can make sure difference between outstanding_extents
and reserved_extents will not be so big.

Currently only buffered write will go through in-band dedupe if in-band
dedupe is enabled.

Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
v11.1
  Fix compile error on self test.
---
 fs/btrfs/ctree.h                 |  16 ++--
 fs/btrfs/dedupe.h                |  37 ++++++++++
 fs/btrfs/extent-tree.c           |  62 ++++++++++++----
 fs/btrfs/extent_io.c             |  63 +++++++++++++++-
 fs/btrfs/extent_io.h             |  15 +++-
 fs/btrfs/file.c                  |  26 +++++--
 fs/btrfs/free-space-cache.c      |   5 +-
 fs/btrfs/inode-map.c             |   4 +-
 fs/btrfs/inode.c                 | 155 +++++++++++++++++++++++----------------
 fs/btrfs/ioctl.c                 |   6 +-
 fs/btrfs/ordered-data.h          |   1 +
 fs/btrfs/relocation.c            |   8 +-
 fs/btrfs/tests/extent-io-tests.c |   6 +-
 fs/btrfs/tests/inode-tests.c     |  12 +--
 14 files changed, 299 insertions(+), 117 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 62037e9..21f2689 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2649,10 +2649,14 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 				      struct btrfs_block_rsv *rsv,
 				      u64 qgroup_reserved);
-int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes);
-void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes);
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len);
-void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len);
+int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes,
+				    u32 max_extent_size);
+void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes,
+				     u32 max_extent_size);
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len,
+				 u32 max_extent_size);
+void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len,
+				  u32 max_extent_size);
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
 					      unsigned short type);
@@ -3093,7 +3097,7 @@ int btrfs_start_delalloc_inodes(struct btrfs_root *root, int delay_iput);
 int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, int delay_iput,
 			       int nr);
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
-			      struct extent_state **cached_state);
+			      struct extent_state **cached_state, int dedupe);
 int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
 			    struct extent_state **cached_state);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
@@ -3188,7 +3192,7 @@ int btrfs_release_file(struct inode *inode, struct file *file);
 int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 		      struct page **pages, size_t num_pages,
 		      loff_t pos, size_t write_bytes,
-		      struct extent_state **cached);
+		      struct extent_state **cached, int dedupe);
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end);
 ssize_t btrfs_copy_file_range(struct file *file_in, loff_t pos_in,
 			      struct file *file_out, loff_t pos_out,
diff --git a/fs/btrfs/dedupe.h b/fs/btrfs/dedupe.h
index f605a7f..fd6096c 100644
--- a/fs/btrfs/dedupe.h
+++ b/fs/btrfs/dedupe.h
@@ -22,6 +22,7 @@
 #include <linux/btrfs.h>
 #include <linux/wait.h>
 #include <crypto/hash.h>
+#include "btrfs_inode.h"
 
 static int btrfs_dedupe_sizes[] = { 32 };
 
@@ -63,6 +64,42 @@ struct btrfs_dedupe_info {
 
 struct btrfs_trans_handle;
 
+static inline u64 btrfs_dedupe_blocksize(struct inode *inode)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+
+	BUG_ON(fs_info->dedupe_info == NULL);
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
+/*
+ * For in-band dedupe, its max extent size will be limited by in-band
+ * dedupe blocksize.
+ */
+static inline u64 btrfs_max_extent_size(struct inode *inode, int do_dedupe)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_dedupe_info *dedupe_info = fs_info->dedupe_info;
+
+	if (do_dedupe) {
+		BUG_ON(dedupe_info == NULL);
+		return dedupe_info->blocksize;
+	} else {
+		return BTRFS_MAX_EXTENT_SIZE;
+	}
+}
+
+
 static inline int btrfs_dedupe_hash_hit(struct btrfs_dedupe_hash *hash)
 {
 	return (hash && hash->bytenr);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f6213e7..6146729 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5642,22 +5642,29 @@ void btrfs_subvolume_release_metadata(struct btrfs_root *root,
 /**
  * drop_outstanding_extent - drop an outstanding extent
  * @inode: the inode we're dropping the extent for
- * @num_bytes: the number of bytes we're releasing.
+ * @num_bytes: the number of bytes we're relaseing.
+ * @max_extent_size: for in-band dedupe, max_extent_size will be set to in-band
+ * dedupe blocksize, othersize max_extent_size should be BTRFS_MAX_EXTENT_SIZE.
+ * Also if max_extent_size is 0, it'll be set to BTRFS_MAX_EXTENT_SIZE.
  *
  * This is called when we are freeing up an outstanding extent, either called
  * after an error or after an extent is written.  This will return the number of
  * reserved extents that need to be freed.  This must be called with
  * BTRFS_I(inode)->lock held.
  */
-static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes)
+static unsigned drop_outstanding_extent(struct inode *inode, u64 num_bytes,
+					u32 max_extent_size)
 {
 	unsigned drop_inode_space = 0;
 	unsigned dropped_extents = 0;
 	unsigned num_extents = 0;
 
+	if (max_extent_size == 0)
+		max_extent_size = BTRFS_MAX_EXTENT_SIZE;
+
 	num_extents = (unsigned)div64_u64(num_bytes +
-					  BTRFS_MAX_EXTENT_SIZE - 1,
-					  BTRFS_MAX_EXTENT_SIZE);
+					  max_extent_size - 1,
+					  max_extent_size);
 	ASSERT(num_extents);
 	ASSERT(BTRFS_I(inode)->outstanding_extents >= num_extents);
 	BTRFS_I(inode)->outstanding_extents -= num_extents;
@@ -5727,7 +5734,13 @@ static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes,
 	return btrfs_calc_trans_metadata_size(root, old_csums - num_csums);
 }
 
-int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
+/*
+ * @max_extent_size: for in-band dedupe, max_extent_size will be set to in-band
+ * dedupe blocksize, othersize max_extent_size should be BTRFS_MAX_EXTENT_SIZE.
+ * Also if max_extent_size is 0, it'll be set to BTRFS_MAX_EXTENT_SIZE.
+ */
+int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes,
+				    u32 max_extent_size)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *block_rsv = &root->fs_info->delalloc_block_rsv;
@@ -5741,6 +5754,9 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	u64 to_free = 0;
 	unsigned dropped;
 
+	if (max_extent_size == 0)
+		max_extent_size = BTRFS_MAX_EXTENT_SIZE;
+
 	/* If we are a free space inode we need to not flush since we will be in
 	 * the middle of a transaction commit.  We also don't need the delalloc
 	 * mutex since we won't race with anybody.  We need this mostly to make
@@ -5762,8 +5778,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	nr_extents = (unsigned)div64_u64(num_bytes +
-					 BTRFS_MAX_EXTENT_SIZE - 1,
-					 BTRFS_MAX_EXTENT_SIZE);
+					 max_extent_size - 1,
+					 max_extent_size);
 	BTRFS_I(inode)->outstanding_extents += nr_extents;
 	nr_extents = 0;
 
@@ -5821,7 +5837,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 out_fail:
 	spin_lock(&BTRFS_I(inode)->lock);
-	dropped = drop_outstanding_extent(inode, num_bytes);
+	dropped = drop_outstanding_extent(inode, num_bytes, max_extent_size);
 	/*
 	 * If the inodes csum_bytes is the same as the original
 	 * csum_bytes then we know we haven't raced with any free()ers
@@ -5887,20 +5903,27 @@ out_fail:
  * btrfs_delalloc_release_metadata - release a metadata reservation for an inode
  * @inode: the inode to release the reservation for
  * @num_bytes: the number of bytes we're releasing
+ * @max_extent_size: for in-band dedupe, max_extent_size will be set to in-band
+ * dedupe blocksize, othersize max_extent_size should be BTRFS_MAX_EXTENT_SIZE.
+ * Also if max_extent_size is 0, it'll be set to BTRFS_MAX_EXTENT_SIZE.
  *
  * This will release the metadata reservation for an inode.  This can be called
  * once we complete IO for a given set of bytes to release their metadata
  * reservations.
  */
-void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
+void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes,
+				     u32 max_extent_size)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 to_free = 0;
 	unsigned dropped;
 
+	if (max_extent_size == 0)
+		max_extent_size = BTRFS_MAX_EXTENT_SIZE;
+
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
 	spin_lock(&BTRFS_I(inode)->lock);
-	dropped = drop_outstanding_extent(inode, num_bytes);
+	dropped = drop_outstanding_extent(inode, num_bytes, max_extent_size);
 
 	if (num_bytes)
 		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
@@ -5924,6 +5947,9 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
  * @inode: inode we're writing to
  * @start: start range we are writing to
  * @len: how long the range we are writing to
+ * @max_extent_size: for in-band dedupe, max_extent_size will be set to in-band
+ * dedupe blocksize, othersize max_extent_size should be BTRFS_MAX_EXTENT_SIZE.
+ * Also if max_extent_size is 0, it'll be set to BTRFS_MAX_EXTENT_SIZE.
  *
  * TODO: This function will finally replace old btrfs_delalloc_reserve_space()
  *
@@ -5943,14 +5969,18 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
  * Return 0 for success
  * Return <0 for error(-ENOSPC or -EQUOT)
  */
-int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
+int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len,
+				 u32 max_extent_size)
 {
 	int ret;
 
+	if (max_extent_size == 0)
+		max_extent_size = BTRFS_MAX_EXTENT_SIZE;
+
 	ret = btrfs_check_data_free_space(inode, start, len);
 	if (ret < 0)
 		return ret;
-	ret = btrfs_delalloc_reserve_metadata(inode, len);
+	ret = btrfs_delalloc_reserve_metadata(inode, len, max_extent_size);
 	if (ret < 0)
 		btrfs_free_reserved_data_space(inode, start, len);
 	return ret;
@@ -5961,6 +5991,9 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
  * @inode: inode we're releasing space for
  * @start: start position of the space already reserved
  * @len: the len of the space already reserved
+ * @max_extent_size: for in-band dedupe, max_extent_size will be set to in-band
+ * dedupe blocksize, othersize max_extent_size should be BTRFS_MAX_EXTENT_SIZE.
+ * Also if max_extent_size is 0, it'll be set to BTRFS_MAX_EXTENT_SIZE.
  *
  * This must be matched with a call to btrfs_delalloc_reserve_space.  This is
  * called in the case that we don't need the metadata AND data reservations
@@ -5971,9 +6004,10 @@ int btrfs_delalloc_reserve_space(struct inode *inode, u64 start, u64 len)
  * list if there are no delalloc bytes left.
  * Also it will handle the qgroup reserved space.
  */
-void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len)
+void btrfs_delalloc_release_space(struct inode *inode, u64 start, u64 len,
+				  u32 max_extent_size)
 {
-	btrfs_delalloc_release_metadata(inode, len);
+	btrfs_delalloc_release_metadata(inode, len, max_extent_size);
 	btrfs_free_reserved_data_space(inode, start, len);
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a3412d6..4e3bac2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -20,6 +20,7 @@
 #include "locking.h"
 #include "rcu-string.h"
 #include "backref.h"
+#include "dedupe.h"
 
 static struct kmem_cache *extent_state_cache;
 static struct kmem_cache *extent_buffer_cache;
@@ -605,7 +606,7 @@ static int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	btrfs_debug_check_extent_io_range(tree, start, end);
 
 	if (bits & EXTENT_DELALLOC)
-		bits |= EXTENT_NORESERVE;
+		bits |= EXTENT_NORESERVE | EXTENT_DEDUPE;
 
 	if (delete)
 		bits |= ~EXTENT_CTLBITS;
@@ -1491,6 +1492,61 @@ out:
 	return ret;
 }
 
+static void adjust_one_outstanding_extent(struct inode *inode, u64 len)
+{
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	u64 dedupe_blocksize = fs_info->dedupe_info->blocksize;
+	unsigned old_extents, new_extents;
+
+	old_extents = div64_u64(len + dedupe_blocksize - 1, dedupe_blocksize);
+	new_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
+				BTRFS_MAX_EXTENT_SIZE);
+	if (old_extents <= new_extents)
+		return;
+
+	spin_lock(&BTRFS_I(inode)->lock);
+	BTRFS_I(inode)->outstanding_extents -= old_extents - new_extents;
+	spin_unlock(&BTRFS_I(inode)->lock);
+}
+
+/*
+ * For a extent with EXTENT_DEDUPE flag, if later it does not go through
+ * in-band dedupe, we need to adjust the number of outstanding_extents.
+ * It's because for extent with EXTENT_DEDUPE flag, its number of outstanding
+ * extents is calculated by in-band dedupe blocksize, so here we need to
+ * adjust it.
+ */
+void adjust_buffered_io_outstanding_extents(struct extent_io_tree *tree,
+					    u64 start, u64 end)
+{
+	struct inode *inode = tree->mapping->host;
+	struct rb_node *node;
+	struct extent_state *state;
+
+	spin_lock(&tree->lock);
+	node = tree_search(tree, start);
+	if (!node)
+		goto out;
+
+	while (1) {
+		state = rb_entry(node, struct extent_state, rb_node);
+		if (state->start > end)
+			goto out;
+		/*
+		 * The whole range is locked, so we can safely clear
+		 * EXTENT_DEDUPE flag.
+		 */
+		state->state &= ~EXTENT_DEDUPE;
+		adjust_one_outstanding_extent(inode,
+				state->end - state->start + 1);
+		node = rb_next(node);
+		if (!node)
+			break;
+	}
+out:
+	spin_unlock(&tree->lock);
+}
+
 /*
  * find a contiguous range of bytes in the file marked as delalloc, not
  * more than 'max_bytes'.  start and end are used to return the range,
@@ -1506,6 +1562,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	u64 cur_start = *start;
 	u64 found = 0;
 	u64 total_bytes = 0;
+	unsigned pre_state;
 
 	spin_lock(&tree->lock);
 
@@ -1523,7 +1580,8 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 	while (1) {
 		state = rb_entry(node, struct extent_state, rb_node);
 		if (found && (state->start != cur_start ||
-			      (state->state & EXTENT_BOUNDARY))) {
+		    (state->state & EXTENT_BOUNDARY) ||
+		    (state->state ^ pre_state) & EXTENT_DEDUPE)) {
 			goto out;
 		}
 		if (!(state->state & EXTENT_DELALLOC)) {
@@ -1539,6 +1597,7 @@ static noinline u64 find_delalloc_range(struct extent_io_tree *tree,
 		found++;
 		*end = state->end;
 		cur_start = state->end + 1;
+		pre_state = state->state;
 		node = rb_next(node);
 		total_bytes += state->end - state->start + 1;
 		if (total_bytes >= max_bytes)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index c0c1c4f..7ba66b0 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -20,6 +20,7 @@
 #define EXTENT_DAMAGED		(1U << 14)
 #define EXTENT_NORESERVE	(1U << 15)
 #define EXTENT_QGROUP_RESERVED	(1U << 16)
+#define EXTENT_DEDUPE		(1U << 17)
 #define EXTENT_IOBITS		(EXTENT_LOCKED | EXTENT_WRITEBACK)
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING | EXTENT_FIRST_DELALLOC)
 
@@ -250,6 +251,8 @@ static inline int clear_extent_bits(struct extent_io_tree *tree, u64 start,
 			GFP_NOFS);
 }
 
+void adjust_buffered_io_outstanding_extents(struct extent_io_tree *tree,
+					    u64 start, u64 end);
 int set_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 			   unsigned bits, struct extent_changeset *changeset);
 int set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
@@ -289,10 +292,16 @@ int convert_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		       struct extent_state **cached_state);
 
 static inline int set_extent_delalloc(struct extent_io_tree *tree, u64 start,
-		u64 end, struct extent_state **cached_state)
+		u64 end, struct extent_state **cached_state, int dedupe)
 {
-	return set_extent_bit(tree, start, end,
-			      EXTENT_DELALLOC | EXTENT_UPTODATE,
+	unsigned bits;
+
+	if (dedupe)
+		bits = EXTENT_DELALLOC | EXTENT_UPTODATE | EXTENT_DEDUPE;
+	else
+		bits = EXTENT_DELALLOC | EXTENT_UPTODATE;
+
+	return set_extent_bit(tree, start, end, bits,
 			      NULL, cached_state, GFP_NOFS);
 }
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 159a934..e3e00e7 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -42,6 +42,7 @@
 #include "volumes.h"
 #include "qgroup.h"
 #include "compression.h"
+#include "dedupe.h"
 
 static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
@@ -488,7 +489,7 @@ static void btrfs_drop_pages(struct page **pages, size_t num_pages)
 int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 			     struct page **pages, size_t num_pages,
 			     loff_t pos, size_t write_bytes,
-			     struct extent_state **cached)
+			     struct extent_state **cached, int dedupe)
 {
 	int err = 0;
 	int i;
@@ -502,8 +503,9 @@ int btrfs_dirty_pages(struct btrfs_root *root, struct inode *inode,
 	num_bytes = round_up(write_bytes + pos - start_pos, root->sectorsize);
 
 	end_of_last_block = start_pos + num_bytes - 1;
+
 	err = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
-					cached);
+					cached, dedupe);
 	if (err)
 		return err;
 
@@ -1496,6 +1498,11 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	bool only_release_metadata = false;
 	bool force_page_uptodate = false;
 	bool need_unlock;
+	u32 max_extent_size = BTRFS_MAX_EXTENT_SIZE;
+	int dedupe = inode_need_dedupe(inode);
+
+	if (dedupe)
+		max_extent_size = btrfs_dedupe_blocksize(inode);
 
 	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE),
 			PAGE_SIZE / (sizeof(struct page *)));
@@ -1558,7 +1565,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 			break;
 
 reserve_metadata:
-		ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes);
+		ret = btrfs_delalloc_reserve_metadata(inode, reserve_bytes,
+						      max_extent_size);
 		if (ret) {
 			if (!only_release_metadata)
 				btrfs_free_reserved_data_space(inode, pos,
@@ -1643,14 +1651,15 @@ again:
 			}
 			if (only_release_metadata) {
 				btrfs_delalloc_release_metadata(inode,
-								release_bytes);
+					release_bytes, max_extent_size);
 			} else {
 				u64 __pos;
 
 				__pos = round_down(pos, root->sectorsize) +
 					(dirty_pages << PAGE_SHIFT);
 				btrfs_delalloc_release_space(inode, __pos,
-							     release_bytes);
+							     release_bytes,
+							     max_extent_size);
 			}
 		}
 
@@ -1660,7 +1669,7 @@ again:
 		if (copied > 0)
 			ret = btrfs_dirty_pages(root, inode, pages,
 						dirty_pages, pos, copied,
-						NULL);
+						NULL, dedupe);
 		if (need_unlock)
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     lockstart, lockend, &cached_state,
@@ -1701,11 +1710,12 @@ again:
 	if (release_bytes) {
 		if (only_release_metadata) {
 			btrfs_end_write_no_snapshoting(root);
-			btrfs_delalloc_release_metadata(inode, release_bytes);
+			btrfs_delalloc_release_metadata(inode, release_bytes,
+							max_extent_size);
 		} else {
 			btrfs_delalloc_release_space(inode,
 						round_down(pos, root->sectorsize),
-						release_bytes);
+						release_bytes, max_extent_size);
 		}
 	}
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 69d270f..dd7e6af 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1296,7 +1296,7 @@ static int __btrfs_write_out_cache(struct btrfs_root *root, struct inode *inode,
 
 	/* Everything is written out, now we dirty the pages in the file. */
 	ret = btrfs_dirty_pages(root, inode, io_ctl->pages, io_ctl->num_pages,
-				0, i_size_read(inode), &cached_state);
+				0, i_size_read(inode), &cached_state, 0);
 	if (ret)
 		goto out_nospc;
 
@@ -3533,7 +3533,8 @@ int btrfs_write_out_ino_cache(struct btrfs_root *root,
 
 	if (ret) {
 		if (release_metadata)
-			btrfs_delalloc_release_metadata(inode, inode->i_size);
+			btrfs_delalloc_release_metadata(inode, inode->i_size,
+							0);
 #ifdef DEBUG
 		btrfs_err(root->fs_info,
 			"failed to write free ino cache for root %llu",
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 70107f7..99c1f8e 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -488,14 +488,14 @@ again:
 	/* Just to make sure we have enough space */
 	prealloc += 8 * PAGE_SIZE;
 
-	ret = btrfs_delalloc_reserve_space(inode, 0, prealloc);
+	ret = btrfs_delalloc_reserve_space(inode, 0, prealloc, 0);
 	if (ret)
 		goto out_put;
 
 	ret = btrfs_prealloc_file_range_trans(inode, trans, 0, 0, prealloc,
 					      prealloc, prealloc, &alloc_hint);
 	if (ret) {
-		btrfs_delalloc_release_space(inode, 0, prealloc);
+		btrfs_delalloc_release_space(inode, 0, prealloc, 0);
 		goto out_put;
 	}
 	btrfs_free_reserved_data_space(inode, 0, prealloc);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4a02383..918d5e0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -315,7 +315,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	}
 
 	set_bit(BTRFS_INODE_NEEDS_FULL_SYNC, &BTRFS_I(inode)->runtime_flags);
-	btrfs_delalloc_release_metadata(inode, end + 1 - start);
+	btrfs_delalloc_release_metadata(inode, end + 1 - start, 0);
 	btrfs_drop_extent_cache(inode, start, aligned_end - 1, 0);
 out:
 	/*
@@ -347,6 +347,7 @@ struct async_cow {
 	struct page *locked_page;
 	u64 start;
 	u64 end;
+	int dedupe;
 	struct list_head extents;
 	struct btrfs_work work;
 };
@@ -1163,14 +1164,8 @@ static int hash_file_ranges(struct inode *inode, u64 start, u64 end,
 
 	actual_end = min_t(u64, isize, end + 1);
 	/* If dedupe is not enabled, don't split extent into dedupe_bs */
-	if (fs_info->dedupe_enabled && dedupe_info) {
-		dedupe_bs = dedupe_info->blocksize;
-		hash_algo = dedupe_info->hash_type;
-	} else {
-		dedupe_bs = SZ_128M;
-		/* Just dummy, to avoid access NULL pointer */
-		hash_algo = BTRFS_DEDUPE_HASH_SHA256;
-	}
+	dedupe_bs = dedupe_info->blocksize;
+	hash_algo = dedupe_info->hash_type;
 
 	while (cur_offset < end) {
 		struct btrfs_dedupe_hash *hash = NULL;
@@ -1223,13 +1218,13 @@ static noinline void async_cow_start(struct btrfs_work *work)
 	int ret = 0;
 	async_cow = container_of(work, struct async_cow, work);
 
-	if (inode_need_compress(async_cow->inode))
+	if (async_cow->dedupe)
+		ret = hash_file_ranges(async_cow->inode, async_cow->start,
+				       async_cow->end, async_cow, &num_added);
+	else
 		compress_file_range(async_cow->inode, async_cow->locked_page,
 				    async_cow->start, async_cow->end, async_cow,
 				    &num_added);
-	else
-		ret = hash_file_ranges(async_cow->inode, async_cow->start,
-				       async_cow->end, async_cow, &num_added);
 	WARN_ON(ret);
 
 	if (num_added == 0) {
@@ -1276,7 +1271,7 @@ static noinline void async_cow_free(struct btrfs_work *work)
 
 static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 				u64 start, u64 end, int *page_started,
-				unsigned long *nr_written)
+				unsigned long *nr_written, int dedupe)
 {
 	struct async_cow *async_cow;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1295,10 +1290,10 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
+		async_cow->dedupe = dedupe;
 
-		if (fs_info->dedupe_enabled && dedupe_info) {
+		if (dedupe) {
 			u64 len = max_t(u64, SZ_512K, dedupe_info->blocksize);
-
 			cur_end = min(end, start + len - 1);
 		} else if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
 		    !btrfs_test_opt(root, FORCE_COMPRESS))
@@ -1696,25 +1691,35 @@ static int run_delalloc_range(struct inode *inode, struct page *locked_page,
 			      u64 start, u64 end, int *page_started,
 			      unsigned long *nr_written)
 {
-	int ret;
+	int ret, dedupe;
 	int force_cow = need_force_cow(inode, start, end);
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_dedupe_info *dedupe_info = root->fs_info->dedupe_info;
+
+	dedupe = test_range_bit(io_tree, start, end, EXTENT_DEDUPE, 1, NULL);
+	BUG_ON(dedupe && dedupe_info == NULL);
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
+		if (dedupe)
+			adjust_buffered_io_outstanding_extents(io_tree,
+							       start, end);
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 1, nr_written);
 	} else if (BTRFS_I(inode)->flags & BTRFS_INODE_PREALLOC && !force_cow) {
+		if (dedupe)
+			adjust_buffered_io_outstanding_extents(io_tree,
+							       start, end);
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
 					 page_started, 0, nr_written);
-	} else if (!inode_need_compress(inode) && !fs_info->dedupe_enabled) {
+	} else if (!inode_need_compress(inode) && !dedupe) {
 		ret = cow_file_range(inode, locked_page, start, end,
 				      page_started, nr_written, 1, NULL);
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
 			&BTRFS_I(inode)->runtime_flags);
 		ret = cow_file_range_async(inode, locked_page, start, end,
-					   page_started, nr_written);
+					   page_started, nr_written, dedupe);
 	}
 	return ret;
 }
@@ -1724,6 +1729,8 @@ static void btrfs_split_extent_hook(struct inode *inode,
 {
 	u64 size;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int do_dedupe = orig->state & EXTENT_DEDUPE;
+	u64 max_extent_size = btrfs_max_extent_size(inode, do_dedupe);
 
 	/* not delalloc, ignore it */
 	if (!(orig->state & EXTENT_DELALLOC))
@@ -1733,7 +1740,7 @@ static void btrfs_split_extent_hook(struct inode *inode,
 		return;
 
 	size = orig->end - orig->start + 1;
-	if (size > BTRFS_MAX_EXTENT_SIZE) {
+	if (size > max_extent_size) {
 		u64 num_extents;
 		u64 new_size;
 
@@ -1742,13 +1749,13 @@ static void btrfs_split_extent_hook(struct inode *inode,
 		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
-		num_extents = div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-					BTRFS_MAX_EXTENT_SIZE);
+		num_extents = div64_u64(new_size + max_extent_size - 1,
+					max_extent_size);
 		new_size = split - orig->start;
-		num_extents += div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-					BTRFS_MAX_EXTENT_SIZE);
-		if (div64_u64(size + BTRFS_MAX_EXTENT_SIZE - 1,
-			      BTRFS_MAX_EXTENT_SIZE) >= num_extents)
+		num_extents += div64_u64(new_size + max_extent_size - 1,
+					 max_extent_size);
+		if (div64_u64(size + max_extent_size - 1,
+			      max_extent_size) >= num_extents)
 			return;
 	}
 
@@ -1770,6 +1777,8 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	u64 new_size, old_size;
 	u64 num_extents;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int do_dedupe = other->state & EXTENT_DEDUPE;
+	u64 max_extent_size = btrfs_max_extent_size(inode, do_dedupe);
 
 	/* not delalloc, ignore it */
 	if (!(other->state & EXTENT_DELALLOC))
@@ -1784,7 +1793,7 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 		new_size = other->end - new->start + 1;
 
 	/* we're not bigger than the max, unreserve the space and go */
-	if (new_size <= BTRFS_MAX_EXTENT_SIZE) {
+	if (new_size <= max_extent_size) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->outstanding_extents--;
 		spin_unlock(&BTRFS_I(inode)->lock);
@@ -1796,7 +1805,6 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	 * accounted for before we merged into one big extent.  If the number of
 	 * extents we accounted for is <= the amount we need for the new range
 	 * then we can return, otherwise drop.  Think of it like this
-	 *
 	 * [ 4k][MAX_SIZE]
 	 *
 	 * So we've grown the extent by a MAX_SIZE extent, this would mean we
@@ -1810,14 +1818,14 @@ static void btrfs_merge_extent_hook(struct inode *inode,
 	 * this case.
 	 */
 	old_size = other->end - other->start + 1;
-	num_extents = div64_u64(old_size + BTRFS_MAX_EXTENT_SIZE - 1,
-				BTRFS_MAX_EXTENT_SIZE);
+	num_extents = div64_u64(old_size + max_extent_size - 1,
+				max_extent_size);
 	old_size = new->end - new->start + 1;
-	num_extents += div64_u64(old_size + BTRFS_MAX_EXTENT_SIZE - 1,
-				 BTRFS_MAX_EXTENT_SIZE);
+	num_extents += div64_u64(old_size + max_extent_size - 1,
+				 max_extent_size);
 
-	if (div64_u64(new_size + BTRFS_MAX_EXTENT_SIZE - 1,
-		      BTRFS_MAX_EXTENT_SIZE) >= num_extents)
+	if (div64_u64(new_size + max_extent_size - 1,
+		      max_extent_size) >= num_extents)
 		return;
 
 	spin_lock(&BTRFS_I(inode)->lock);
@@ -1883,9 +1891,11 @@ static void btrfs_set_bit_hook(struct inode *inode,
 	 */
 	if (!(state->state & EXTENT_DELALLOC) && (*bits & EXTENT_DELALLOC)) {
 		struct btrfs_root *root = BTRFS_I(inode)->root;
+		int do_dedupe = *bits & EXTENT_DEDUPE;
+		u64 max_extent_size = btrfs_max_extent_size(inode, do_dedupe);
 		u64 len = state->end + 1 - state->start;
-		u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
-					    BTRFS_MAX_EXTENT_SIZE);
+		u64 num_extents = div64_u64(len + max_extent_size - 1,
+					    max_extent_size);
 		bool do_list = !btrfs_is_free_space_inode(inode);
 
 		if (*bits & EXTENT_FIRST_DELALLOC)
@@ -1922,8 +1932,10 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 				 unsigned *bits)
 {
 	u64 len = state->end + 1 - state->start;
-	u64 num_extents = div64_u64(len + BTRFS_MAX_EXTENT_SIZE -1,
-				    BTRFS_MAX_EXTENT_SIZE);
+	int do_dedupe = state->state & EXTENT_DEDUPE;
+	u64 max_extent_size = btrfs_max_extent_size(inode, do_dedupe);
+	u64 num_extents = div64_u64(len + max_extent_size - 1,
+				    max_extent_size);
 
 	spin_lock(&BTRFS_I(inode)->lock);
 	if ((state->state & EXTENT_DEFRAG) && (*bits & EXTENT_DEFRAG))
@@ -1954,7 +1966,8 @@ static void btrfs_clear_bit_hook(struct inode *inode,
 		 */
 		if (*bits & EXTENT_DO_ACCOUNTING &&
 		    root != root->fs_info->tree_root)
-			btrfs_delalloc_release_metadata(inode, len);
+			btrfs_delalloc_release_metadata(inode, len,
+							max_extent_size);
 
 		/* For sanity tests. */
 		if (btrfs_test_is_dummy_root(root))
@@ -2132,16 +2145,18 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
-			      struct extent_state **cached_state)
+			      struct extent_state **cached_state,
+			      int dedupe)
 {
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
-				    BTRFS_MAX_EXTENT_SIZE);
+	u64 max_extent_size = btrfs_max_extent_size(inode, dedupe);
+	u64 num_extents = div64_u64(end - start + max_extent_size,
+				    max_extent_size);
 
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
 	ret = set_extent_delalloc(&BTRFS_I(inode)->io_tree, start, end,
-				  cached_state);
+				  cached_state, dedupe);
 
 	/*
 	 * btrfs_delalloc_reserve_metadata() will first add number of
@@ -2168,13 +2183,15 @@ int btrfs_set_extent_defrag(struct inode *inode, u64 start, u64 end,
 {
 	int ret;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 num_extents = div64_u64(end - start + BTRFS_MAX_EXTENT_SIZE,
-				    BTRFS_MAX_EXTENT_SIZE);
+	u64 max_extent_size = btrfs_max_extent_size(inode, 0);
+	u64 num_extents = div64_u64(end - start + max_extent_size,
+				    max_extent_size);
 
 	WARN_ON((end & (PAGE_SIZE - 1)) == 0);
 	ret = set_extent_defrag(&BTRFS_I(inode)->io_tree, start, end,
 				cached_state);
 
+	/* see same comments in btrfs_set_extent_delalloc */
 	if (ret == 0 && root != root->fs_info->tree_root) {
 		spin_lock(&BTRFS_I(inode)->lock);
 		BTRFS_I(inode)->outstanding_extents -= num_extents;
@@ -2233,7 +2250,7 @@ again:
 	}
 
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
-					   PAGE_SIZE);
+					   PAGE_SIZE, 0);
 	if (ret) {
 		mapping_set_error(page->mapping, ret);
 		end_extent_writepage(page, ret, page_start, page_end);
@@ -2241,7 +2258,8 @@ again:
 		goto out;
 	 }
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
+	btrfs_set_extent_delalloc(inode, page_start, page_end,
+				  &cached_state, 0);
 	ClearPageChecked(page);
 	set_page_dirty(page);
 out:
@@ -3086,6 +3104,10 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 	bool nolock;
 	bool truncated = false;
 	int hash_hit = btrfs_dedupe_hash_hit(ordered_extent->hash);
+	u32 max_extent_size = BTRFS_MAX_EXTENT_SIZE;
+
+	if (ordered_extent->hash)
+		max_extent_size = root->fs_info->dedupe_info->blocksize;
 
 	nolock = btrfs_is_free_space_inode(inode);
 
@@ -3211,7 +3233,9 @@ out_unlock:
 			     ordered_extent->len - 1, &cached_state, GFP_NOFS);
 out:
 	if (root != root->fs_info->tree_root)
-		btrfs_delalloc_release_metadata(inode, ordered_extent->len);
+		btrfs_delalloc_release_metadata(inode, ordered_extent->len,
+						max_extent_size);
+
 	if (trans)
 		btrfs_end_transaction(trans, root);
 
@@ -4903,7 +4927,7 @@ int btrfs_truncate_block(struct inode *inode, loff_t from, loff_t len,
 		goto out;
 
 	ret = btrfs_delalloc_reserve_space(inode,
-			round_down(from, blocksize), blocksize);
+			round_down(from, blocksize), blocksize, 0);
 	if (ret)
 		goto out;
 
@@ -4912,7 +4936,7 @@ again:
 	if (!page) {
 		btrfs_delalloc_release_space(inode,
 				round_down(from, blocksize),
-				blocksize);
+				blocksize, 0);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -4955,7 +4979,7 @@ again:
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, block_start, block_end,
-					&cached_state);
+					&cached_state, 0);
 	if (ret) {
 		unlock_extent_cached(io_tree, block_start, block_end,
 				     &cached_state, GFP_NOFS);
@@ -4983,7 +5007,7 @@ again:
 out_unlock:
 	if (ret)
 		btrfs_delalloc_release_space(inode, block_start,
-					     blocksize);
+					     blocksize, 0);
 	unlock_page(page);
 	put_page(page);
 out:
@@ -7806,9 +7830,10 @@ static void adjust_dio_outstanding_extents(struct inode *inode,
 					   const u64 len)
 {
 	unsigned num_extents;
+	u64 max_extent_size = btrfs_max_extent_size(inode, 0);
 
-	num_extents = (unsigned) div64_u64(len + BTRFS_MAX_EXTENT_SIZE - 1,
-					   BTRFS_MAX_EXTENT_SIZE);
+	num_extents = (unsigned) div64_u64(len + max_extent_size - 1,
+					   max_extent_size);
 	/*
 	 * If we have an outstanding_extents count still set then we're
 	 * within our reservation, otherwise we need to adjust our inode
@@ -8827,6 +8852,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	bool wakeup = true;
 	bool relock = false;
 	ssize_t ret;
+	u64 max_extent_size = btrfs_max_extent_size(inode, 0);
 
 	if (check_direct_IO(BTRFS_I(inode)->root, iocb, iter, offset))
 		return 0;
@@ -8856,12 +8882,12 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			inode_unlock(inode);
 			relock = true;
 		}
-		ret = btrfs_delalloc_reserve_space(inode, offset, count);
+		ret = btrfs_delalloc_reserve_space(inode, offset, count, 0);
 		if (ret)
 			goto out;
 		dio_data.outstanding_extents = div64_u64(count +
-						BTRFS_MAX_EXTENT_SIZE - 1,
-						BTRFS_MAX_EXTENT_SIZE);
+						max_extent_size - 1,
+						max_extent_size);
 
 		/*
 		 * We need to know how many extents we reserved so that we can
@@ -8888,7 +8914,8 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
 				btrfs_delalloc_release_space(inode, offset,
-							     dio_data.reserve);
+							     dio_data.reserve,
+							     0);
 			/*
 			 * On error we might have left some ordered extents
 			 * without submitting corresponding bios for them, so
@@ -8904,7 +8931,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 					0);
 		} else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode, offset,
-						     count - (size_t)ret);
+						     count - (size_t)ret, 0);
 	}
 out:
 	if (wakeup)
@@ -9164,7 +9191,7 @@ int btrfs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * being processed by btrfs_page_mkwrite() function.
 	 */
 	ret = btrfs_delalloc_reserve_space(inode, page_start,
-					   reserved_space);
+					   reserved_space, 0);
 	if (!ret) {
 		ret = file_update_time(vma->vm_file);
 		reserved = 1;
@@ -9216,7 +9243,7 @@ again:
 			BTRFS_I(inode)->outstanding_extents++;
 			spin_unlock(&BTRFS_I(inode)->lock);
 			btrfs_delalloc_release_space(inode, page_start,
-						PAGE_SIZE - reserved_space);
+						PAGE_SIZE - reserved_space, 0);
 		}
 	}
 
@@ -9233,7 +9260,7 @@ again:
 			  0, 0, &cached_state, GFP_NOFS);
 
 	ret = btrfs_set_extent_delalloc(inode, page_start, end,
-					&cached_state);
+					&cached_state, 0);
 	if (ret) {
 		unlock_extent_cached(io_tree, page_start, page_end,
 				     &cached_state, GFP_NOFS);
@@ -9271,7 +9298,7 @@ out_unlock:
 	}
 	unlock_page(page);
 out:
-	btrfs_delalloc_release_space(inode, page_start, reserved_space);
+	btrfs_delalloc_release_space(inode, page_start, reserved_space, 0);
 out_noreserve:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f38b472..41aa2c4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1142,7 +1142,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	ret = btrfs_delalloc_reserve_space(inode,
 			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			page_cnt << PAGE_SHIFT, 0);
 	if (ret)
 		return ret;
 	i_done = 0;
@@ -1233,7 +1233,7 @@ again:
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(inode,
 				start_index << PAGE_SHIFT,
-				(page_cnt - i_done) << PAGE_SHIFT);
+				(page_cnt - i_done) << PAGE_SHIFT, 0);
 	}
 
 	btrfs_set_extent_defrag(inode, page_start,
@@ -1258,7 +1258,7 @@ out:
 	}
 	btrfs_delalloc_release_space(inode,
 			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			page_cnt << PAGE_SHIFT, 0);
 	return ret;
 
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 8dda4a5..41f81e5 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -75,6 +75,7 @@ struct btrfs_ordered_sum {
 				 * in the logging code. */
 #define BTRFS_ORDERED_PENDING 11 /* We are waiting for this ordered extent to
 				  * complete in the current transaction. */
+
 struct btrfs_ordered_extent {
 	/* logical offset in the file */
 	u64 file_offset;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 32fcd8d..16bb383 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3146,7 +3146,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	index = (cluster->start - offset) >> PAGE_SHIFT;
 	last_index = (cluster->end - offset) >> PAGE_SHIFT;
 	while (index <= last_index) {
-		ret = btrfs_delalloc_reserve_metadata(inode, PAGE_SIZE);
+		ret = btrfs_delalloc_reserve_metadata(inode, PAGE_SIZE, 0);
 		if (ret)
 			goto out;
 
@@ -3159,7 +3159,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 						   mask);
 			if (!page) {
 				btrfs_delalloc_release_metadata(inode,
-							PAGE_SIZE);
+							PAGE_SIZE, 0);
 				ret = -ENOMEM;
 				goto out;
 			}
@@ -3178,7 +3178,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 				unlock_page(page);
 				put_page(page);
 				btrfs_delalloc_release_metadata(inode,
-							PAGE_SIZE);
+							PAGE_SIZE, 0);
 				ret = -EIO;
 				goto out;
 			}
@@ -3199,7 +3199,7 @@ static int relocate_file_extent_cluster(struct inode *inode,
 			nr++;
 		}
 
-		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
+		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL, 0);
 		set_page_dirty(page);
 
 		unlock_extent(&BTRFS_I(inode)->io_tree,
diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
index d19ab03..0a31527 100644
--- a/fs/btrfs/tests/extent-io-tests.c
+++ b/fs/btrfs/tests/extent-io-tests.c
@@ -114,7 +114,7 @@ static int test_find_delalloc(u32 sectorsize)
 	 * |--- delalloc ---|
 	 * |---  search  ---|
 	 */
-	set_extent_delalloc(&tmp, 0, sectorsize - 1, NULL);
+	set_extent_delalloc(&tmp, 0, sectorsize - 1, NULL, 0);
 	start = 0;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -145,7 +145,7 @@ static int test_find_delalloc(u32 sectorsize)
 		test_msg("Couldn't find the locked page\n");
 		goto out_bits;
 	}
-	set_extent_delalloc(&tmp, sectorsize, max_bytes - 1, NULL);
+	set_extent_delalloc(&tmp, sectorsize, max_bytes - 1, NULL, 0);
 	start = test_start;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
@@ -200,7 +200,7 @@ static int test_find_delalloc(u32 sectorsize)
 	 *
 	 * We are re-using our test_start from above since it works out well.
 	 */
-	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, NULL);
+	set_extent_delalloc(&tmp, max_bytes, total_dirty - 1, NULL, 0);
 	start = test_start;
 	end = 0;
 	found = find_lock_delalloc_range(inode, &tmp, locked_page, &start,
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index 29648c0..aede6cb 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -967,7 +967,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	/* [BTRFS_MAX_EXTENT_SIZE] */
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, 0, BTRFS_MAX_EXTENT_SIZE - 1,
-					NULL);
+					NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -983,7 +983,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE,
 					BTRFS_MAX_EXTENT_SIZE + sectorsize - 1,
-					NULL);
+					NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1018,7 +1018,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode, BTRFS_MAX_EXTENT_SIZE >> 1,
 					(BTRFS_MAX_EXTENT_SIZE >> 1)
 					+ sectorsize - 1,
-					NULL);
+					NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1041,7 +1041,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize,
 			(BTRFS_MAX_EXTENT_SIZE << 1) + 3 * sectorsize - 1,
-			NULL);
+			NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1059,7 +1059,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
-			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL);
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
@@ -1096,7 +1096,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	BTRFS_I(inode)->outstanding_extents++;
 	ret = btrfs_set_extent_delalloc(inode,
 			BTRFS_MAX_EXTENT_SIZE + sectorsize,
-			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL);
+			BTRFS_MAX_EXTENT_SIZE + 2 * sectorsize - 1, NULL, 0);
 	if (ret) {
 		test_msg("btrfs_set_extent_delalloc returned %d\n", ret);
 		goto out;
-- 
2.8.3



