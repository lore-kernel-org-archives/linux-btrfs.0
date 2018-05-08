Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42480 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbeEHGcI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 May 2018 02:32:08 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9C933AF4B
        for <linux-btrfs@vger.kernel.org>; Tue,  8 May 2018 06:32:07 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RESEND 05/12] btrfs-progs: ctree: Introduce function to create an empty tree
Date: Tue,  8 May 2018 14:31:49 +0800
Message-Id: <20180508063156.24665-6-wqu@suse.com>
In-Reply-To: <20180508063156.24665-1-wqu@suse.com>
References: <20180508063156.24665-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, btrfs_create_tree(), to create an empty tree.

Currently, there is only one caller to create new tree, namely
data reloc tree in mkfs.
However it's copying fs tree to create a new root.

This copy fs tree method is not a good idea if we only need an empty
tree.

So here introduce a new function, btrfs_create_tree() to create new
tree.
Which will handle the following things:
1) New tree root leaf
   Using generic tree allocation

2) New root item in tree root

3) Modify special tree root pointers in fs_info
   Only quota_root is supported yet, but can be expended easily

This patch provides the basis to implement quota support in mkfs.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ctree.h |   2 ++
 2 files changed, 111 insertions(+)

diff --git a/ctree.c b/ctree.c
index e26a1c29bb75..4ff1e1d22e0e 100644
--- a/ctree.c
+++ b/ctree.c
@@ -23,6 +23,7 @@
 #include "internal.h"
 #include "sizes.h"
 #include "messages.h"
+#include "utils.h"
 
 static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 		      *root, struct btrfs_path *path, int level);
@@ -137,6 +138,114 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
+/*
+ * Create a new tree root, with root objectid set to @objectid.
+ *
+ * NOTE: Doesn't support tree with non-zero offset, like tree reloc tree.
+ */
+int btrfs_create_root(struct btrfs_trans_handle *trans,
+		      struct btrfs_fs_info *fs_info, u64 objectid)
+{
+	struct extent_buffer *node;
+	struct btrfs_root *new_root;
+	struct btrfs_disk_key disk_key;
+	struct btrfs_key location;
+	struct btrfs_root_item root_item = { 0 };
+	int ret;
+
+	new_root = malloc(sizeof(*new_root));
+	if (!new_root)
+		return -ENOMEM;
+
+	btrfs_setup_root(new_root, fs_info, objectid);
+	if (!is_fstree(objectid))
+		new_root->track_dirty = 1;
+	add_root_to_dirty_list(new_root);
+
+	new_root->objectid = objectid;
+	new_root->root_key.objectid = objectid;
+	new_root->root_key.type = BTRFS_ROOT_ITEM_KEY;
+	new_root->root_key.offset = 0;
+
+	node = btrfs_alloc_free_block(trans, new_root, fs_info->nodesize,
+				      objectid, &disk_key, 0, 0, 0);
+	if (IS_ERR(node)) {
+		ret = PTR_ERR(node);
+		error("failed to create root node for tree %llu: %d (%s)",
+		      objectid, ret, strerror(-ret));
+		return ret;
+	}
+	new_root->node = node;
+
+	btrfs_set_header_generation(node, trans->transid);
+	btrfs_set_header_backref_rev(node, BTRFS_MIXED_BACKREF_REV);
+	btrfs_clear_header_flag(node, BTRFS_HEADER_FLAG_RELOC |
+				      BTRFS_HEADER_FLAG_WRITTEN);
+	btrfs_set_header_owner(node, objectid);
+	btrfs_set_header_nritems(node, 0);
+	btrfs_set_header_level(node, 0);
+	write_extent_buffer(node, fs_info->fsid, btrfs_header_fsid(),
+			    BTRFS_FSID_SIZE);
+	ret = btrfs_inc_ref(trans, new_root, node, 0);
+	if (ret < 0)
+		goto free;
+
+	/*
+	 * Special tree roots may need to modify pointers in @fs_info
+	 * Only quota is supported yet.
+	 */
+	switch (objectid) {
+	case BTRFS_QUOTA_TREE_OBJECTID:
+		if (fs_info->quota_root) {
+			error("quota root already exists");
+			ret = -EEXIST;
+			goto free;
+		}
+		fs_info->quota_root = new_root;
+		fs_info->quota_enabled = 1;
+		break;
+	/*
+	 * Essential trees can't be created by this function, yet.
+	 * As we expect such skeleton exists, or a lot of functions like
+	 * btrfs_alloc_free_block() doesn't work at all
+	 */
+	case BTRFS_ROOT_TREE_OBJECTID:
+	case BTRFS_EXTENT_TREE_OBJECTID:
+	case BTRFS_CHUNK_TREE_OBJECTID:
+	case BTRFS_FS_TREE_OBJECTID:
+		ret = -EEXIST;
+		goto free;
+	default:
+		/* Subvolume trees don't need special handles */
+		if (is_fstree(objectid))
+			break;
+		/* Other special trees are not supported yet */
+		ret = -ENOTTY;
+		goto free;
+	}
+	btrfs_mark_buffer_dirty(node);
+	btrfs_set_root_bytenr(&root_item, btrfs_header_bytenr(node));
+	btrfs_set_root_level(&root_item, 0);
+	btrfs_set_root_generation(&root_item, trans->transid);
+	btrfs_set_root_dirid(&root_item, 0);
+	btrfs_set_root_refs(&root_item, 1);
+	btrfs_set_root_used(&root_item, fs_info->nodesize);
+	location.objectid = objectid;
+	location.type = BTRFS_ROOT_ITEM_KEY;
+	location.offset = 0;
+
+	ret = btrfs_insert_root(trans, fs_info->tree_root, &location,
+				&root_item);
+	if (ret < 0)
+		goto free;
+	return ret;
+
+free:
+	free_extent_buffer(node);
+	free(new_root);
+	return ret;
+}
+
 /*
  * check if the tree block can be shared by multiple trees
  */
diff --git a/ctree.h b/ctree.h
index cf99df1c90a8..b80771762575 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2606,6 +2606,8 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root,
 		      struct extent_buffer *buf,
 		      struct extent_buffer **cow_ret, u64 new_root_objectid);
+int btrfs_create_root(struct btrfs_trans_handle *trans,
+		      struct btrfs_fs_info *fs_info, u64 objectid);
 int btrfs_extend_item(struct btrfs_root *root, struct btrfs_path *path,
 		u32 data_size);
 int btrfs_truncate_item(struct btrfs_root *root, struct btrfs_path *path,
-- 
2.17.0

