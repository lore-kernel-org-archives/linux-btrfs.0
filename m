Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ysabell.rzone.de ([81.169.144.237]:46307 "EHLO ysabell.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756424Ab2ETQGl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 May 2012 12:06:41 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 16/24] Btrfs: added helper to create new trees
Date: Sun, 20 May 2012 18:06:27 +0200
Message-Id: <19668d8091f9b035de826ac9cb4c32b757623c59.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
In-Reply-To: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
References: <cover.1337525292.git.list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Arne Jansen <sensille@gmx.net>

This creates a brand new tree. Will be used to create
the quota tree.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/disk-io.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/disk-io.h |    5 +++
 2 files changed, 82 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f51ad84..0c7ac16 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1224,6 +1224,82 @@ static struct btrfs_root *btrfs_alloc_root(struct btrfs_fs_info *fs_info)
 	return root;
 }
 
+struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
+				     struct btrfs_fs_info *fs_info,
+				     u64 objectid)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	int ret = 0;
+	u64 bytenr;
+
+	root = btrfs_alloc_root(fs_info);
+	if (!root)
+		return ERR_PTR(-ENOMEM);
+
+	__setup_root(tree_root->nodesize, tree_root->leafsize,
+		     tree_root->sectorsize, tree_root->stripesize,
+		     root, fs_info, objectid);
+	root->root_key.objectid = objectid;
+	root->root_key.type = BTRFS_ROOT_ITEM_KEY;
+	root->root_key.offset = 0;
+
+	leaf = btrfs_alloc_free_block(trans, root, root->leafsize,
+				      0, objectid, NULL, 0, 0, 0);
+	if (IS_ERR(leaf)) {
+		ret = PTR_ERR(leaf);
+		goto fail;
+	}
+
+	bytenr = leaf->start;
+	memset_extent_buffer(leaf, 0, 0, sizeof(struct btrfs_header));
+	btrfs_set_header_bytenr(leaf, leaf->start);
+	btrfs_set_header_generation(leaf, trans->transid);
+	btrfs_set_header_backref_rev(leaf, BTRFS_MIXED_BACKREF_REV);
+	btrfs_set_header_owner(leaf, objectid);
+	root->node = leaf;
+
+	write_extent_buffer(leaf, fs_info->fsid,
+			    (unsigned long)btrfs_header_fsid(leaf),
+			    BTRFS_FSID_SIZE);
+	write_extent_buffer(leaf, fs_info->chunk_tree_uuid,
+			    (unsigned long)btrfs_header_chunk_tree_uuid(leaf),
+			    BTRFS_UUID_SIZE);
+	btrfs_mark_buffer_dirty(leaf);
+
+	root->commit_root = btrfs_root_node(root);
+	root->track_dirty = 1;
+
+
+	root->root_item.flags = 0;
+	root->root_item.byte_limit = 0;
+	btrfs_set_root_bytenr(&root->root_item, leaf->start);
+	btrfs_set_root_generation(&root->root_item, trans->transid);
+	btrfs_set_root_level(&root->root_item, 0);
+	btrfs_set_root_refs(&root->root_item, 1);
+	btrfs_set_root_used(&root->root_item, leaf->len);
+	btrfs_set_root_last_snapshot(&root->root_item, 0);
+	btrfs_set_root_dirid(&root->root_item, 0);
+	root->root_item.drop_level = 0;
+
+	key.objectid = objectid;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+	ret = btrfs_insert_root(trans, tree_root, &key, &root->root_item);
+	if (ret)
+		goto fail;
+
+	btrfs_tree_unlock(leaf);
+
+fail:
+	if (ret)
+		return ERR_PTR(ret);
+
+	return root;
+}
+
 static struct btrfs_root *alloc_log_tree(struct btrfs_trans_handle *trans,
 					 struct btrfs_fs_info *fs_info)
 {
@@ -3248,7 +3324,7 @@ int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
 	return btree_read_extent_buffer_pages(root, buf, 0, parent_transid);
 }
 
-static int btree_lock_page_hook(struct page *page, void *data,
+int btree_lock_page_hook(struct page *page, void *data,
 				void (*flush_fn)(void *))
 {
 	struct inode *inode = page->mapping->host;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index ab1830a..95e147e 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -90,6 +90,11 @@ int btrfs_cleanup_transaction(struct btrfs_root *root);
 void btrfs_cleanup_one_transaction(struct btrfs_transaction *trans,
 				  struct btrfs_root *root);
 void btrfs_abort_devices(struct btrfs_root *root);
+struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
+				     struct btrfs_fs_info *fs_info,
+				     u64 objectid);
+int btree_lock_page_hook(struct page *page, void *data,
+				void (*flush_fn)(void *));
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 void btrfs_init_lockdep(void);
-- 
1.7.3.4

