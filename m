Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33940 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932081AbeF2I4p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 04:56:45 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6EA5CAD67
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2018 08:56:44 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/14] btrfs: simplify pointer chasing of local fs_info variables
Date: Fri, 29 Jun 2018 10:56:42 +0200
Message-Id: <8ae320455b2bffc1154efb650cded3e80d7ca9ee.1530262400.git.dsterba@suse.com>
In-Reply-To: <cover.1530262400.git.dsterba@suse.com>
References: <cover.1530262400.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Functions that get btrfs inode can simply reach the fs_info by
dereferencing the root and this looks a bit more straightforward
compared to the btrfs_sb(...) indirection.

If the transaction handle is available and not NULL it's used instead.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/delayed-inode.c    |  4 ++--
 fs/btrfs/disk-io.c          |  2 +-
 fs/btrfs/extent-tree.c      |  6 +++---
 fs/btrfs/file-item.c        |  2 +-
 fs/btrfs/file.c             | 14 +++++++-------
 fs/btrfs/free-space-cache.c |  7 ++-----
 fs/btrfs/inode.c            |  6 +++---
 fs/btrfs/tree-log.c         |  6 +++---
 8 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index fe6caa7e698b..596d2af0c8aa 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1222,7 +1222,7 @@ int btrfs_commit_inode_delayed_items(struct btrfs_trans_handle *trans,
 
 int btrfs_commit_inode_delayed_inode(struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_delayed_node *delayed_node = btrfs_get_delayed_node(inode);
 	struct btrfs_path *path;
@@ -1837,7 +1837,7 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 
 int btrfs_delayed_delete_inode_ref(struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_delayed_node *delayed_node;
 
 	/*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 205092dc9390..7ee825b96187 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -212,7 +212,7 @@ struct extent_map *btree_get_extent(struct btrfs_inode *inode,
 		struct page *page, size_t pg_offset, u64 start, u64 len,
 		int create)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct extent_map_tree *em_tree = &inode->extent_tree;
 	struct extent_map *em;
 	int ret;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 3d9fe58c0080..59e42481a515 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6019,7 +6019,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned nr_extents;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
@@ -6092,7 +6092,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes)
 void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
 				     bool qgroup_free)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
 	num_bytes = ALIGN(num_bytes, fs_info->sectorsize);
 	spin_lock(&inode->lock);
@@ -6121,7 +6121,7 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
 void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes,
 				    bool qgroup_free)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index f9dd6d1836a3..ec0a1acbe783 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -922,7 +922,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 				     const bool new_inline,
 				     struct extent_map *em)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_root *root = inode->root;
 	struct extent_buffer *leaf = path->nodes[0];
 	const int slot = path->slots[0];
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f660ba1e5e58..11e43e69d12f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -83,7 +83,7 @@ static int __compare_inode_defrag(struct inode_defrag *defrag1,
 static int __btrfs_add_inode_defrag(struct btrfs_inode *inode,
 				    struct inode_defrag *defrag)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct inode_defrag *entry;
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -135,8 +135,8 @@ static inline int __need_auto_defrag(struct btrfs_fs_info *fs_info)
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 			   struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	struct btrfs_root *root = inode->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct inode_defrag *defrag;
 	u64 transid;
 	int ret;
@@ -185,7 +185,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 static void btrfs_requeue_inode_defrag(struct btrfs_inode *inode,
 				       struct inode_defrag *defrag)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int ret;
 
 	if (!__need_auto_defrag(fs_info))
@@ -1133,7 +1133,7 @@ static int extent_mergeable(struct extent_buffer *leaf, int slot,
 int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 			      struct btrfs_inode *inode, u64 start, u64 end)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = inode->root;
 	struct extent_buffer *leaf;
 	struct btrfs_path *path;
@@ -1470,7 +1470,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 				u64 *lockstart, u64 *lockend,
 				struct extent_state **cached_state)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	u64 start_pos;
 	u64 last_pos;
 	int i;
@@ -1526,7 +1526,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct page **pages,
 static noinline int check_can_nocow(struct btrfs_inode *inode, loff_t pos,
 				    size_t *write_bytes)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct btrfs_root *root = inode->root;
 	struct btrfs_ordered_extent *ordered;
 	u64 lockstart, lockend;
@@ -2310,7 +2310,7 @@ static int fill_holes(struct btrfs_trans_handle *trans,
 		struct btrfs_inode *inode,
 		struct btrfs_path *path, u64 offset, u64 end)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_root *root = inode->root;
 	struct extent_buffer *leaf;
 	struct btrfs_file_extent_item *fi;
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index d5f80cb300be..38ad5e9f0bf2 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -655,7 +655,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 				   struct btrfs_free_space_ctl *ctl,
 				   struct btrfs_path *path, u64 offset)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_free_space_header *header;
 	struct extent_buffer *leaf;
 	struct btrfs_io_ctl io_ctl;
@@ -1123,13 +1123,10 @@ static int __btrfs_wait_cache_io(struct btrfs_root *root,
 {
 	int ret;
 	struct inode *inode = io_ctl->inode;
-	struct btrfs_fs_info *fs_info;
 
 	if (!inode)
 		return 0;
 
-	fs_info = btrfs_sb(inode->i_sb);
-
 	/* Flush the dirty pages in the cache file. */
 	ret = flush_dirty_cache(inode);
 	if (ret)
@@ -1145,7 +1142,7 @@ static int __btrfs_wait_cache_io(struct btrfs_root *root,
 		BTRFS_I(inode)->generation = 0;
 		if (block_group) {
 #ifdef DEBUG
-			btrfs_err(fs_info,
+			btrfs_err(root->fs_info,
 				  "failed to write free space cache for block group %llu",
 				  block_group->key.objectid);
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a27e68405aa3..f30608dc038b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1752,7 +1752,7 @@ static void btrfs_add_delalloc_inodes(struct btrfs_root *root,
 void __btrfs_del_delalloc_inode(struct btrfs_root *root,
 				struct btrfs_inode *inode)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	if (!list_empty(&inode->delalloc_inodes)) {
 		list_del_init(&inode->delalloc_inodes);
@@ -6419,7 +6419,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
 		   const char *name, int name_len, int add_backref, u64 index)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 	struct btrfs_key key;
 	struct btrfs_root *root = parent_inode->root;
@@ -6847,7 +6847,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 	    size_t pg_offset, u64 start, u64 len,
 		int create)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	int ret;
 	int err = 0;
 	u64 extent_start = 0;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f8220ec02036..76f906ffc78f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3756,7 +3756,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			       int start_slot, int nr, int inode_only,
 			       u64 logged_isize)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	unsigned long src_offset;
 	unsigned long dst_offset;
 	struct btrfs_root *log = inode->root->log_root;
@@ -5585,7 +5585,7 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 				 struct btrfs_inode *inode,
 				 struct btrfs_log_ctx *ctx)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret;
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -6120,7 +6120,7 @@ int btrfs_log_new_name(struct btrfs_trans_handle *trans,
 			struct btrfs_inode *inode, struct btrfs_inode *old_dir,
 			struct dentry *parent)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 
 	/*
 	 * this will force the logging code to walk the dentry chain
-- 
2.17.1

