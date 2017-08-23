Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:51282 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753273AbdHWCeF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 22:34:05 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id AB25346B4C93
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 10:34:02 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 5/6] [btrfs-progs: check: Introduce repair_tree_block_ref()
Date: Wed, 23 Aug 2017 10:33:49 +0800
Message-ID: <20170823023350.2940-6-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
References: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

The only thing repair_tree_block_ref() does is that adding backref of the
tree_block. Just like what origin repair do:

It first searches the correspond extent item then
1. If the extent item exists but backref is missing, add one backref to the
   extent.
2. Found nothing, just add an extent item and add one backref.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 147 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 147 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 726e330..deebc70 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2323,6 +2323,150 @@ static void account_bytes(struct btrfs_root *root, struct btrfs_path *path,
 	}
 }
 
+/*
+ * This function only handles BACKREF_MISSING,
+ * If correspond extent item exists, increase the ref;
+ * else insert an extent item and backref.
+ *
+ * Returns error bits after repair.
+ */
+static int repair_tree_block_ref(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct extent_buffer *node,
+				 struct node_refs *nrefs, int level, int err)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_path path;
+	struct btrfs_extent_item *ei;
+	struct btrfs_tree_block_info *bi;
+	struct btrfs_key key;
+	struct extent_buffer *eb;
+	u32 size = sizeof(*ei);
+	u32 node_size = root->fs_info->nodesize;
+	int insert_extent = 0;
+	int skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
+	int root_level = btrfs_header_level(root->node);
+	int generation;
+	int ret;
+	u64 owner;
+	u64 bytenr;
+	u64 flags = BTRFS_EXTENT_FLAG_TREE_BLOCK;
+	u64 parent = 0;
+
+	if ((err & BACKREF_MISSING) == 0)
+		return err;
+
+	WARN_ON(level > BTRFS_MAX_LEVEL);
+	WARN_ON(level < 0);
+
+	btrfs_init_path(&path);
+	bytenr = btrfs_header_bytenr(node);
+	owner = btrfs_header_owner(node);
+	generation = btrfs_header_generation(node);
+
+	key.objectid = bytenr;
+	key.type = (u8)-1;
+	key.offset = (u64)-1;
+
+	/* Search for the extent item */
+	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+	if (ret <= 0) {
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = btrfs_previous_extent_item(extent_root, &path, bytenr);
+	if (ret)
+		insert_extent = 1;
+
+	/* calculate the extent item flag is full backref or not */
+	if (nrefs->full_backref[level] != 0)
+		flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+
+	/* insert an extent item */
+	if (insert_extent) {
+		struct btrfs_disk_key copy_key;
+
+		generation = btrfs_header_generation(node);
+
+		if (level < root_level && nrefs->full_backref[level + 1] &&
+		    owner != root->objectid) {
+			flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+		}
+
+		key.objectid = bytenr;
+		if (!skinny_metadata) {
+			key.type = BTRFS_EXTENT_ITEM_KEY;
+			key.offset = node_size;
+			size += sizeof(*bi);
+		} else {
+			key.type = BTRFS_METADATA_ITEM_KEY;
+			key.offset = level;
+		}
+
+		btrfs_release_path(&path);
+		ret = btrfs_insert_empty_item(trans, extent_root, &path, &key,
+					      size);
+		if (ret)
+			goto out;
+
+		eb = path.nodes[0];
+		ei = btrfs_item_ptr(eb, path.slots[0],
+				    struct btrfs_extent_item);
+
+		btrfs_set_extent_refs(eb, ei, 0);
+		btrfs_set_extent_generation(eb, ei, generation);
+		btrfs_set_extent_flags(eb, ei, flags);
+
+		if (!skinny_metadata) {
+			bi = (struct btrfs_tree_block_info *)(ei + 1);
+			memset_extent_buffer(eb, 0, (unsigned long)bi,
+					     sizeof(*bi));
+			btrfs_set_disk_key_objectid(&copy_key,
+						    root->objectid);
+			btrfs_set_disk_key_type(&copy_key, 0);
+			btrfs_set_disk_key_offset(&copy_key, 0);
+
+			btrfs_set_tree_block_level(eb, bi, level);
+			btrfs_set_tree_block_key(eb, bi, &copy_key);
+		}
+		btrfs_mark_buffer_dirty(eb);
+		printf("Added a extent item [%llu %u]\n", bytenr,
+		       node_size);
+		btrfs_update_block_group(trans, extent_root, bytenr, node_size,
+					 1, 0);
+
+		nrefs->refs[level] = 0;
+		nrefs->full_backref[level] =
+			flags & BTRFS_BLOCK_FLAG_FULL_BACKREF;
+		btrfs_release_path(&path);
+	}
+
+	if (level < root_level && nrefs->full_backref[level + 1] &&
+	    owner != root->objectid)
+		parent = nrefs->bytenr[level + 1];
+
+	/* increase the ref */
+	ret = btrfs_inc_extent_ref(trans, extent_root, bytenr,
+			   node_size, parent, root->objectid, level, 0);
+
+	nrefs->refs[level]++;
+out:
+	btrfs_release_path(&path);
+	if (ret) {
+		error("failed to repair tree block ref start %llu root %llu due to %s",
+		      bytenr, root->objectid, strerror(-ret));
+	} else {
+		printf("Added one tree block ref start %llu %s %llu\n",
+		       bytenr, parent ? "parent" : "root",
+		       parent ? parent : root->objectid);
+		err &= ~BACKREF_MISSING;
+	}
+
+	return err;
+}
+
 static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 			    unsigned int ext_ref);
 static int check_tree_block_ref(struct btrfs_root *root,
@@ -2386,6 +2530,9 @@ static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
 			ret = check_tree_block_ref(root, cur,
 			   btrfs_header_bytenr(cur), btrfs_header_level(cur),
 			   btrfs_header_owner(cur), nrefs);
+			if (repair && ret)
+				ret = repair_tree_block_ref(trans, root,
+				    path->nodes[*level], nrefs, *level, ret);
 			err |= ret;
 
 			if (check_all && nrefs->need_check[*level] &&
-- 
2.7.4



