Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35510 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753978AbdHUOMK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 10:12:10 -0400
Received: by mail-qk0-f194.google.com with SMTP id a77so14494210qkb.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 07:12:09 -0700 (PDT)
From: josef@toxicpanda.com
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH][v2] btrfs: make the delalloc block rsv per inode
Date: Mon, 21 Aug 2017 10:12:06 -0400
Message-Id: <1503324726-29211-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

The way we handle delalloc metadata reservations has gotten
progressively more complicated over the years.  There is so much cruft
and weirdness around keeping the reserved count and outstanding counters
consistent and handling the error cases that it's impossible to
understand.

Fix this by making the delalloc block rsv per-inode.  This way we can
calculate the actual size of the outstanding metadata reservations every
time we make a change, and then reserve the delta based on that amount.
This greatly simplifies the code everywhere, and makes the error
handling in btrfs_delalloc_reserve_metadata far less terrifying.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
v1->v2:
- make btrfs_block_rsv_release_bytes return the bytes released instead of using
  a pointer to store it.
- use lockdep_assert_held instead of ASSERT().

 fs/btrfs/btrfs_inode.h       |  29 ++--
 fs/btrfs/ctree.h             |   5 +-
 fs/btrfs/delayed-inode.c     |  46 +------
 fs/btrfs/disk-io.c           |  18 ++-
 fs/btrfs/extent-tree.c       | 320 +++++++++++++++----------------------------
 fs/btrfs/inode.c             |  18 ++-
 include/trace/events/btrfs.h |  22 ---
 7 files changed, 141 insertions(+), 317 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 05db430..f9c6887 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -36,14 +36,13 @@
 #define BTRFS_INODE_ORPHAN_META_RESERVED	1
 #define BTRFS_INODE_DUMMY			2
 #define BTRFS_INODE_IN_DEFRAG			3
