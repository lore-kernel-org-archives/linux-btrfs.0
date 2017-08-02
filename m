Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38851 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751739AbdHBTyJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 15:54:09 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0561FAE24
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Aug 2017 19:54:08 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: pass fs_info to routines that always take tree_root
Date: Wed,  2 Aug 2017 15:54:53 -0400
Message-Id: <20170802195453.32471-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_find_root and btrfs_del_root always use the tree_root.  Let's pass
fs_info instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h           |  7 ++++---
 fs/btrfs/disk-io.c         |  2 +-
 fs/btrfs/extent-tree.c     |  4 ++--
 fs/btrfs/free-space-tree.c |  2 +-
 fs/btrfs/qgroup.c          |  3 +--
 fs/btrfs/root-tree.c       | 15 +++++++++------
 6 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 3f3eb7b17cac..eed7cc991a80 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2973,8 +2973,8 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
 		       const char *name, int name_len);
-int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   const struct btrfs_key *key);
+int btrfs_del_root(struct btrfs_trans_handle *trans,
+		   struct btrfs_fs_info *fs_info, const struct btrfs_key *key);
 int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key,
 		      struct btrfs_root_item *item);
@@ -2982,7 +2982,8 @@ int __must_check btrfs_update_root(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
 				   struct btrfs_key *key,
 				   struct btrfs_root_item *item);
-int btrfs_find_root(struct btrfs_root *root, const struct btrfs_key *search_key,
+int btrfs_find_root(struct btrfs_fs_info *fs_info,
+		    const struct btrfs_key *search_key,
 		    struct btrfs_path *path, struct btrfs_root_item *root_item,
 		    struct btrfs_key *root_key);
 int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 080e2ebb8aa0..ea1959937875 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1581,7 +1581,7 @@ static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 
 	__setup_root(root, fs_info, key->objectid);
 
-	ret = btrfs_find_root(tree_root, key, path,
+	ret = btrfs_find_root(fs_info, key, path,
 			      &root->root_item, &root->root_key);
 	if (ret) {
 		if (ret > 0)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 82d53a7b6652..12fa33accdcc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9192,14 +9192,14 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	if (err)
 		goto out_end_trans;
 
-	ret = btrfs_del_root(trans, tree_root, &root->root_key);
+	ret = btrfs_del_root(trans, fs_info, &root->root_key);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_end_trans;
 	}
 
 	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
-		ret = btrfs_find_root(tree_root, &root->root_key, path,
+		ret = btrfs_find_root(fs_info, &root->root_key, path,
 				      NULL, NULL);
 		if (ret < 0) {
 			btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index a5e34de06c2f..684f12247db7 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1257,7 +1257,7 @@ int btrfs_clear_free_space_tree(struct btrfs_fs_info *fs_info)
 	if (ret)
 		goto abort;
 
-	ret = btrfs_del_root(trans, tree_root, &free_space_root->root_key);
+	ret = btrfs_del_root(trans, fs_info, &free_space_root->root_key);
 	if (ret)
 		goto abort;
 
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 4ce351efe281..ba60523a443c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -946,7 +946,6 @@ int btrfs_quota_enable(struct btrfs_trans_handle *trans,
 int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *quota_root;
 	int ret = 0;
 
@@ -968,7 +967,7 @@ int btrfs_quota_disable(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	ret = btrfs_del_root(trans, tree_root, &quota_root->root_key);
+	ret = btrfs_del_root(trans, fs_info, &quota_root->root_key);
 	if (ret)
 		goto out;
 
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 460db0cb2d07..31c0e7265f44 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -62,7 +62,7 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
 
 /*
  * btrfs_find_root - lookup the root by the key.
- * root: the root of the root tree
+ * fs_info: the fs_info for the file system to search
  * search_key: the key to search
  * path: the path we search
  * root_item: the root item of the tree we look for
@@ -74,7 +74,8 @@ static void btrfs_read_root_item(struct extent_buffer *eb, int slot,
  *
  * If we find something return 0, otherwise > 0, < 0 on error.
  */
-int btrfs_find_root(struct btrfs_root *root, const struct btrfs_key *search_key,
+int btrfs_find_root(struct btrfs_fs_info *fs_info,
+		    const struct btrfs_key *search_key,
 		    struct btrfs_path *path, struct btrfs_root_item *root_item,
 		    struct btrfs_key *root_key)
 {
@@ -83,7 +84,8 @@ int btrfs_find_root(struct btrfs_root *root, const struct btrfs_key *search_key,
 	int ret;
 	int slot;
 
-	ret = btrfs_search_slot(NULL, root, search_key, path, 0, 0);
+	ret = btrfs_search_slot(NULL, fs_info->tree_root, search_key,
+				path, 0, 0);
 	if (ret < 0)
 		return ret;
 
@@ -335,10 +337,11 @@ int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 	return err;
 }
 
-/* drop the root item for 'key' from 'root' */
-int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		   const struct btrfs_key *key)
+/* drop the root item for 'key' from the tree root */
+int btrfs_del_root(struct btrfs_trans_handle *trans,
+		   struct btrfs_fs_info *fs_info, const struct btrfs_key *key)
 {
+	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_path *path;
 	int ret;
 
-- 
2.11.0

