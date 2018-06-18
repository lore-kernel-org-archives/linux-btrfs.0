Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54941 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932762AbeFRLNW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 07:13:22 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 850EAAEAC
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 11:13:21 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Deduplicate extent_buffer init code
Date: Mon, 18 Jun 2018 14:13:19 +0300
Message-Id: <1529320399-23235-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When a new extent buffer is allocated there are a few mandatory fields
which need to be set in order for the buffer to be sane: level,
generation, bytenr, backref_rev, owner and FSID/UUID. Currently this
is open coded in the callers of btrfs_alloc_tree_block, meaning it's
fairly high in the abstraction hierarchy of operations. This patch
solves this by simply moving this init code in btrfs_init_new_buffer,
since this is the function which initializes a newly allocated
extent buffer. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c       | 29 +----------------------------
 fs/btrfs/disk-io.c     | 14 --------------
 fs/btrfs/extent-tree.c | 16 ++++++++++++----
 fs/btrfs/ioctl.c       |  8 --------
 4 files changed, 13 insertions(+), 54 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 4bc326df472e..6879697520d5 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3359,17 +3359,7 @@ static noinline int insert_new_root(struct btrfs_trans_handle *trans,
 
 	root_add_used(root, fs_info->nodesize);
 
-	memzero_extent_buffer(c, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_nritems(c, 1);
-	btrfs_set_header_level(c, level);
-	btrfs_set_header_bytenr(c, c->start);
-	btrfs_set_header_generation(c, trans->transid);
-	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
-	btrfs_set_header_owner(c, root->root_key.objectid);
-
-	write_extent_buffer_fsid(c, fs_info->fsid);
-	write_extent_buffer_chunk_tree_uuid(c, fs_info->chunk_tree_uuid);
-
 	btrfs_set_node_key(c, &lower_key, 0);
 	btrfs_set_node_blockptr(c, 0, lower->start);
 	lower_gen = btrfs_header_generation(lower);
@@ -3498,15 +3488,7 @@ static noinline int split_node(struct btrfs_trans_handle *trans,
 		return PTR_ERR(split);
 
 	root_add_used(root, fs_info->nodesize);
-
-	memzero_extent_buffer(split, 0, sizeof(struct btrfs_header));
-	btrfs_set_header_level(split, btrfs_header_level(c));
-	btrfs_set_header_bytenr(split, split->start);
-	btrfs_set_header_generation(split, trans->transid);
-	btrfs_set_header_backref_rev(split, BTRFS_MIXED_BACKREF_REV);
-	btrfs_set_header_owner(split, root->root_key.objectid);
-	write_extent_buffer_fsid(split, fs_info->fsid);
-	write_extent_buffer_chunk_tree_uuid(split, fs_info->chunk_tree_uuid);
+	ASSERT(btrfs_header_level(c) == level);
 
 	ret = tree_mod_log_eb_copy(fs_info, split, c, 0, mid, c_nritems - mid);
 	if (ret) {
@@ -4292,15 +4274,6 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 
 	root_add_used(root, fs_info->nodesize);
 
-	memzero_extent_buffer(right, 0, sizeof(struct btrfs_header));
-	btrfs_set_header_bytenr(right, right->start);
-	btrfs_set_header_generation(right, trans->transid);
-	btrfs_set_header_backref_rev(right, BTRFS_MIXED_BACKREF_REV);
-	btrfs_set_header_owner(right, root->root_key.objectid);
-	btrfs_set_header_level(right, 0);
-	write_extent_buffer_fsid(right, fs_info->fsid);
-	write_extent_buffer_chunk_tree_uuid(right, fs_info->chunk_tree_uuid);
-
 	if (split == 0) {
 		if (mid <= slot) {
 			btrfs_set_header_nritems(right, 0);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 205092dc9390..80a46aabf14c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1292,15 +1292,7 @@ struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 		goto fail;
 	}
 
-	memzero_extent_buffer(leaf, 0, sizeof(struct btrfs_header));
-	btrfs_set_header_bytenr(leaf, leaf->start);
-	btrfs_set_header_generation(leaf, trans->transid);
-	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
-	btrfs_set_header_owner(leaf, objectid);
 	root->node = leaf;
-
-	write_extent_buffer_fsid(leaf, fs_info->fsid);
-	write_extent_buffer_chunk_tree_uuid(leaf, fs_info->chunk_tree_uuid);
 	btrfs_mark_buffer_dirty(leaf);
 
 	root->commit_root = btrfs_root_node(root);
@@ -1374,14 +1366,8 @@ static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 		return ERR_CAST(leaf);
 	}
 
-	memzero_extent_buffer(leaf, 0, sizeof(struct btrfs_header));
-	btrfs_set_header_bytenr(leaf, leaf->start);
-	btrfs_set_header_generation(leaf, trans->transid);
-	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
-	btrfs_set_header_owner(leaf, BTRFS_TREE_LOG_OBJECTID);
 	root->node = leaf;
 
-	write_extent_buffer_fsid(root->node, fs_info->fsid);
 	btrfs_mark_buffer_dirty(root->node);
 	btrfs_tree_unlock(root->node);
 	return root;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fb44ec27bdfd..9cafa9c0c924 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8318,7 +8318,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 
 static struct extent_buffer *
 btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
-		      u64 bytenr, int level)
+		      u64 bytenr, int level, u64 owner)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *buf;
@@ -8327,7 +8327,6 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	if (IS_ERR(buf))
 		return buf;
 
-	btrfs_set_header_generation(buf, trans->transid);
 	btrfs_set_buffer_lockdep_class(root->root_key.objectid, buf, level);
 	btrfs_tree_lock(buf);
 	clean_tree_block(fs_info, buf);
@@ -8336,6 +8335,14 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_lock_blocking(buf);
 	set_extent_buffer_uptodate(buf);
 
+	memzero_extent_buffer(buf, 0, sizeof(struct btrfs_header));
+	btrfs_set_header_level(buf, level);
+	btrfs_set_header_bytenr(buf, buf->start);
+	btrfs_set_header_generation(buf, trans->transid);
+	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
+	btrfs_set_header_owner(buf, owner);
+	write_extent_buffer_fsid(buf, fs_info->fsid);
+	write_extent_buffer_chunk_tree_uuid(buf, fs_info->chunk_tree_uuid);
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
 		buf->log_index = root->log_transid % 2;
 		/*
@@ -8444,7 +8451,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 	if (btrfs_is_testing(fs_info)) {
 		buf = btrfs_init_new_buffer(trans, root, root->alloc_bytenr,
-					    level);
+					    level, root_objectid);
 		if (!IS_ERR(buf))
 			root->alloc_bytenr += blocksize;
 		return buf;
@@ -8460,7 +8467,8 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out_unuse;
 
-	buf = btrfs_init_new_buffer(trans, root, ins.objectid, level);
+	buf = btrfs_init_new_buffer(trans, root, ins.objectid, level,
+				    root_objectid);
 	if (IS_ERR(buf)) {
 		ret = PTR_ERR(buf);
 		goto out_free_reserved;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 607da5053193..5c7eafe6b232 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -616,14 +616,6 @@ static noinline int create_subvol(struct inode *dir,
 		goto fail;
 	}
 
-	memzero_extent_buffer(leaf, 0, sizeof(struct btrfs_header));
-	btrfs_set_header_bytenr(leaf, leaf->start);
-	btrfs_set_header_generation(leaf, trans->transid);
-	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
-	btrfs_set_header_owner(leaf, objectid);
-
-	write_extent_buffer_fsid(leaf, fs_info->fsid);
-	write_extent_buffer_chunk_tree_uuid(leaf, fs_info->chunk_tree_uuid);
 	btrfs_mark_buffer_dirty(leaf);
 
 	inode_item = &root_item->inode;
-- 
2.7.4