-#define BTRFS_INODE_DELALLOC_META_RESERVED	4
-#define BTRFS_INODE_HAS_ORPHAN_ITEM		5
-#define BTRFS_INODE_HAS_ASYNC_EXTENT		6
-#define BTRFS_INODE_NEEDS_FULL_SYNC		7
-#define BTRFS_INODE_COPY_EVERYTHING		8
-#define BTRFS_INODE_IN_DELALLOC_LIST		9
-#define BTRFS_INODE_READDIO_NEED_LOCK		10
-#define BTRFS_INODE_HAS_PROPS		        11
+#define BTRFS_INODE_HAS_ORPHAN_ITEM		4
+#define BTRFS_INODE_HAS_ASYNC_EXTENT		5
+#define BTRFS_INODE_NEEDS_FULL_SYNC		6
+#define BTRFS_INODE_COPY_EVERYTHING		7
+#define BTRFS_INODE_IN_DELALLOC_LIST		8
+#define BTRFS_INODE_READDIO_NEED_LOCK		9
+#define BTRFS_INODE_HAS_PROPS		        10
 
 /* in memory btrfs inode */
 struct btrfs_inode {
@@ -176,7 +175,8 @@ struct btrfs_inode {
 	 * of extent items we've reserved metadata for.
 	 */
 	unsigned outstanding_extents;
-	unsigned reserved_extents;
+
+	struct btrfs_block_rsv block_rsv;
 
 	/*
 	 * Cached values of inode properties
@@ -278,17 +278,6 @@ static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
 						  mod);
 }
 
-static inline void btrfs_mod_reserved_extents(struct btrfs_inode *inode,
-					      int mod)
-{
-	ASSERT(spin_is_locked(&inode->lock));
-	inode->reserved_extents += mod;
-	if (btrfs_is_free_space_inode(inode))
-		return;
-	trace_btrfs_inode_mod_reserved_extents(inode->root, btrfs_ino(inode),
-					       mod);
-}
-
 static inline int btrfs_inode_in_log(struct btrfs_inode *inode, u64 generation)
 {
 	int ret = 0;
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 04c3f5d..d49b045 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -763,8 +763,6 @@ struct btrfs_fs_info {
 	 * delayed dir index item
 	 */
 	struct btrfs_block_rsv global_block_rsv;
-	/* block reservation for delay allocation */
-	struct btrfs_block_rsv delalloc_block_rsv;
 	/* block reservation for metadata operations */
 	struct btrfs_block_rsv trans_block_rsv;
 	/* block reservation for chunk tree */
@@ -2744,6 +2742,9 @@ int btrfs_delalloc_reserve_space(struct inode *inode,
 void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type);
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_fs_info *fs_info,
 					      unsigned short type);
+void btrfs_init_metadata_block_rsv(struct btrfs_fs_info *fs_info,
+				   struct btrfs_block_rsv *rsv,
+				   unsigned short type);
 void btrfs_free_block_rsv(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_rsv *rsv);
 void __btrfs_free_block_rsv(struct btrfs_block_rsv *rsv);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 19e4ad2..5d73f79 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -581,7 +581,6 @@ static int btrfs_delayed_inode_reserve_metadata(
 	struct btrfs_block_rsv *dst_rsv;
 	u64 num_bytes;
 	int ret;
-	bool release = false;
 
 	src_rsv = trans->block_rsv;
 	dst_rsv = &fs_info->delayed_block_rsv;
@@ -589,36 +588,13 @@ static int btrfs_delayed_inode_reserve_metadata(
 	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
 
 	/*
-	 * If our block_rsv is the delalloc block reserve then check and see if
-	 * we have our extra reservation for updating the inode.  If not fall
-	 * through and try to reserve space quickly.
-	 *
-	 * We used to try and steal from the delalloc block rsv or the global
-	 * reserve, but we'd steal a full reservation, which isn't kind.  We are
-	 * here through delalloc which means we've likely just cowed down close
-	 * to the leaf that contains the inode, so we would steal less just
-	 * doing the fallback inode update, so if we do end up having to steal
-	 * from the global block rsv we hopefully only steal one or two blocks
-	 * worth which is less likely to hurt us.
-	 */
-	if (src_rsv && src_rsv->type == BTRFS_BLOCK_RSV_DELALLOC) {
-		spin_lock(&inode->lock);
-		if (test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-				       &inode->runtime_flags))
-			release = true;
-		else
-			src_rsv = NULL;
-		spin_unlock(&inode->lock);
-	}
-
-	/*
 	 * btrfs_dirty_inode will update the inode under btrfs_join_transaction
 	 * which doesn't reserve space for speed.  This is a problem since we
 	 * still need to reserve space for this update, so try to reserve the
 	 * space.
 	 *
 	 * Now if src_rsv == delalloc_block_rsv we'll let it just steal since
-	 * we're accounted for.
+	 * we always reserve enough to update the inode item.
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
 			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
@@ -643,32 +619,12 @@ static int btrfs_delayed_inode_reserve_metadata(
 	}
 
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
-
-	/*
-	 * Migrate only takes a reservation, it doesn't touch the size of the
-	 * block_rsv.  This is to simplify people who don't normally have things
-	 * migrated from their block rsv.  If they go to release their
-	 * reservation, that will decrease the size as well, so if migrate
-	 * reduced size we'd end up with a negative size.  But for the
-	 * delalloc_meta_reserved stuff we will only know to drop 1 reservation,
-	 * but we could in fact do this reserve/migrate dance several times
-	 * between the time we did the original reservation and we'd clean it
-	 * up.  So to take care of this, release the space for the meta
-	 * reservation here.  I think it may be time for a documentation page on
-	 * how block rsvs. work.
-	 */
 	if (!ret) {
 		trace_btrfs_space_reservation(fs_info, "delayed_inode",
 					      btrfs_ino(inode), num_bytes, 1);
 		node->bytes_reserved = num_bytes;
 	}
 
-	if (release) {
-		trace_btrfs_space_reservation(fs_info, "delalloc",
-					      btrfs_ino(inode), num_bytes, 0);
-		btrfs_block_rsv_release(fs_info, src_rsv, num_bytes);
-	}
-
 	return ret;
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 90b967a..4a41158 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2607,14 +2607,6 @@ int open_ctree(struct super_block *sb,
 		goto fail_delalloc_bytes;
 	}
 
-	fs_info->btree_inode = new_inode(sb);
-	if (!fs_info->btree_inode) {
-		err = -ENOMEM;
-		goto fail_bio_counter;
-	}
-
-	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
-
 	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
 	INIT_RADIX_TREE(&fs_info->buffer_radix, GFP_ATOMIC);
 	INIT_LIST_HEAD(&fs_info->trans_list);
@@ -2647,8 +2639,6 @@ int open_ctree(struct super_block *sb,
 	btrfs_mapping_init(&fs_info->mapping_tree);
 	btrfs_init_block_rsv(&fs_info->global_block_rsv,
 			     BTRFS_BLOCK_RSV_GLOBAL);
-	btrfs_init_block_rsv(&fs_info->delalloc_block_rsv,
-			     BTRFS_BLOCK_RSV_DELALLOC);
 	btrfs_init_block_rsv(&fs_info->trans_block_rsv, BTRFS_BLOCK_RSV_TRANS);
 	btrfs_init_block_rsv(&fs_info->chunk_block_rsv, BTRFS_BLOCK_RSV_CHUNK);
 	btrfs_init_block_rsv(&fs_info->empty_block_rsv, BTRFS_BLOCK_RSV_EMPTY);
@@ -2679,6 +2669,14 @@ int open_ctree(struct super_block *sb,
 
 	INIT_LIST_HEAD(&fs_info->ordered_roots);
 	spin_lock_init(&fs_info->ordered_root_lock);
+
+	fs_info->btree_inode = new_inode(sb);
+	if (!fs_info->btree_inode) {
+		err = -ENOMEM;
+		goto fail_bio_counter;
+	}
+	mapping_set_gfp_mask(fs_info->btree_inode->i_mapping, GFP_NOFS);
+
 	fs_info->delayed_root = kmalloc(sizeof(struct btrfs_delayed_root),
 					GFP_KERNEL);
 	if (!fs_info->delayed_root) {
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5db6645..a5d59dd 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 #include <linux/percpu_counter.h>
+#include <linux/lockdep.h>
 #include "hash.h"
 #include "tree-log.h"
 #include "disk-io.h"
@@ -4761,7 +4762,6 @@ static inline u64 calc_reclaim_items_nr(struct btrfs_fs_info *fs_info,
 static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 			    u64 orig, bool wait_ordered)
 {
-	struct btrfs_block_rsv *block_rsv;
 	struct btrfs_space_info *space_info;
 	struct btrfs_trans_handle *trans;
 	u64 delalloc_bytes;
@@ -4777,8 +4777,7 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
 	to_reclaim = items * EXTENT_SIZE_PER_ITEM;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
-	block_rsv = &fs_info->delalloc_block_rsv;
-	space_info = block_rsv->space_info;
+	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
 
 	delalloc_bytes = percpu_counter_sum_positive(
 						&fs_info->delalloc_bytes);
@@ -5500,11 +5499,12 @@ static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
 	}
 }
 
-static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
+static u64 block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 				    struct btrfs_block_rsv *block_rsv,
 				    struct btrfs_block_rsv *dest, u64 num_bytes)
 {
 	struct btrfs_space_info *space_info = block_rsv->space_info;
+	u64 ret;
 
 	spin_lock(&block_rsv->lock);
 	if (num_bytes == (u64)-1)
@@ -5519,6 +5519,7 @@ static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 	}
 	spin_unlock(&block_rsv->lock);
 
+	ret = num_bytes;
 	if (num_bytes > 0) {
 		if (dest) {
 			spin_lock(&dest->lock);
@@ -5538,6 +5539,7 @@ static void block_rsv_release_bytes(struct btrfs_fs_info *fs_info,
 			space_info_add_old_bytes(fs_info, space_info,
 						 num_bytes);
 	}
+	return ret;
 }
 
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src,
@@ -5561,6 +5563,15 @@ void btrfs_init_block_rsv(struct btrfs_block_rsv *rsv, unsigned short type)
 	rsv->type = type;
 }
 
+void btrfs_init_metadata_block_rsv(struct btrfs_fs_info *fs_info,
+				   struct btrfs_block_rsv *rsv,
+				   unsigned short type)
+{
+	btrfs_init_block_rsv(rsv, type);
+	rsv->space_info = __find_space_info(fs_info,
+					    BTRFS_BLOCK_GROUP_METADATA);
+}
+
 struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_fs_info *fs_info,
 					      unsigned short type)
 {
@@ -5570,9 +5581,7 @@ struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_fs_info *fs_info,
 	if (!block_rsv)
 		return NULL;
 
-	btrfs_init_block_rsv(block_rsv, type);
-	block_rsv->space_info = __find_space_info(fs_info,
-						  BTRFS_BLOCK_GROUP_METADATA);
+	btrfs_init_metadata_block_rsv(fs_info, block_rsv, type);
 	return block_rsv;
 }
 
@@ -5655,6 +5664,66 @@ int btrfs_block_rsv_refill(struct btrfs_root *root,
 	return ret;
 }
 
+/**
+ * btrfs_inode_rsv_refill - refill the inode block rsv.
+ * @inode - the inode we are refilling.
+ * @flush - the flusing restriction.
+ *
+ * Essentially the same as btrfs_block_rsv_refill, except it uses the
+ * block_rsv->size as the minimum size.  We'll either refill the missing amount
+ * or return if we already have enough space.  This will also handle the resreve
+ * tracepoint for the reserved amount.
+ */
+int btrfs_inode_rsv_refill(struct btrfs_inode *inode,
+			   enum btrfs_reserve_flush_enum flush)
+{
+	struct btrfs_root *root = inode->root;
+	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
+	u64 num_bytes = 0;
+	int ret = -ENOSPC;
+
+	spin_lock(&block_rsv->lock);
+	if (block_rsv->reserved < block_rsv->size)
+		num_bytes = block_rsv->size - block_rsv->reserved;
+	spin_unlock(&block_rsv->lock);
+
+	if (num_bytes == 0)
+		return 0;
+
+	ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
+	if (!ret) {
+		block_rsv_add_bytes(block_rsv, num_bytes, 0);
+		trace_btrfs_space_reservation(root->fs_info, "delalloc",
+					      btrfs_ino(inode), num_bytes, 1);
+	}
+	return ret;
+}
+
+/**
+ * btrfs_inode_rsv_release - release any excessive reservation.
+ * @inode - the inode we need to release from.
+ *
+ * This is the same as btrfs_block_rsv_release, except that it handles the
+ * tracepoint for the reservation.
+ */
+void btrfs_inode_rsv_release(struct btrfs_inode *inode)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
+	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
+	u64 released = 0;
+
+	/*
+	 * Since we statically set the block_rsv->size we just want to say we
+	 * are releasing 0 bytes, and then we'll just get the reservation over
+	 * the size free'd.
+	 */
+	released = block_rsv_release_bytes(fs_info, block_rsv, global_rsv, 0);
+	if (released > 0)
+		trace_btrfs_space_reservation(fs_info, "delalloc",
+					      btrfs_ino(inode), released, 0);
+}
+
 void btrfs_block_rsv_release(struct btrfs_fs_info *fs_info,
 			     struct btrfs_block_rsv *block_rsv,
 			     u64 num_bytes)
@@ -5726,7 +5795,6 @@ static void init_global_block_rsv(struct btrfs_fs_info *fs_info)
 
 	space_info = __find_space_info(fs_info, BTRFS_BLOCK_GROUP_METADATA);
 	fs_info->global_block_rsv.space_info = space_info;
-	fs_info->delalloc_block_rsv.space_info = space_info;
 	fs_info->trans_block_rsv.space_info = space_info;
 	fs_info->empty_block_rsv.space_info = space_info;
 	fs_info->delayed_block_rsv.space_info = space_info;
@@ -5746,8 +5814,6 @@ static void release_global_block_rsv(struct btrfs_fs_info *fs_info)
 {
 	block_rsv_release_bytes(fs_info, &fs_info->global_block_rsv, NULL,
 				(u64)-1);
-	WARN_ON(fs_info->delalloc_block_rsv.size > 0);
-	WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
 	WARN_ON(fs_info->trans_block_rsv.size > 0);
 	WARN_ON(fs_info->trans_block_rsv.reserved > 0);
 	WARN_ON(fs_info->chunk_block_rsv.size > 0);
@@ -5886,95 +5952,37 @@ void btrfs_subvolume_release_metadata(struct btrfs_fs_info *fs_info,
 	btrfs_block_rsv_release(fs_info, rsv, (u64)-1);
 }
 
-/**
- * drop_over_reserved_extents - drop our extra extent reservations
- * @inode: the inode we're dropping the extent for
- *
- * We reserve extents we may use, but they may have been merged with other
- * extents and we may not need the extra reservation.
- *
- * We also call this when we've completed io to an extent or had an error and
- * cleared the outstanding extent, in either case we no longer need our
- * reservation and can drop the excess.
- */
-static unsigned drop_over_reserved_extents(struct btrfs_inode *inode)
-{
-	unsigned num_extents = 0;
-
-	if (inode->reserved_extents > inode->outstanding_extents) {
-		num_extents = inode->reserved_extents -
-			inode->outstanding_extents;
-		btrfs_mod_reserved_extents(inode, -num_extents);
-	}
-
-	if (inode->outstanding_extents == 0 &&
-	    test_and_clear_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-			       &inode->runtime_flags))
-		num_extents++;
-	return num_extents;
-}
-
-/**
- * calc_csum_metadata_size - return the amount of metadata space that must be
- *	reserved/freed for the given bytes.
- * @inode: the inode we're manipulating
- * @num_bytes: the number of bytes in question
- * @reserve: 1 if we are reserving space, 0 if we are freeing space
- *
- * This adjusts the number of csum_bytes in the inode and then returns the
- * correct amount of metadata that must either be reserved or freed.  We
- * calculate how many checksums we can fit into one leaf and then divide the
- * number of bytes that will need to be checksumed by this value to figure out
- * how many checksums will be required.  If we are adding bytes then the number
- * may go up and we will return the number of additional bytes that must be
- * reserved.  If it is going down we will return the number of bytes that must
- * be freed.
- *
- * This must be called with BTRFS_I(inode)->lock held.
- */
-static u64 calc_csum_metadata_size(struct btrfs_inode *inode, u64 num_bytes,
-				   int reserve)
+static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
+						 struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
-	u64 old_csums, num_csums;
-
-	if (inode->flags & BTRFS_INODE_NODATASUM && inode->csum_bytes == 0)
-		return 0;
-
-	old_csums = btrfs_csum_bytes_to_leaves(fs_info, inode->csum_bytes);
-	if (reserve)
-		inode->csum_bytes += num_bytes;
-	else
-		inode->csum_bytes -= num_bytes;
-	num_csums = btrfs_csum_bytes_to_leaves(fs_info, inode->csum_bytes);
-
-	/* No change, no need to reserve more */
-	if (old_csums == num_csums)
-		return 0;
+	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
+	u64 reserve_size = 0;
+	u64 csum_leaves;
+	unsigned outstanding_extents;
 
-	if (reserve)
-		return btrfs_calc_trans_metadata_size(fs_info,
-						      num_csums - old_csums);
+	lockdep_assert_held(&inode->lock);
+	outstanding_extents = inode->outstanding_extents;
+	if (outstanding_extents)
+		reserve_size = btrfs_calc_trans_metadata_size(fs_info,
+						outstanding_extents + 1);
+	csum_leaves = btrfs_csum_bytes_to_leaves(fs_info,
+						 inode->csum_bytes);
+	reserve_size += btrfs_calc_trans_metadata_size(fs_info,
+						       csum_leaves);
 
-	return btrfs_calc_trans_metadata_size(fs_info, old_csums - num_csums);
+	spin_lock(&block_rsv->lock);
+	block_rsv->size = reserve_size;
+	spin_unlock(&block_rsv->lock);
 }
 
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	struct btrfs_root *root = inode->root;
-	struct btrfs_block_rsv *block_rsv = &fs_info->delalloc_block_rsv;
-	u64 to_reserve = 0;
-	u64 csum_bytes;
-	unsigned nr_extents, reserve_extents;
+	unsigned nr_extents;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 	bool delalloc_lock = true;
-	u64 to_free = 0;
-	unsigned dropped;
-	bool release_extra = false;
-	bool underflow = false;
-	bool did_retry = false;
 
 	WARN_ON(btrfs_is_free_space_inode(inode));
 
