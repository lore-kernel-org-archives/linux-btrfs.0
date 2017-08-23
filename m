Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47372 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753266AbdHWCeF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 22:34:05 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 41E3446B5FD3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 10:34:03 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 6/6] btrfs-progs: check: Introduce repair_extent_data_item()
Date: Wed, 23 Aug 2017 10:33:50 +0800
Message-ID: <20170823023350.2940-7-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
References: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

The only thing repair_extent_data_item() does is that adding backref of the
tree_block. Just like what origin repair do:

It first searches the correspond extent item then
1. If the extent item exists but backref is missing, add one backref to the
   extent.
2. Found nothing, just add an extent item and add one backref.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 117 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index deebc70..09c8d4d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10665,6 +10665,120 @@ out:
 }
 
 /*
+ * If @err contains BACKREF_MISSING then add extent of the
+ * file_extent_data_item.
+ *
+ * Returns error bits after reapir.
+ */
+static int repair_extent_data_item(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_path *pathp,
+				   struct node_refs *nrefs,
+				   int err)
+{
+	struct btrfs_file_extent_item *fi;
+	struct btrfs_key fi_key;
+	struct btrfs_key key;
+	struct btrfs_extent_item *ei;
+	struct btrfs_path path;
+	struct btrfs_root *extent_root = root->fs_info->extent_root;
+	struct extent_buffer *eb;
+	u64 size;
+	u64 disk_bytenr;
+	u64 num_bytes;
+	u64 parent;
+	u64 offset;
+	u64 extent_offset;
+	u64 file_offset;
+	int generation;
+	int slot;
+	int ret = 0;
+
+	eb = pathp->nodes[0];
+	slot = pathp->slots[0];
+	btrfs_item_key_to_cpu(eb, &fi_key, slot);
+	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+
+	if (btrfs_file_extent_type(eb, fi) == BTRFS_FILE_EXTENT_INLINE ||
+	    btrfs_file_extent_disk_bytenr(eb, fi) == 0)
+		return err;
+
+	file_offset = fi_key.offset;
+	generation = btrfs_file_extent_generation(eb, fi);
+	disk_bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
+	num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
+	extent_offset = btrfs_file_extent_offset(eb, fi);
+	offset = file_offset - extent_offset;
+
+	/* now repair only adds backref */
+	if ((err & BACKREF_MISSING) == 0)
+		return err;
+
+	/* search extent item */
+	key.objectid = disk_bytenr;
+	key.type = BTRFS_EXTENT_ITEM_KEY;
+	key.offset = num_bytes;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+	if (ret < 0) {
+		ret = -EIO;
+		goto out;
+	}
+
+	/* insert an extent item */
+	if (ret > 0) {
+		key.objectid = disk_bytenr;
+		key.type = BTRFS_EXTENT_ITEM_KEY;
+		key.offset = num_bytes;
+		size = sizeof(*ei);
+
+		btrfs_release_path(&path);
+		ret = btrfs_insert_empty_item(trans, extent_root, &path, &key,
+					      size);
+		if (ret)
+			goto out;
+		eb = path.nodes[0];
+		ei = btrfs_item_ptr(eb, path.slots[0],
+				    struct btrfs_extent_item);
+
+		btrfs_set_extent_refs(eb, ei, 0);
+		btrfs_set_extent_generation(eb, ei, generation);
+		btrfs_set_extent_flags(eb, ei, BTRFS_EXTENT_FLAG_DATA);
+
+		btrfs_mark_buffer_dirty(eb);
+		ret = btrfs_update_block_group(trans, extent_root, disk_bytenr,
+					       num_bytes, 1, 0);
+		btrfs_release_path(&path);
+	}
+
+	if (nrefs->full_backref[0])
+		parent = btrfs_header_bytenr(eb);
+	else
+		parent = 0;
+
+	ret = btrfs_inc_extent_ref(trans, root, disk_bytenr, num_bytes, parent,
+				   root->objectid,
+		   parent ? BTRFS_FIRST_FREE_OBJECTID : fi_key.objectid,
+				   offset);
+	if (ret) {
+		error("failed to increase extent data backref[%llu %llu] root %llu",
+		      disk_bytenr, num_bytes, root->objectid);
+		goto out;
+	} else {
+		printf("Add one extent data backref [%llu %llu]\n",
+		       disk_bytenr, num_bytes);
+	}
+
+	err &= ~BACKREF_MISSING;
+out:
+	if (ret)
+		error("can't repair root %llu extent data item[%llu %llu]",
+		      root->objectid, disk_bytenr, num_bytes);
+	return err;
+}
+
+/*
  * Check EXTENT_DATA item, mainly for its dbackref in extent tree
  *
  * Return >0 any error found and output error message
@@ -11905,6 +12019,9 @@ again:
 	switch (type) {
 	case BTRFS_EXTENT_DATA_KEY:
 		ret = check_extent_data_item(root, path, nrefs, account_bytes);
+		if (repair && ret)
+			ret = repair_extent_data_item(trans, root, path, nrefs,
+						      ret);
 		err |= ret;
 		break;
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
-- 
2.7.4



