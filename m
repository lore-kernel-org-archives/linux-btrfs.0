Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:7619 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752532AbeAaDJn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 22:09:43 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v3 7/7] btrfs-progs: Cleanup use of root in leaf_data_end
Date: Wed, 31 Jan 2018 11:09:19 +0800
Message-ID: <1517368159-12858-8-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
References: <1517368159-12858-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In function leaf_data_end, root is just used to get fs_info,
so change the parameter of this function from btrfs_root to
btrfs_fs_info.
And also make it consistent with kernel.

Changelog:
v3->v2:
Add const to parameter leaf of function btrfs_item_offset_nr
to keep type consistent with leaf_data_end.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
 ctree.c | 32 +++++++++++++++++---------------
 ctree.h |  2 +-
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/ctree.c b/ctree.c
index 4efc96f..45b368c 100644
--- a/ctree.c
+++ b/ctree.c
@@ -408,12 +408,12 @@ static int btrfs_comp_keys(struct btrfs_disk_key *disk, struct btrfs_key *k2)
  * this returns the address of the start of the last item,
  * which is the stop of the leaf data stack
  */
-static inline unsigned int leaf_data_end(struct btrfs_root *root,
-					 struct extent_buffer *leaf)
+static inline unsigned int leaf_data_end(const struct btrfs_fs_info *fs_info,
+					 const struct extent_buffer *leaf)
 {
 	u32 nr = btrfs_header_nritems(leaf);
 	if (nr == 0)
-		return BTRFS_LEAF_DATA_SIZE(root->fs_info);
+		return BTRFS_LEAF_DATA_SIZE(fs_info);
 	return btrfs_item_offset_nr(leaf, nr - 1);
 }
 
@@ -1735,10 +1735,10 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	right_nritems = btrfs_header_nritems(right);
 
 	push_space = btrfs_item_end_nr(left, left_nritems - push_items);
-	push_space -= leaf_data_end(root, left);
+	push_space -= leaf_data_end(fs_info, left);
 
 	/* make room in the right data area */
-	data_end = leaf_data_end(root, right);
+	data_end = leaf_data_end(fs_info, right);
 	memmove_extent_buffer(right,
 			      btrfs_leaf_data(right) + data_end - push_space,
 			      btrfs_leaf_data(right) + data_end,
@@ -1747,7 +1747,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 	/* copy from the left data area */
 	copy_extent_buffer(right, left, btrfs_leaf_data(right) +
 		     BTRFS_LEAF_DATA_SIZE(root->fs_info) - push_space,
-		     btrfs_leaf_data(left) + leaf_data_end(root, left),
+		     btrfs_leaf_data(left) + leaf_data_end(fs_info, left),
 		     push_space);
 
 	memmove_extent_buffer(right, btrfs_item_nr_offset(push_items),
@@ -1885,7 +1885,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		     btrfs_item_offset_nr(right, push_items -1);
 
 	copy_extent_buffer(left, right, btrfs_leaf_data(left) +
-		     leaf_data_end(root, left) - push_space,
+		     leaf_data_end(fs_info, left) - push_space,
 		     btrfs_leaf_data(right) +
 		     btrfs_item_offset_nr(right, push_items - 1),
 		     push_space);
@@ -1912,12 +1912,13 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	if (push_items < right_nritems) {
 		push_space = btrfs_item_offset_nr(right, push_items - 1) -
-						  leaf_data_end(root, right);
+						  leaf_data_end(fs_info, right);
 		memmove_extent_buffer(right, btrfs_leaf_data(right) +
 				      BTRFS_LEAF_DATA_SIZE(root->fs_info) -
 				      push_space,
 				      btrfs_leaf_data(right) +
-				      leaf_data_end(root, right), push_space);
+				      leaf_data_end(fs_info, right),
+				      push_space);
 
 		memmove_extent_buffer(right, btrfs_item_nr_offset(0),
 			      btrfs_item_nr_offset(push_items),
@@ -1976,7 +1977,8 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 
 	nritems = nritems - mid;
 	btrfs_set_header_nritems(right, nritems);
-	data_copy_size = btrfs_item_end_nr(l, mid) - leaf_data_end(root, l);
+	data_copy_size = btrfs_item_end_nr(l, mid) -
+		leaf_data_end(root->fs_info, l);
 
 	copy_extent_buffer(right, l, btrfs_item_nr_offset(0),
 			   btrfs_item_nr_offset(mid),
@@ -1986,7 +1988,7 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 		     btrfs_leaf_data(right) +
 		     BTRFS_LEAF_DATA_SIZE(root->fs_info) -
 		     data_copy_size, btrfs_leaf_data(l) +
-		     leaf_data_end(root, l), data_copy_size);
+		     leaf_data_end(root->fs_info, l), data_copy_size);
 
 	rt_data_off = BTRFS_LEAF_DATA_SIZE(root->fs_info) -
 		      btrfs_item_end_nr(l, mid);
@@ -2324,7 +2326,7 @@ int btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 		return 0;
 
 	nritems = btrfs_header_nritems(leaf);
-	data_end = leaf_data_end(root, leaf);
+	data_end = leaf_data_end(root->fs_info, leaf);
 
 	old_data_start = btrfs_item_offset_nr(leaf, slot);
 
@@ -2413,7 +2415,7 @@ int btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 	leaf = path->nodes[0];
 
 	nritems = btrfs_header_nritems(leaf);
-	data_end = leaf_data_end(root, leaf);
+	data_end = leaf_data_end(root->fs_info, leaf);
 
 	if (btrfs_leaf_free_space(root, leaf) < data_size) {
 		btrfs_print_leaf(root, leaf);
@@ -2499,7 +2501,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	leaf = path->nodes[0];
 
 	nritems = btrfs_header_nritems(leaf);
-	data_end = leaf_data_end(root, leaf);
+	data_end = leaf_data_end(root->fs_info, leaf);
 
 	if (btrfs_leaf_free_space(root, leaf) < total_size) {
 		btrfs_print_leaf(root, leaf);
@@ -2690,7 +2692,7 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	nritems = btrfs_header_nritems(leaf);
 
 	if (slot + nr != nritems) {
-		int data_end = leaf_data_end(root, leaf);
+		int data_end = leaf_data_end(root->fs_info, leaf);
 
 		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
 			      data_end + dsize,
diff --git a/ctree.h b/ctree.h
index 41b14b5..0953267 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1857,7 +1857,7 @@ static inline u32 btrfs_item_end_nr(struct extent_buffer *eb, int nr)
 	return btrfs_item_end(eb, btrfs_item_nr(nr));
 }
 
-static inline u32 btrfs_item_offset_nr(struct extent_buffer *eb, int nr)
+static inline u32 btrfs_item_offset_nr(const struct extent_buffer *eb, int nr)
 {
 	return btrfs_item_offset(eb, btrfs_item_nr(nr));
 }
-- 
1.9.1