@@ -6001,33 +6009,13 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 		mutex_lock(&inode->delalloc_mutex);
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
-retry:
+
+	/* Add our new extents and calculate the new rsv size. */
 	spin_lock(&inode->lock);
-	reserve_extents = nr_extents = count_max_extents(num_bytes);
+	nr_extents = count_max_extents(num_bytes);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
-
-	/*
-	 * Because we add an outstanding extent for ordered before we clear
-	 * delalloc we will double count our outstanding extents slightly.  This
-	 * could mean that we transiently over-reserve, which could result in an
-	 * early ENOSPC if our timing is unlucky.  Keep track of the case that
-	 * we had a reservation underflow so we can retry if we fail.
-	 *
-	 * Keep in mind we can legitimately have more outstanding extents than
-	 * reserved because of fragmentation, so only allow a retry once.
-	 */
-	if (inode->outstanding_extents >
-	    inode->reserved_extents + nr_extents) {
-		reserve_extents = inode->outstanding_extents -
-			inode->reserved_extents;
-		underflow = true;
-	}
-
-	/* We always want to reserve a slot for updating the inode. */
-	to_reserve = btrfs_calc_trans_metadata_size(fs_info,
-						    reserve_extents + 1);
-	to_reserve += calc_csum_metadata_size(inode, num_bytes, 1);
-	csum_bytes = inode->csum_bytes;
+	inode->csum_bytes += num_bytes;
+	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 
 	if (test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
@@ -6037,100 +6025,26 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 			goto out_fail;
 	}
 
