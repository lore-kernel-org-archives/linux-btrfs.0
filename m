Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751883AbeAZH0T (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 02:26:19 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH v2 2/7] btrfs-progs: Use fs_info instead of root for BTRFS_NODEPTRS_PER_BLOCK
Date: Fri, 26 Jan 2018 15:26:01 +0800
Message-ID: <1516951566-21777-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
References: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Do a cleanup. Also make it consistent with kernel.
Use fs_info instead of root for BTRFS_NODEPTRS_PER_BLOCK, since
maybe in some situation we do not know root, but just know fs_info.

Changelog:
v2->v1:
To be consistent with kernel, change macro to inline function.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-check.c |  4 ++--
 ctree.c      | 18 +++++++++---------
 ctree.h      |  7 ++++---
 print-tree.c |  2 +-
 quick-test.c |  2 +-
 5 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index b118ea71..b94fab4f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2529,7 +2529,7 @@ static void account_bytes(struct btrfs_root *root, struct btrfs_path *path,
 	if (level == 0) {
 		btree_space_waste += btrfs_leaf_free_space(root, eb);
 	} else {
-		free_nrs = (BTRFS_NODEPTRS_PER_BLOCK(root) -
+		free_nrs = (BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) -
 			    btrfs_header_nritems(eb));
 		btree_space_waste += free_nrs * sizeof(struct btrfs_key_ptr);
 	}
@@ -9504,7 +9504,7 @@ static int run_next_block(struct btrfs_root *root,
 				add_pending(pending, seen, ptr, size);
 			}
 		}
-		btree_space_waste += (BTRFS_NODEPTRS_PER_BLOCK(root) -
+		btree_space_waste += (BTRFS_NODEPTRS_PER_BLOCK(fs_info) -
 				      nritems) * sizeof(struct btrfs_key_ptr);
 	}
 	total_btree_bytes += buf->len;
diff --git a/ctree.c b/ctree.c
index cb16c42c..11d207e7 100644
--- a/ctree.c
+++ b/ctree.c
@@ -429,7 +429,7 @@ btrfs_check_node(struct btrfs_root *root, struct btrfs_disk_key *parent_key,
 	u32 nritems = btrfs_header_nritems(buf);
 	enum btrfs_tree_block_status ret = BTRFS_TREE_BLOCK_INVALID_NRITEMS;
 
-	if (nritems == 0 || nritems > BTRFS_NODEPTRS_PER_BLOCK(root))
+	if (nritems == 0 || nritems > BTRFS_NODEPTRS_PER_BLOCK(root->fs_info))
 		goto fail;
 
 	ret = BTRFS_TREE_BLOCK_INVALID_PARENT_KEY;
@@ -716,7 +716,7 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		return ret;
 	}
 	if (btrfs_header_nritems(mid) >
-	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
+	    BTRFS_NODEPTRS_PER_BLOCK(fs_info) / 4)
 		return 0;
 
 	left = read_node_slot(fs_info, parent, pslot - 1);
