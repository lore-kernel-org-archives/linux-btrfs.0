Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:53074 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeC3FtM (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 30 Mar 2018 01:49:12 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/5] btrfs-progs: Unify btrfs_leaf_free_psace() parameter with kernel
Date: Fri, 30 Mar 2018 13:48:56 +0800
Message-Id: <20180330054857.6106-5-wqu@suse.com>
In-Reply-To: <20180330054857.6106-1-wqu@suse.com>
References: <20180330054857.6106-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of struct btrfs_root, use struct btrfs_fs_info, since nodesize
is now a per-fs setting, and with the need to pass a @root, caller don't
need to wonder which root should be passed.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs-corrupt-block.c |  2 +-
 check/main.c          |  2 +-
 check/mode-lowmem.c   |  2 +-
 ctree.c               | 49 ++++++++++++++++++++++++++-----------------------
 ctree.h               |  3 ++-
 print-tree.c          |  2 +-
 6 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 59ee1b45922e..da0ec8c51e5a 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -726,7 +726,7 @@ out:
 static void shift_items(struct btrfs_root *root, struct extent_buffer *eb)
 {
 	int nritems = btrfs_header_nritems(eb);
-	int shift_space = btrfs_leaf_free_space(root, eb) / 2;
+	int shift_space = btrfs_leaf_free_space(root->fs_info, eb) / 2;
 	int slot = nritems / 2;
 	int i = 0;
 	unsigned int data_end = btrfs_item_offset_nr(eb, nritems - 1);
diff --git a/check/main.c b/check/main.c
index 891a6d797756..7fde46e459e4 100644
--- a/check/main.c
+++ b/check/main.c
@@ -5959,7 +5959,7 @@ static int run_next_block(struct btrfs_root *root,
 		goto out;
 
 	if (btrfs_is_leaf(buf)) {
-		btree_space_waste += btrfs_leaf_free_space(root, buf);
+		btree_space_waste += btrfs_leaf_free_space(fs_info, buf);
 		for (i = 0; i < nritems; i++) {
 			struct btrfs_file_extent_item *fi;
 
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index dac3201b7d99..bfe45abab6cc 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -390,7 +390,7 @@ static void account_bytes(struct btrfs_root *root, struct btrfs_path *path,
 		total_extent_tree_bytes += eb->len;
 
 	if (level == 0) {
-		btree_space_waste += btrfs_leaf_free_space(root, eb);
+		btree_space_waste += btrfs_leaf_free_space(root->fs_info, eb);
 	} else {
 		free_nrs = (BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) -
 			    btrfs_header_nritems(eb));
diff --git a/ctree.c b/ctree.c
index e26a1c29bb75..20848f0f7024 100644
--- a/ctree.c
+++ b/ctree.c
@@ -480,11 +480,11 @@ btrfs_check_leaf(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 		       (unsigned long long)btrfs_header_bytenr(buf));
 		goto fail;
 	}
-	if (btrfs_leaf_free_space(root, buf) < 0) {
+	if (btrfs_leaf_free_space(root->fs_info, buf) < 0) {
 		ret = BTRFS_TREE_BLOCK_INVALID_FREE_SPACE;
 		fprintf(stderr, "leaf free space incorrect %llu %d\n",
 			(unsigned long long)btrfs_header_bytenr(buf),
-			btrfs_leaf_free_space(root, buf));
+			btrfs_leaf_free_space(root->fs_info, buf));
 		goto fail;
 	}
 
@@ -1193,7 +1193,7 @@ again:
 		} else {
 			p->slots[level] = slot;
 			if (ins_len > 0 &&
-			    ins_len > btrfs_leaf_free_space(root, b)) {
+			    ins_len > btrfs_leaf_free_space(root->fs_info, b)) {
 				int sret = split_leaf(trans, root, key,
 						      p, ins_len, ret == 0);
 				BUG_ON(sret > 0);
@@ -1634,16 +1634,17 @@ static int leaf_space_used(struct extent_buffer *l, int start, int nr)
  * the start of the leaf data.  IOW, how much room
  * the leaf has left for both items and data
  */
-int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf)
+int btrfs_leaf_free_space(struct btrfs_fs_info *fs_info,
+			  struct extent_buffer *leaf)
 {
-	u32 nodesize = (root ? BTRFS_LEAF_DATA_SIZE(root->fs_info) : leaf->len);
 	int nritems = btrfs_header_nritems(leaf);
 	int ret;
-	ret = nodesize - leaf_space_used(leaf, 0, nritems);
+
+	ret = BTRFS_LEAF_DATA_SIZE(fs_info) - leaf_space_used(leaf, 0, nritems);
 	if (ret < 0) {
-		printk("leaf free space ret %d, leaf data size %u, used %d nritems %d\n",
-		       ret, nodesize, leaf_space_used(leaf, 0, nritems),
-		       nritems);
+		printk("leaf free space ret %d, leaf data size %lu, used %d nritems %d\n",
+		       ret, BTRFS_LEAF_DATA_SIZE(fs_info),
+		       leaf_space_used(leaf, 0, nritems), nritems);
 	}
 	return ret;
 }
@@ -1691,7 +1692,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 			return PTR_ERR(right);
 		return -EIO;
 	}
-	free_space = btrfs_leaf_free_space(root, right);
+	free_space = btrfs_leaf_free_space(fs_info, right);
 	if (free_space < data_size) {
 		free_extent_buffer(right);
 		return 1;
@@ -1704,7 +1705,7 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
 		free_extent_buffer(right);
 		return 1;
 	}
-	free_space = btrfs_leaf_free_space(root, right);
+	free_space = btrfs_leaf_free_space(fs_info, right);
 	if (free_space < data_size) {
 		free_extent_buffer(right);
 		return 1;
@@ -1843,7 +1844,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 	}
 
 	left = read_node_slot(fs_info, path->nodes[1], slot - 1);
-	free_space = btrfs_leaf_free_space(root, left);
+	free_space = btrfs_leaf_free_space(fs_info, left);
 	if (free_space < data_size) {
 		free_extent_buffer(left);
 		return 1;
@@ -1858,7 +1859,7 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
 		return 1;
 	}
 
-	free_space = btrfs_leaf_free_space(root, left);
+	free_space = btrfs_leaf_free_space(fs_info, left);
 	if (free_space < data_size) {
 		free_extent_buffer(left);
 		return 1;
@@ -2082,7 +2083,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 		l = path->nodes[0];
 
 		/* did the pushes work? */
-		if (btrfs_leaf_free_space(root, l) >= data_size)
+		if (btrfs_leaf_free_space(root->fs_info, l) >= data_size)
 			return 0;
 	}
 
@@ -2239,7 +2240,8 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &orig_key, path->slots[0]);
-	if (btrfs_leaf_free_space(root, leaf) >= sizeof(struct btrfs_item))
+	if (btrfs_leaf_free_space(root->fs_info, leaf) >=
+	    sizeof(struct btrfs_item))
 		goto split;
 
 	item_size = btrfs_item_size_nr(leaf, path->slots[0]);
@@ -2259,7 +2261,8 @@ int btrfs_split_item(struct btrfs_trans_handle *trans,
 	ret = split_leaf(trans, root, &orig_key, path, 0, 0);
 	BUG_ON(ret);
 
-	BUG_ON(btrfs_leaf_free_space(root, leaf) < sizeof(struct btrfs_item));
+	BUG_ON(btrfs_leaf_free_space(root->fs_info, leaf) <
+	       sizeof(struct btrfs_item));
 	leaf = path->nodes[0];
 
 split:
@@ -2311,7 +2314,7 @@ split:
 	btrfs_mark_buffer_dirty(leaf);
 
 	ret = 0;
-	if (btrfs_leaf_free_space(root, leaf) < 0) {
+	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
@@ -2407,7 +2410,7 @@ int btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
 	btrfs_mark_buffer_dirty(leaf);
 
 	ret = 0;
-	if (btrfs_leaf_free_space(root, leaf) < 0) {
+	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
@@ -2432,7 +2435,7 @@ int btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 	nritems = btrfs_header_nritems(leaf);
 	data_end = leaf_data_end(root->fs_info, leaf);
 
-	if (btrfs_leaf_free_space(root, leaf) < data_size) {
+	if (btrfs_leaf_free_space(root->fs_info, leaf) < data_size) {
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
@@ -2469,7 +2472,7 @@ int btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 	btrfs_mark_buffer_dirty(leaf);
 
 	ret = 0;
-	if (btrfs_leaf_free_space(root, leaf) < 0) {
+	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
@@ -2518,10 +2521,10 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	nritems = btrfs_header_nritems(leaf);
 	data_end = leaf_data_end(root->fs_info, leaf);
 
-	if (btrfs_leaf_free_space(root, leaf) < total_size) {
+	if (btrfs_leaf_free_space(root->fs_info, leaf) < total_size) {
 		btrfs_print_leaf(root, leaf);
 		printk("not enough freespace need %u have %d\n",
-		       total_size, btrfs_leaf_free_space(root, leaf));
+		       total_size, btrfs_leaf_free_space(root->fs_info, leaf));
 		BUG();
 	}
 
@@ -2579,7 +2582,7 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 		btrfs_fixup_low_keys(root, path, &disk_key, 1);
 	}
 
-	if (btrfs_leaf_free_space(root, leaf) < 0) {
+	if (btrfs_leaf_free_space(root->fs_info, leaf) < 0) {
 		btrfs_print_leaf(root, leaf);
 		BUG();
 	}
diff --git a/ctree.h b/ctree.h
index fa861ba0b4c3..3d13720faf69 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2662,7 +2662,8 @@ static inline int btrfs_next_item(struct btrfs_root *root,
 }
 
 int btrfs_prev_leaf(struct btrfs_root *root, struct btrfs_path *path);
-int btrfs_leaf_free_space(struct btrfs_root *root, struct extent_buffer *leaf);
+int btrfs_leaf_free_space(struct btrfs_fs_info *fs_info,
+			  struct extent_buffer *leaf);
 void btrfs_fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
 			  struct btrfs_disk_key *key, int level);
 int btrfs_set_item_key_safe(struct btrfs_root *root, struct btrfs_path *path,
diff --git a/print-tree.c b/print-tree.c
index a2f6bfc027c9..418ea5b4e7d4 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1190,7 +1190,7 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *eb)
 
 	printf("leaf %llu items %d free space %d generation %llu owner ",
 		(unsigned long long)btrfs_header_bytenr(eb), nr,
-		btrfs_leaf_free_space(root, eb),
+		btrfs_leaf_free_space(root->fs_info, eb),
 		(unsigned long long)btrfs_header_generation(eb));
 	print_objectid(stdout, btrfs_header_owner(eb), 0);
 	printf("\n");
-- 
2.16.3

