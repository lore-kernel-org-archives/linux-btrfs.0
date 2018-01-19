Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42750 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754104AbeASFiC (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 19 Jan 2018 00:38:02 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 16/16] btrfs-progs: check/lowmem: Cleanup unnecessary _v2 suffix
Date: Fri, 19 Jan 2018 13:37:31 +0800
Message-Id: <20180119053731.10795-17-wqu@suse.com>
In-Reply-To: <20180119053731.10795-1-wqu@suse.com>
References: <20180119053731.10795-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There used to be some functions with _v2 suffix to distinguish them from
original mode similar functions.

However now moved lowmem code to their own check/lowmem.[ch], cleanup
such _v2 suffixes, and for functions really needs to be distinguished
from original mode (exported functions), change the _v2 suffix to
_lowmem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/lowmem.c | 46 +++++++++++++++++++++++-----------------------
 check/lowmem.h |  4 ++--
 check/main.c   |  4 ++--
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/check/lowmem.c b/check/lowmem.c
index 7fb2016edb4a..fdd4d624881e 100644
--- a/check/lowmem.c
+++ b/check/lowmem.c
@@ -28,8 +28,8 @@
 #include "check/common.h"
 #include "check/lowmem.h"
 
-static int calc_extent_flag_v2(struct btrfs_root *root, struct extent_buffer *eb,
-			       u64 *flags_ret)
+static int calc_extent_flag(struct btrfs_root *root, struct extent_buffer *eb,
+			    u64 *flags_ret)
 {
 	struct btrfs_root *extent_root = root->fs_info->extent_root;
 	struct btrfs_root_item *ri = &root->root_item;
@@ -225,7 +225,7 @@ static int update_nodes_refs(struct btrfs_root *root, u64 bytenr,
 	}
 
 	if (check_all && eb) {
-		calc_extent_flag_v2(root, eb, &flags);
+		calc_extent_flag(root, eb, &flags);
 		if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF)
 			nrefs->full_backref[level] = 1;
 	}
@@ -2084,8 +2084,8 @@ out:
  * Returns <0  Fatal error, must exit the whole check
  * Returns 0   No errors found
  */
-static int process_one_leaf_v2(struct btrfs_root *root, struct btrfs_path *path,
-			       struct node_refs *nrefs, int *level, int ext_ref)
+static int process_one_leaf(struct btrfs_root *root, struct btrfs_path *path,
+			    struct node_refs *nrefs, int *level, int ext_ref)
 {
 	struct extent_buffer *cur = path->nodes[0];
 	struct btrfs_key key;
@@ -3898,10 +3898,10 @@ out:
  * Returns <0  Fatal error, must exit the whole check
  * Returns 0   No errors found
  */
-static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, struct btrfs_path *path,
-			     int *level, struct node_refs *nrefs, int ext_ref,
-			     int check_all)
+static int walk_down_tree(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *root, struct btrfs_path *path,
+			  int *level, struct node_refs *nrefs, int ext_ref,
+			  int check_all)
 {
 	enum btrfs_tree_block_status status;
 	u64 bytenr;
@@ -3971,8 +3971,8 @@ static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
 
 			ret = 0;
 			if (!check_all)
-				ret = process_one_leaf_v2(root, path, nrefs,
-							  level, ext_ref);
+				ret = process_one_leaf(root, path, nrefs,
+						       level, ext_ref);
 			else
 				ret = check_leaf_items(trans, root, path,
 					       nrefs, account_file_data);
@@ -3996,7 +3996,7 @@ static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
 		if (ret < 0)
 			break;
 		/*
-		 * check all trees in check_chunks_and_extent_v2
+		 * check all trees in check_chunks_and_extent
 		 * check shared node once in check_fs_roots
 		 */
 		if (!check_all && !nrefs->need_check[*level - 1]) {
@@ -4049,8 +4049,8 @@ static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
 	return err;
 }
 
-static int walk_up_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
-			   int *level)
+static int walk_up_tree(struct btrfs_root *root, struct btrfs_path *path,
+			int *level)
 {
 	int i;
 	struct extent_buffer *leaf;
@@ -4203,7 +4203,7 @@ out:
 }
 
 /*
- * This function calls walk_down_tree_v2 and walk_up_tree_v2 to check tree
+ * This function calls walk_down_tree and walk_up_tree to check tree
  * blocks and integrity of fs tree items.
  *
  * @root:         the root of the tree to be checked.
@@ -4260,8 +4260,8 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 	}
 
 	while (1) {
-		ret = walk_down_tree_v2(trans, root, &path, &level, &nrefs,
-					ext_ref, check_all);
+		ret = walk_down_tree(trans, root, &path, &level, &nrefs,
+				     ext_ref, check_all);
 
 		err |= !!ret;
 
@@ -4271,7 +4271,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 			break;
 		}
 
-		ret = walk_up_tree_v2(root, &path, &level);
+		ret = walk_up_tree(root, &path, &level);
 		if (ret != 0) {
 			/* Normal exit, reset ret to err */
 			ret = err;