-	ret = btrfs_block_rsv_add(root, block_rsv, to_reserve, flush);
+	ret = btrfs_inode_rsv_refill(inode, flush);
 	if (unlikely(ret)) {
 		btrfs_qgroup_free_meta(root,
 				       nr_extents * fs_info->nodesize);
 		goto out_fail;
 	}
 
-	spin_lock(&inode->lock);
-	if (test_and_set_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
-			     &inode->runtime_flags)) {
-		to_reserve -= btrfs_calc_trans_metadata_size(fs_info, 1);
-		release_extra = true;
-	}
-	btrfs_mod_reserved_extents(inode, reserve_extents);
-	spin_unlock(&inode->lock);
-
 	if (delalloc_lock)
 		mutex_unlock(&inode->delalloc_mutex);
-
-	if (to_reserve)
-		trace_btrfs_space_reservation(fs_info, "delalloc",
-					      btrfs_ino(inode), to_reserve, 1);
-	if (release_extra)
-		btrfs_block_rsv_release(fs_info, block_rsv,
-				btrfs_calc_trans_metadata_size(fs_info, 1));
 	return 0;
 
 out_fail:
 	spin_lock(&inode->lock);
 	nr_extents = count_max_extents(num_bytes);
 	btrfs_mod_outstanding_extents(inode, -nr_extents);
