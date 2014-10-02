Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbaJBQws (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Oct 2014 12:52:48 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 7B52FAAF3
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Oct 2014 16:52:47 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/6] btrfs: remove blocksize from btrfs_alloc_free_block and rename
Date: Thu,  2 Oct 2014 18:52:47 +0200
Message-Id: <4d75f8a9c87b843c8ded15b82b8d137b9724cccc.1412265713.git.dsterba@suse.cz>
In-Reply-To: <cover.1412265712.git.dsterba@suse.cz>
References: <cover.1412265712.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rename to btrfs_alloc_tree_block as it fits to the alloc/find/free +
_tree_block family. The parameter blocksize was set to the metadata
block size, directly or indirectly.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ctree.c       | 26 +++++++++++---------------
 fs/btrfs/ctree.h       |  6 +++---
 fs/btrfs/disk-io.c     |  8 +++-----
 fs/btrfs/extent-tree.c |  5 +++--
 fs/btrfs/ioctl.c       |  3 +--
 5 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2fb4ab659a0f..d498982bd202 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -258,9 +258,8 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_node_key(buf, &disk_key, 0);
 
-	cow = btrfs_alloc_free_block(trans, root, buf->len, 0,
-				     new_root_objectid, &disk_key, level,
-				     buf->start, 0);
+	cow = btrfs_alloc_tree_block(trans, root, 0, new_root_objectid,
+			&disk_key, level, buf->start, 0);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
@@ -1133,9 +1132,9 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	} else
 		parent_start = 0;
 
-	cow = btrfs_alloc_free_block(trans, root, buf->len, parent_start,
-				     root->root_key.objectid, &disk_key,
-				     level, search_start, empty_size);
+	cow = btrfs_alloc_tree_block(trans, root, parent_start,
+			root->root_key.objectid, &disk_key, level,
+			search_start, empty_size);
 	if (IS_ERR(cow))
 		return PTR_ERR(cow);
 
@@ -3355,9 +3354,8 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_node_key(lower, &lower_key, 0);
 
-	c = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
-				   root->root_key.objectid, &lower_key,
-				   level, root->node->start, 0);
+	c = btrfs_alloc_tree_block(trans, root, 0, root->root_key.objectid,
+				   &lower_key, level, root->node->start, 0);
 	if (IS_ERR(c))
 		return PTR_ERR(c);
 
@@ -3495,9 +3493,8 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 	mid = (c_nritems + 1) / 2;
 	btrfs_node_key(c, &disk_key, mid);
 
-	split = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
-					root->root_key.objectid,
-					&disk_key, level, c->start, 0);
+	split = btrfs_alloc_tree_block(trans, root, 0, root->root_key.objectid,
+			&disk_key, level, c->start, 0);
 	if (IS_ERR(split))
 		return PTR_ERR(split);
 
@@ -4275,9 +4272,8 @@ again:
 	else
 		btrfs_item_key(l, &disk_key, mid);
 
-	right = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
-					root->root_key.objectid,
-					&disk_key, 0, l->start, 0);
+	right = btrfs_alloc_tree_block(trans, root, 0, root->root_key.objectid,
+			&disk_key, 0, l->start, 0);
 	if (IS_ERR(right))
 		return PTR_ERR(right);
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 089f6da09411..3073b8876bca 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3290,9 +3290,9 @@ struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 u64 bytenr);
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int get_block_group_index(struct btrfs_block_group_cache *cache);
-struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
-					struct btrfs_root *root, u32 blocksize,
-					u64 parent, u64 root_objectid,
+struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root, u64 parent,
+					u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size);
 void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e0293d2fbb3a..2e5d460d4e0c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1324,8 +1324,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
 	root->root_key.offset = 0;
 
-	leaf = btrfs_alloc_free_block(trans, root, root->nodesize,
-				      0, objectid, NULL, 0, 0, 0);
+	leaf = btrfs_alloc_tree_block(trans, root, 0, objectid, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
 		leaf = NULL;
@@ -1412,9 +1411,8 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 	 * updated (along with back refs to the log tree).
 	 */
 
-	leaf = btrfs_alloc_free_block(trans, root, root->nodesize, 0,
-				      BTRFS_TREE_LOG_OBJECTID, NULL,
-				      0, 0, 0);
+	leaf = btrfs_alloc_tree_block(trans, root, 0, BTRFS_TREE_LOG_OBJECTID,
+			NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		kfree(root);
 		return ERR_CAST(leaf);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d9a90da93302..0ba42eb96775 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7322,8 +7322,8 @@ static void unuse_block_rsv(struct btrfs_fs_info *fs_info,
  *
  * returns the tree buffer or NULL.
  */
-struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
-					struct btrfs_root *root, u32 blocksize,
+struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
+					struct btrfs_root *root,
 					u64 parent, u64 root_objectid,
 					struct btrfs_disk_key *key, int level,
 					u64 hint, u64 empty_size)
@@ -7333,6 +7333,7 @@ struct extent_buffer *btrfs_alloc_free_block(struct btrfs_trans_handle *trans,
 	struct extent_buffer *buf;
 	u64 flags = 0;
 	int ret;
+	u32 blocksize = root->nodesize;
 	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
 						 SKINNY_METADATA);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0ff212757b95..2fc48905ccf5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -480,8 +480,7 @@ static noinline int create_subvol(struct inode *dir,
 	if (ret)
 		goto fail;
 
-	leaf = btrfs_alloc_free_block(trans, root, root->nodesize,
-				      0, objectid, NULL, 0, 0, 0);
+	leaf = btrfs_alloc_tree_block(trans, root, 0, objectid, NULL, 0, 0, 0);
 	if (IS_ERR(leaf)) {
 		ret = PTR_ERR(leaf);
 		goto fail;
-- 
1.8.4.5