@@ -4293,7 +4293,7 @@ out:
  * Return 0 if no error found.
  * Return <0 for error.
  */
-static int check_fs_root_v2(struct btrfs_root *root, unsigned int ext_ref)
+static int check_fs_root(struct btrfs_root *root, unsigned int ext_ref)
 {
 	reset_cached_block_groups(root->fs_info);
 	return check_btrfs_root(NULL, root, ext_ref, 0);
@@ -4393,12 +4393,12 @@ out:
 /*
  * Check all fs/file tree in low_memory mode.
  *
- * 1. for fs tree root item, call check_fs_root_v2()
+ * 1. for fs tree root item, call check_fs_root()
  * 2. for fs tree root ref/backref, call check_root_ref()
  *
  * Return 0 if no error occurred.
  */
-int check_fs_roots_v2(struct btrfs_fs_info *fs_info)
+int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *cur_root = NULL;
@@ -4449,7 +4449,7 @@ int check_fs_roots_v2(struct btrfs_fs_info *fs_info)
 				goto next;
 			}
 
-			ret = check_fs_root_v2(cur_root, ext_ref);
+			ret = check_fs_root(cur_root, ext_ref);
 			err |= ret;
 
 			if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
@@ -4477,7 +4477,7 @@ out:
 /*
  * Low memory usage version check_chunks_and_extents.
  */
-int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
+int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_path path;
diff --git a/check/lowmem.h b/check/lowmem.h
index d1051a0b37ec..39deff0cc26c 100644
--- a/check/lowmem.h
+++ b/check/lowmem.h
@@ -61,7 +61,7 @@
 #define ACCOUNTING_MISMATCH	(1 << 7) /* Used space accounting error */
 #define CHUNK_TYPE_MISMATCH	(1 << 8)
 
-int check_fs_roots_v2(struct btrfs_fs_info *fs_info);
-int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info);
+int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info);
+int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info);
 
 #endif
diff --git a/check/main.c b/check/main.c
index ac4e6655f9b9..77bbc7504d31 100644
--- a/check/main.c
+++ b/check/main.c
@@ -3524,7 +3524,7 @@ static int do_check_fs_roots(struct btrfs_fs_info *fs_info,
 	if (!ctx.progress_enabled)
 		fprintf(stderr, "checking fs roots\n");
 	if (check_mode == CHECK_MODE_LOWMEM)
-		ret = check_fs_roots_v2(fs_info);
+		ret = check_fs_roots_lowmem(fs_info);
 	else
 		ret = check_fs_roots(fs_info, root_cache);
 
@@ -8310,7 +8310,7 @@ static int do_check_chunks_and_extents(struct btrfs_fs_info *fs_info)
 	if (!ctx.progress_enabled)
 		fprintf(stderr, "checking extents\n");
 	if (check_mode == CHECK_MODE_LOWMEM)
-		ret = check_chunks_and_extents_v2(fs_info);
+		ret = check_chunks_and_extents_lowmem(fs_info);
 	else
 		ret = check_chunks_and_extents(fs_info);
 
-- 
2.15.1