-
-	dropped = drop_over_reserved_extents(inode);
-	/*
-	 * If the inodes csum_bytes is the same as the original
-	 * csum_bytes then we know we haven't raced with any free()ers
-	 * so we can just reduce our inodes csum bytes and carry on.
-	 */
-	if (inode->csum_bytes == csum_bytes) {
-		calc_csum_metadata_size(inode, num_bytes, 0);
-	} else {
-		u64 orig_csum_bytes = inode->csum_bytes;
-		u64 bytes;
-
-		/*
-		 * This is tricky, but first we need to figure out how much we
-		 * freed from any free-ers that occurred during this
-		 * reservation, so we reset ->csum_bytes to the csum_bytes
-		 * before we dropped our lock, and then call the free for the
-		 * number of bytes that were freed while we were trying our
-		 * reservation.
-		 */
-		bytes = csum_bytes - inode->csum_bytes;
-		inode->csum_bytes = csum_bytes;
-		to_free = calc_csum_metadata_size(inode, bytes, 0);
-
-
-		/*
-		 * Now we need to see how much we would have freed had we not
-		 * been making this reservation and our ->csum_bytes were not
-		 * artificially inflated.
-		 */
-		inode->csum_bytes = csum_bytes - num_bytes;
-		bytes = csum_bytes - orig_csum_bytes;
-		bytes = calc_csum_metadata_size(inode, bytes, 0);
-
-		/*
-		 * Now reset ->csum_bytes to what it should be.  If bytes is
-		 * more than to_free then we would have freed more space had we
-		 * not had an artificially high ->csum_bytes, so we need to free
-		 * the remainder.  If bytes is the same or less then we don't
-		 * need to do anything, the other free-ers did the correct
-		 * thing.
-		 */
-		inode->csum_bytes = orig_csum_bytes - num_bytes;
-		if (bytes > to_free)
-			to_free = bytes - to_free;
-		else
-			to_free = 0;
-	}
+	inode->csum_bytes -= num_bytes;
+	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
-	if (dropped)
-		to_free += btrfs_calc_trans_metadata_size(fs_info, dropped);
 
