From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 31/99] btrfs: btrfs_pin_extent error push-up
Date: Wed, 23 Nov 2011 19:36:04 -0500
Message-ID: <20111124004223.408415527@suse.com>
References: <20111124003533.395674389@suse.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 btrfs_pin_extent looks up a block group and then calls pin_down_extent
 with it. If the lookup fails, it should return -ENOENT to allow callers
 to handle the error condition. For the three existing callers, it is
 a logic error if the lookup fails and a panic will occur.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h       |   11 ++++++-----
 fs/btrfs/extent-tree.c |   23 +++++++++++++++++------
 fs/btrfs/tree-log.c    |    8 ++++++--
 3 files changed, 29 insertions(+), 13 deletions(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2155,11 +2155,12 @@ int btrfs_lookup_extent(struct btrfs_roo
 int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 bytenr,
 			     u64 num_bytes, u64 *refs, u64 *flags);
-int btrfs_pin_extent(struct btrfs_root *root,
-		     u64 bytenr, u64 num, int reserved);
-int btrfs_pin_extent_for_log_replay(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root,
-				    u64 bytenr, u64 num_bytes);
+int __must_check btrfs_pin_extent(struct btrfs_root *root, u64 bytenr,
+				  u64 num, int reserved);
+int __must_check btrfs_pin_extent_for_log_replay(
+					struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
+					u64 bytenr, u64 num_bytes);
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  u64 objectid, u64 offset, u64 bytenr);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2101,8 +2101,14 @@ static int run_one_delayed_ref(struct bt
 		BUG_ON(extent_op);
 		head = btrfs_delayed_node_to_head(node);
 		if (insert_reserved) {
-			btrfs_pin_extent(root, node->bytenr,
-					 node->num_bytes, 1);
+			ret = btrfs_pin_extent(root, node->bytenr,
+					       node->num_bytes, 1);
+			if (ret)
+				btrfs_panic(root->fs_info, ret,
+					    "Cannot pin extent in range "
+					    "%llu(%llu)\n",
+					    node->bytenr, node->num_bytes);
+
 			if (head->is_data) {
 				ret = btrfs_del_csums(trans, root,
 						      node->bytenr,
@@ -4347,7 +4353,8 @@ int btrfs_pin_extent(struct btrfs_root *
 	struct btrfs_block_group_cache *cache;
 
 	cache = btrfs_lookup_block_group(root->fs_info, bytenr);
-	BUG_ON(!cache);
+	if (cache == NULL)
+		return -ENOENT;
 
 	pin_down_extent(root, cache, bytenr, num_bytes, reserved);
 
@@ -4365,7 +4372,8 @@ int btrfs_pin_extent_for_log_replay(stru
 	struct btrfs_block_group_cache *cache;
 
 	cache = btrfs_lookup_block_group(root->fs_info, bytenr);
-	BUG_ON(!cache);
+	if (cache == NULL)
+		return -ENOENT;
 
 	/*
 	 * pull in the free space cache (if any) so that our pin
@@ -4871,8 +4879,11 @@ int btrfs_free_extent(struct btrfs_trans
 	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
 		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
 		/* unlocks the pinned mutex */
-		btrfs_pin_extent(root, bytenr, num_bytes, 1);
-		ret = 0;
+		ret = btrfs_pin_extent(root, bytenr, num_bytes, 1);
+		if (ret)
+			btrfs_panic(root->fs_info, ret, "Cannot pin "
+				    "extent in range %llu(%llu)\n",
+				    bytenr, num_bytes);
 	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
 		ret = btrfs_add_delayed_tree_ref(trans, bytenr, num_bytes,
 					parent, root_objectid, (int)owner,
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -275,10 +275,14 @@ static int process_one_buffer(struct btr
 			      struct extent_buffer *eb,
 			      struct walk_control *wc, u64 gen)
 {
-	if (wc->pin)
-		btrfs_pin_extent_for_log_replay(wc->trans,
+	if (wc->pin) {
+		int ret = btrfs_pin_extent_for_log_replay(wc->trans,
 						log->fs_info->extent_root,
 						eb->start, eb->len);
+		if (ret)
+			btrfs_panic(log->fs_info, ret, "Cannot pin extent in "
+				    "range %llu(%llu)\n", eb->start, eb->len);
+	}
 
 	if (btrfs_buffer_uptodate(eb, gen)) {
 		if (wc->write)