@@ -884,7 +884,7 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	if (extent_buffer_uptodate(left)) {
 		u32 left_nr;
 		left_nr = btrfs_header_nritems(left);
-		if (left_nr >= BTRFS_NODEPTRS_PER_BLOCK(root) - 1) {
+		if (left_nr >= BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 1) {
 			wret = 1;
 		} else {
 			ret = btrfs_cow_block(trans, root, left, parent,
@@ -927,7 +927,7 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	if (extent_buffer_uptodate(right)) {
 		u32 right_nr;
 		right_nr = btrfs_header_nritems(right);
-		if (right_nr >= BTRFS_NODEPTRS_PER_BLOCK(root) - 1) {
+		if (right_nr >= BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - 1) {
 			wret = 1;
 		} else {
 			ret = btrfs_cow_block(trans, root, right,
@@ -1146,7 +1146,7 @@ again:
 			p->slots[level] = slot;
 			if ((p->search_for_split || ins_len > 0) &&
 			    btrfs_header_nritems(b) >=
-			    BTRFS_NODEPTRS_PER_BLOCK(root) - 3) {
+			    BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 3) {
 				int sret = split_node(trans, root, p, level);
 				BUG_ON(sret > 0);
 				if (sret)
@@ -1292,7 +1292,7 @@ static int push_node_left(struct btrfs_trans_handle *trans,
 
 	src_nritems = btrfs_header_nritems(src);
 	dst_nritems = btrfs_header_nritems(dst);
-	push_items = BTRFS_NODEPTRS_PER_BLOCK(root) - dst_nritems;
+	push_items = BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - dst_nritems;
 	WARN_ON(btrfs_header_generation(src) != trans->transid);
 	WARN_ON(btrfs_header_generation(dst) != trans->transid);
 
@@ -1362,7 +1362,7 @@ static int balance_node_right(struct btrfs_trans_handle *trans,
 
 	src_nritems = btrfs_header_nritems(src);
 	dst_nritems = btrfs_header_nritems(dst);
-	push_items = BTRFS_NODEPTRS_PER_BLOCK(root) - dst_nritems;
+	push_items = BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - dst_nritems;
 	if (push_items <= 0) {
 		return 1;
 	}
@@ -1490,7 +1490,7 @@ static int insert_ptr(struct btrfs_trans_handle *trans, struct btrfs_root
 	nritems = btrfs_header_nritems(lower);
 	if (slot > nritems)
 		BUG();
-	if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root))
+	if (nritems == BTRFS_NODEPTRS_PER_BLOCK(root->fs_info))
 		BUG();
 	if (slot < nritems) {
 		/* shift the items */
@@ -1539,7 +1539,7 @@ static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		ret = push_nodes_for_insert(trans, root, path, level);
 		c = path->nodes[level];
 		if (!ret && btrfs_header_nritems(c) <
-		    BTRFS_NODEPTRS_PER_BLOCK(root) - 3)
+		    BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - 3)
 			return 0;
 		if (ret < 0)
 			return ret;
diff --git a/ctree.h b/ctree.h
index 11913efa..f3964f18 100644
--- a/ctree.h
+++ b/ctree.h
@@ -356,9 +356,6 @@ struct btrfs_header {
 	u8 level;
 } __attribute__ ((__packed__));
 
-#define BTRFS_NODEPTRS_PER_BLOCK(r) (((r)->fs_info->nodesize - \
-			        sizeof(struct btrfs_header)) / \
-			        sizeof(struct btrfs_key_ptr))
 #define __BTRFS_LEAF_DATA_SIZE(bs) ((bs) - sizeof(struct btrfs_header))
 #define BTRFS_LEAF_DATA_SIZE(fs_info) \
 				(__BTRFS_LEAF_DATA_SIZE(fs_info->nodesize))
@@ -1191,6 +1188,10 @@ struct btrfs_root {
 	struct rb_node rb_node;
 };
 
+static inline u32 BTRFS_NODEPTRS_PER_BLOCK(const struct btrfs_fs_info *info)
+{
+	return BTRFS_LEAF_DATA_SIZE(info) / sizeof(struct btrfs_key_ptr);
+}
 /*
  * inode items have the data typically returned from stat and store other
  * info about object characteristics.  There is one for every file and dir in
diff --git a/print-tree.c b/print-tree.c
index d3fa8621..5f37ef3e 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1359,7 +1359,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 	printf("node %llu level %d items %d free %u generation %llu owner %llu\n",
 	       (unsigned long long)eb->start,
 	        btrfs_header_level(eb), nr,
-		(u32)BTRFS_NODEPTRS_PER_BLOCK(root) - nr,
+		(u32)BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) - nr,
 		(unsigned long long)btrfs_header_generation(eb),
 		(unsigned long long)btrfs_header_owner(eb));
 	print_uuids(eb);
diff --git a/quick-test.c b/quick-test.c
index b1e7999d..5da47c32 100644
--- a/quick-test.c
+++ b/quick-test.c
@@ -110,7 +110,7 @@ int main(int ac, char **av) {
 	printf("node %p level %d total ptrs %d free spc %lu\n", root->node,
 	        btrfs_header_level(root->node),
 		btrfs_header_nritems(root->node),
-		(unsigned long)BTRFS_NODEPTRS_PER_BLOCK(root) -
+		(unsigned long)BTRFS_NODEPTRS_PER_BLOCK(root->fs_info) -
 		btrfs_header_nritems(root->node));
 	printf("all searches good, deleting some items\n");
 	i = 0;
-- 
2.14.3