-	if (to_free) {
-		btrfs_block_rsv_release(fs_info, block_rsv, to_free);
-		trace_btrfs_space_reservation(fs_info, "delalloc",
-					      btrfs_ino(inode), to_free, 0);
-	}
-	if (underflow && !did_retry) {
-		did_retry = true;
-		underflow = false;
-		goto retry;
-	}
+	btrfs_inode_rsv_release(inode);
 	if (delalloc_lock)
 		mutex_unlock(&inode->delalloc_mutex);
 	return ret;
@@ -6148,25 +6062,17 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
-	u64 to_free = 0;
-	unsigned dropped;
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 	spin_lock(&inode->lock);
-	dropped = drop_over_reserved_extents(inode);
-	if (num_bytes)
-		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
+	inode->csum_bytes -= num_bytes;
+	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
-	if (dropped > 0)
-		to_free += btrfs_calc_trans_metadata_size(fs_info, dropped);
 
 	if (btrfs_is_testing(fs_info))
 		return;
 
-	trace_btrfs_space_reservation(fs_info, "delalloc", btrfs_ino(inode),
-				      to_free, 0);
-
-	btrfs_block_rsv_release(fs_info, &fs_info->delalloc_block_rsv, to_free);
+	btrfs_inode_rsv_release(inode);
 }
 
 /**
@@ -6184,25 +6090,17 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	unsigned num_extents;
-	u64 to_free;
-	unsigned dropped;
 
 	spin_lock(&inode->lock);
 	num_extents = count_max_extents(num_bytes);
 	btrfs_mod_outstanding_extents(inode, -num_extents);
-	dropped = drop_over_reserved_extents(inode);
+	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 
-	if (!dropped)
-		return;
-
 	if (btrfs_is_testing(fs_info))
 		return;
 
-	to_free = btrfs_calc_trans_metadata_size(fs_info, dropped);
-	trace_btrfs_space_reservation(fs_info, "delalloc", btrfs_ino(inode),
-				      to_free, 0);
-	btrfs_block_rsv_release(fs_info, &fs_info->delalloc_block_rsv, to_free);
+	btrfs_inode_rsv_release(inode);
 }
 
 /**
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index af1770d..0038de5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -42,6 +42,7 @@
 #include <linux/blkdev.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/uio.h>
+#include <linux/magic.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -303,7 +304,7 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 		btrfs_free_path(path);
 		return PTR_ERR(trans);
 	}
-	trans->block_rsv = &fs_info->delalloc_block_rsv;
+	trans->block_rsv = &BTRFS_I(inode)->block_rsv;
 
 	if (compressed_size && compressed_pages)
 		extent_item_size = btrfs_file_extent_calc_inline_size(
@@ -2949,7 +2950,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 			trans = NULL;
 			goto out;
 		}
-		trans->block_rsv = &fs_info->delalloc_block_rsv;
+		trans->block_rsv = &BTRFS_I(inode)->block_rsv;
 		ret = btrfs_update_inode_fallback(trans, root, inode);
 		if (ret) /* -ENOMEM or corruption */
 			btrfs_abort_transaction(trans, ret);
