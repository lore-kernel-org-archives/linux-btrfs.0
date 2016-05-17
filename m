Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:4492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbcEQJjD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:03 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 01/16] btrfs-progs: fsck: Introduce function to check tree block backref in extent tree
Date: Tue, 17 May 2016 17:38:35 +0800
Message-Id: <1463477930-3925-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function check_tree_block_ref() to check whether a tree block
has correct backref in extent tree.

Unlike old extent tree check method, we only use search_slot() to search
reference, no extra structure will be allocated in heap to record what we
have checked.

This method may cause a little more IO, but should work for super large
fs without triggering OOM.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 161 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index ec0bbfd..0aea9ba 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -313,6 +313,15 @@ struct root_item_info {
 	struct cache_extent cache_extent;
 };
 
+/*
+ * Error bit for low memory mode check.
+ *
+ * Current no caller cares about it yet.
+ * Just as an internal use error classification
+ */
+#define BACKREF_MISSING		(1 << 0) /* Backref missing in extent tree */
+#define BACKREF_MISMATCH	(1 << 1) /* Backref exists but mismatch */
+
 static void *print_status_check(void *p)
 {
 	struct task_ctx *priv = p;
@@ -8402,6 +8411,158 @@ loop:
 	goto again;
 }
 
+/*
+ * Check backrefs of a tree block given by @bytenr or @eb.
+ *
+ * @root:	the root containin the @bytenr or @eb
+ * @eb:		tree block extent buffer, can be NULL
+ * @bytenr:	bytenr of the tree block to search
+ * @level:	tree level of the tree block
+ * @owner:	owner of the tree block
+ *
+ * Return >0 for any error found and output error message
+ * Return 0 for no error found
+ */
+static int check_tree_block_ref(struct btrfs_root *root,
+				struct extent_buffer *eb, u64 bytenr,
+				int level, u64 owner)
+{
+	struct btrfs_key key;
+	struct btrfs_root *extent_root = root->fs_info->extent_root;
+	struct btrfs_path path;
+	struct btrfs_extent_item *ei;
+	struct btrfs_extent_inline_ref *iref;
+	struct extent_buffer *leaf;
+	unsigned long end;
+	unsigned long ptr;
+	int slot;
+	int skinny_level;
+	int type;
+	u32 nodesize = root->nodesize;
+	u32 item_size;
+	u64 offset;
+	int found_ref = 0;
+	int err = 0;
+	int ret;
+
+	btrfs_init_path(&path);
+	key.objectid = bytenr;
+	if (btrfs_fs_incompat(root->fs_info,
+			      BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA))
+		key.type = BTRFS_METADATA_ITEM_KEY;
+	else
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	/* Search for the backref in extent tree */
+	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+	if (ret < 0) {
+		err |= BACKREF_MISSING;
+		goto out;
+	}
+	ret = btrfs_previous_extent_item(extent_root, &path, bytenr);
+	if (ret) {
+		err |= BACKREF_MISSING;
+		goto out;
+	}
+
+	leaf = path.nodes[0];
+	slot = path.slots[0];
+	btrfs_item_key_to_cpu(leaf, &key, slot);
+
+	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
+
+	if (key.type == BTRFS_METADATA_ITEM_KEY) {
+		skinny_level = (int)key.offset;
+		iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+	} else {
+		struct btrfs_tree_block_info *info;
+
+		info = (struct btrfs_tree_block_info *)(ei + 1);
+		skinny_level = btrfs_tree_block_level(leaf, info);
+		iref = (struct btrfs_extent_inline_ref *)(info + 1);
+	}
+
+	if (eb) {
+		u64 header_gen;
+		u64 extent_gen;
+
+		if (!(btrfs_extent_flags(leaf, ei) &
+		      BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
+			error("Extent[%llu %u] backref type mismatch, missing bit: %llx",
+			      key.objectid, nodesize,
+			      BTRFS_EXTENT_FLAG_TREE_BLOCK);
+			err = BACKREF_MISMATCH;
+		}
+		header_gen = btrfs_header_generation(eb);
+		extent_gen = btrfs_extent_generation(leaf, ei);
+		if (header_gen != extent_gen) {
+			error("Extent[%llu %u] backref generation mismatch, wanted: %llu, have: %llu",
+			      key.objectid, nodesize, header_gen,
+			      extent_gen);
+			err = BACKREF_MISMATCH;
+		}
+		if (level != skinny_level) {
+			error("Extent[%llu %u] level mismatch, wanted: %u, have: %u",
+			      key.objectid, nodesize, level, skinny_level);
+			err = BACKREF_MISMATCH;
+		}
+		if (!is_fstree(owner) && btrfs_extent_refs(leaf, ei) != 1) {
+			error("Extent[%llu %u] is referred by other roots than %llu",
+			      key.objectid, nodesize, root->objectid);
+			err = BACKREF_MISMATCH;
+		}
+	}
+
+	/*
+	 * Iterate the extent/metadata item to find the exact backref
+	 */
+	item_size = btrfs_item_size_nr(leaf, slot);
+	ptr = (unsigned long)iref;
+	end = (unsigned long)ei + item_size;
+	while (ptr < end) {
+		iref = (struct btrfs_extent_inline_ref *)ptr;
+		type = btrfs_extent_inline_ref_type(leaf, iref);
+		offset = btrfs_extent_inline_ref_offset(leaf, iref);
+
+		if (type == BTRFS_TREE_BLOCK_REF_KEY &&
+			(offset == root->objectid || offset == owner)) {
+			found_ref = 1;
+		} else if (type == BTRFS_SHARED_BLOCK_REF_KEY) {
+			/* Check if the backref points to valid referencer */
+			found_ref = !check_tree_block_ref(root, NULL, offset,
+							  level + 1, owner);
+		}
+
+		if (found_ref)
+			break;
+		ptr += btrfs_extent_inline_ref_size(type);
+	}
+
+	/*
+	 * Inlined extent item doesn't have what we need, check
+	 * TREE_BLOCK_REF_KEY
+	 */
+	if (!found_ref) {
+		btrfs_release_path(&path);
+		key.objectid = bytenr;
+		key.type = BTRFS_TREE_BLOCK_REF_KEY;
+		key.offset = root->objectid;
+
+		ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+		if (!ret)
+			found_ref = 1;
+	}
+	if (!found_ref)
+		err |= BACKREF_MISSING;
+out:
+	btrfs_release_path(&path);
+	if (eb && (err & BACKREF_MISSING))
+		error("Extent[%llu %u] backret lost(owner: %llu, level: %u)",
+		      bytenr, nodesize, owner, level);
+	return err;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.2



