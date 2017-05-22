Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38983 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758368AbdEVKQS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 06:16:18 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1BD68ABB1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 May 2017 10:16:17 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs: rename btrfs_leaf_data to BTRFS_LEAF_DATA_OFFSET
Date: Mon, 22 May 2017 13:16:10 +0300
Message-Id: <1495448171-20606-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 5f39d397dfbe ("Btrfs: Create extent_buffer interface
for large blocksizes") refactored btrfs_leaf_data function to take
extent_buffer rather than struct btrfs_leaf. However, as it turns out the
parameter being passed is never used. Furthermore this function no longer
returns the leaf data but rather the offset to it. So rename the function
to BTRFS_LEAF_DATA_OFFSET to make it consistent with other BTRFS_LEAF_*
helpers

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

These 2 patches are based off of David's for-next branch. 

 fs/btrfs/ctree.c     | 40 ++++++++++++++++++++--------------------
 fs/btrfs/ctree.h     | 13 +++++++------
 fs/btrfs/extent_io.c |  2 +-
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a3a75f1de002..5a9725e65788 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3667,14 +3667,14 @@ static noinline int __push_leaf_right(struct btrfs_fs_info *fs_info,
 	/* make room in the right data area */
 	data_end = leaf_data_end(fs_info, right);
 	memmove_extent_buffer(right,
-			      btrfs_leaf_data(right) + data_end - push_space,
-			      btrfs_leaf_data(right) + data_end,
+			      BTRFS_LEAF_DATA_OFFSET() + data_end - push_space,
+			      BTRFS_LEAF_DATA_OFFSET() + data_end,
 			      BTRFS_LEAF_DATA_SIZE(fs_info) - data_end);
 
 	/* copy from the left data area */
-	copy_extent_buffer(right, left, btrfs_leaf_data(right) +
+	copy_extent_buffer(right, left, BTRFS_LEAF_DATA_OFFSET() +
 		     BTRFS_LEAF_DATA_SIZE(fs_info) - push_space,
-		     btrfs_leaf_data(left) + leaf_data_end(fs_info, left),
+		     BTRFS_LEAF_DATA_OFFSET() + leaf_data_end(fs_info, left),
 		     push_space);
 
 	memmove_extent_buffer(right, btrfs_item_nr_offset(push_items),
@@ -3888,9 +3888,9 @@ static noinline int __push_leaf_left(struct btrfs_fs_info *fs_info,
 	push_space = BTRFS_LEAF_DATA_SIZE(fs_info) -
 		     btrfs_item_offset_nr(right, push_items - 1);
 
-	copy_extent_buffer(left, right, btrfs_leaf_data(left) +
+	copy_extent_buffer(left, right, BTRFS_LEAF_DATA_OFFSET() +
 		     leaf_data_end(fs_info, left) - push_space,
-		     btrfs_leaf_data(right) +
+		     BTRFS_LEAF_DATA_OFFSET() +
 		     btrfs_item_offset_nr(right, push_items - 1),
 		     push_space);
 	old_left_nritems = btrfs_header_nritems(left);
@@ -3917,9 +3917,9 @@ static noinline int __push_leaf_left(struct btrfs_fs_info *fs_info,
 	if (push_items < right_nritems) {
 		push_space = btrfs_item_offset_nr(right, push_items - 1) -
 						  leaf_data_end(fs_info, right);
-		memmove_extent_buffer(right, btrfs_leaf_data(right) +
+		memmove_extent_buffer(right, BTRFS_LEAF_DATA_OFFSET() +
 				      BTRFS_LEAF_DATA_SIZE(fs_info) - push_space,
-				      btrfs_leaf_data(right) +
+				      BTRFS_LEAF_DATA_OFFSET() +
 				      leaf_data_end(fs_info, right), push_space);
 
 		memmove_extent_buffer(right, btrfs_item_nr_offset(0),
@@ -4069,8 +4069,8 @@ static noinline void copy_for_split(struct btrfs_trans_handle *trans,
 			   nritems * sizeof(struct btrfs_item));
 
 	copy_extent_buffer(right, l,
-		     btrfs_leaf_data(right) + BTRFS_LEAF_DATA_SIZE(fs_info) -
-		     data_copy_size, btrfs_leaf_data(l) +
+		     BTRFS_LEAF_DATA_OFFSET() + BTRFS_LEAF_DATA_SIZE(fs_info) -
+		     data_copy_size, BTRFS_LEAF_DATA_OFFSET() +
 		     leaf_data_end(fs_info, l), data_copy_size);
 
 	rt_data_off = BTRFS_LEAF_DATA_SIZE(fs_info) - btrfs_item_end_nr(l, mid);
@@ -4607,8 +4607,8 @@ void btrfs_truncate_item(struct btrfs_fs_info *fs_info,
 
 	/* shift the data */
 	if (from_end) {
-		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
-			      data_end + size_diff, btrfs_leaf_data(leaf) +
+		memmove_extent_buffer(leaf, BTRFS_LEAF_DATA_OFFSET() +
+			      data_end + size_diff, BTRFS_LEAF_DATA_OFFSET() +
 			      data_end, old_data_start + new_size - data_end);
 	} else {
 		struct btrfs_disk_key disk_key;
@@ -4634,8 +4634,8 @@ void btrfs_truncate_item(struct btrfs_fs_info *fs_info,
 			}
 		}
 
-		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
-			      data_end + size_diff, btrfs_leaf_data(leaf) +
+		memmove_extent_buffer(leaf, BTRFS_LEAF_DATA_OFFSET() +
+			      data_end + size_diff, BTRFS_LEAF_DATA_OFFSET() +
 			      data_end, old_data_start - data_end);
 
 		offset = btrfs_disk_key_offset(&disk_key);
@@ -4707,8 +4707,8 @@ void btrfs_extend_item(struct btrfs_fs_info *fs_info, struct btrfs_path *path,
 	}
 
 	/* shift the data */
-	memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
-		      data_end - data_size, btrfs_leaf_data(leaf) +
+	memmove_extent_buffer(leaf, BTRFS_LEAF_DATA_OFFSET() +
+		      data_end - data_size, BTRFS_LEAF_DATA_OFFSET() +
 		      data_end, old_data - data_end);
 
 	data_end = old_data;
@@ -4790,8 +4790,8 @@ void setup_items_for_insert(struct btrfs_root *root, struct btrfs_path *path,
 			      (nritems - slot) * sizeof(struct btrfs_item));
 
 		/* shift the data */
-		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
-			      data_end - total_data, btrfs_leaf_data(leaf) +
+		memmove_extent_buffer(leaf, BTRFS_LEAF_DATA_OFFSET() +
+			      data_end - total_data, BTRFS_LEAF_DATA_OFFSET() +
 			      data_end, old_data - data_end);
 		data_end = old_data;
 	}
@@ -4983,9 +4983,9 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	if (slot + nr != nritems) {
 		int data_end = leaf_data_end(fs_info, leaf);
 
-		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
+		memmove_extent_buffer(leaf, BTRFS_LEAF_DATA_OFFSET() +
 			      data_end + dsize,
-			      btrfs_leaf_data(leaf) + data_end,
+			      BTRFS_LEAF_DATA_OFFSET() + data_end,
 			      last_off - data_end);
 
 		for (i = slot + nr; i < nritems; i++) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 160e4b8b510a..292c94c45df0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1292,6 +1292,11 @@ static inline u32 BTRFS_LEAF_DATA_SIZE(const struct btrfs_fs_info *info)
 	return __BTRFS_LEAF_DATA_SIZE(info->nodesize);
 }
 
+static inline unsigned long BTRFS_LEAF_DATA_OFFSET(void)
+{
+	return offsetof(struct btrfs_leaf, items);
+}
+
 static inline u32 BTRFS_MAX_ITEM_SIZE(const struct btrfs_fs_info *info)
 {
 	return BTRFS_LEAF_DATA_SIZE(info) - sizeof(struct btrfs_item);
@@ -2324,10 +2329,6 @@ static inline int btrfs_super_csum_size(struct btrfs_super_block *s)
 	return btrfs_csum_sizes[t];
 }
 
-static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
-{
-	return offsetof(struct btrfs_leaf, items);
-}
 
 /*
  * The leaf data grows from end-to-front in the node.
@@ -2538,11 +2539,11 @@ BTRFS_SETGET_STACK_FUNCS(stack_dev_replace_cursor_right,
 
 /* helper function to cast into the data area of the leaf. */
 #define btrfs_item_ptr(leaf, slot, type) \
-	((type *)(btrfs_leaf_data(leaf) + \
+	((type *)(BTRFS_LEAF_DATA_OFFSET() + \
 	btrfs_item_offset_nr(leaf, slot)))
 
 #define btrfs_item_ptr_offset(leaf, slot) \
-	((unsigned long)(btrfs_leaf_data(leaf) + \
+	((unsigned long)(BTRFS_LEAF_DATA_OFFSET() + \
 	btrfs_item_offset_nr(leaf, slot)))
 
 static inline bool btrfs_mixed_space_info(struct btrfs_space_info *space_info)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index da4658feb69d..12de460a1b40 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3775,7 +3775,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 		 * header 0 1 2 .. N ... data_N .. data_2 data_1 data_0
 		 */
 		start = btrfs_item_nr_offset(nritems);
-		end = btrfs_leaf_data(eb) + leaf_data_end(fs_info, eb);
+		end = BTRFS_LEAF_DATA_OFFSET() + leaf_data_end(fs_info, eb);
 		memzero_extent_buffer(eb, start, end - start);
 	}
 
-- 
2.7.4