@@ -2985,7 +2986,7 @@ static int btrfs_finish_ordered_io(struct btrfs_ordered_extent *ordered_extent)
 		goto out;
 	}
 
-	trans->block_rsv = &fs_info->delalloc_block_rsv;
+	trans->block_rsv = &BTRFS_I(inode)->block_rsv;
 
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
 		compress_type = ordered_extent->compress_type;
@@ -8832,7 +8833,6 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (iov_iter_rw(iter) == WRITE) {
 		up_read(&BTRFS_I(inode)->dio_sem);
 		current->journal_info = NULL;
-		btrfs_delalloc_release_extents(BTRFS_I(inode), count);
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
 				btrfs_delalloc_release_space(inode, data_reserved,
@@ -8853,6 +8853,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		} else if (ret >= 0 && (size_t)ret < count)
 			btrfs_delalloc_release_space(inode, data_reserved,
 					offset, count - (size_t)ret);
+		btrfs_delalloc_release_extents(BTRFS_I(inode), count);
 	}
 out:
 	if (wakeup)
@@ -9417,6 +9418,7 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 
 struct inode *btrfs_alloc_inode(struct super_block *sb)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_inode *ei;
 	struct inode *inode;
 
@@ -9443,8 +9445,9 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 
 	spin_lock_init(&ei->lock);
 	ei->outstanding_extents = 0;
