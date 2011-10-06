From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v0 08/18] btrfs: added helper to create new trees
Date: Thu,  6 Oct 2011 17:54:18 +0200
Message-ID: <46c6261d16089fa00dbae896aeca3bfb5dd90836.1317915011.git.sensille@gmx.net>
References: <cover.1317915010.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
In-Reply-To: <cover.1317915010.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

This creates a brand new tree. Will be used to create
the quota tree.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/disk-io.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/disk-io.h |    3 ++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 074a539..672747d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1145,6 +1145,82 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 	return 0;
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
+	root = kzalloc(sizeof(struct btrfs_root), GFP_NOFS);
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
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 09a164d..b166beb 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -83,6 +83,9 @@ int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root);
+struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
+				     struct btrfs_fs_info *fs_info,
+				     u64 objectid);
 int btree_lock_page_hook(struct page *page);
 
 
-- 
1.7.3.4