-	ei->reserved_extents = 0;
-
+	if (sb->s_magic != BTRFS_TEST_MAGIC)
+		btrfs_init_metadata_block_rsv(fs_info, &ei->block_rsv,
+					      BTRFS_BLOCK_RSV_DELALLOC);
 	ei->runtime_flags = 0;
 	ei->prop_compress = BTRFS_COMPRESS_NONE;
 	ei->defrag_compress = BTRFS_COMPRESS_NONE;
@@ -9494,8 +9497,9 @@ void btrfs_destroy_inode(struct inode *inode)
 
 	WARN_ON(!hlist_empty(&inode->i_dentry));
 	WARN_ON(inode->i_data.nrpages);
+	WARN_ON(BTRFS_I(inode)->block_rsv.reserved);
+	WARN_ON(BTRFS_I(inode)->block_rsv.size);
 	WARN_ON(BTRFS_I(inode)->outstanding_extents);
-	WARN_ON(BTRFS_I(inode)->reserved_extents);
 	WARN_ON(BTRFS_I(inode)->delalloc_bytes);
 	WARN_ON(BTRFS_I(inode)->new_delalloc_bytes);
 	WARN_ON(BTRFS_I(inode)->csum_bytes);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 1dd1108..b933a6a 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1713,28 +1713,6 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
 			(unsigned long long)__entry->ino, __entry->mod)
 );
 
-TRACE_EVENT(btrfs_inode_mod_reserved_extents,
-	TP_PROTO(struct btrfs_root *root, u64 ino, int mod),
-
-	TP_ARGS(root, ino, mod),
-
-	TP_STRUCT__entry_btrfs(
-		__field(	u64, root_objectid	)
-		__field(	u64, ino		)
-		__field(	int, mod		)
-	),
-
-	TP_fast_assign_btrfs(root->fs_info,
-		__entry->root_objectid	= root->objectid;
-		__entry->ino		= ino;
-		__entry->mod		= mod;
-	),
-
-	TP_printk_btrfs("root = %llu(%s), ino = %llu, mod = %d",
-			show_root_type(__entry->root_objectid),
-			(unsigned long long)__entry->ino, __entry->mod)
-);
-
 #endif /* _TRACE_BTRFS_H */
 
 /* This part must be outside protection */
-- 
2.7.4

