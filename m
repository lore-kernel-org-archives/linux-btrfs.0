Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:47372 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753145AbdHWCeC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 22:34:02 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id DE74B46B4C93
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Aug 2017 10:34:01 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Su Yue <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 3/6] btrfs-progs: check: delete wrong items in lowmem repair
Date: Wed, 23 Aug 2017 10:33:47 +0800
Message-ID: <20170823023350.2940-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
References: <20170823023350.2940-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

Introduce delete_extent_tree_item() and repair_extent_item() to do
delete only.

while checking a extent tree, just delete wrong item.
For extent item, free wrong backref. Otherwise, do delete.
So the rest items in extent tree should be correct.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 138 insertions(+), 13 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 7c9036c..0f26394 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11084,24 +11084,77 @@ out:
 }
 
 /*
+ * Only delete backref if REFERENCER_MISSING now
+ *
+ * Returns <0   the extent was deleted
+ * Returns >0   the backref was deleted but extent is still existed,
+ *              returned value means err after repair
+ * Returns  0   nothing happened
+ */
+static int repair_extent_item(struct btrfs_trans_handle *trans,
+		      struct btrfs_root *root, struct btrfs_path *path,
+		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
+		      u64 owner, u64 offset, int err)
+{
+	struct btrfs_key old_key;
+	int freed = 0;
+	int ret;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &old_key, path->slots[0]);
+
+	if (err & (REFERENCER_MISSING | REFERENCER_MISMATCH)) {
+		/* delete the backref */
+		ret = btrfs_free_extent(trans, root->fs_info->fs_root, bytenr,
+			  num_bytes, parent, root_objectid, owner, offset);
+		if (!ret) {
+			freed = 1;
+			err &= ~REFERENCER_MISSING;
+			printf("Delete backref in extent [%llu %llu]\n",
+			       bytenr, num_bytes);
+		} else {
+			error("fail to delete backref in extent [%llu %llu]\n",
+			       bytenr, num_bytes);
+		}
+	}
+
+	/* btrfs_free_extent may delete the extent */
+	btrfs_release_path(path);
+	ret = btrfs_search_slot(NULL, root, &old_key, path, 0, 0);
+
+	if (ret)
+		ret = -ENOENT;
+	else if (freed)
+		ret = err;
+	return ret;
+}
+
+/*
  * This function will check a given extent item, including its backref and
  * itself (like crossing stripe boundary and type)
  *
  * Since we don't use extent_record anymore, introduce new error bit
  */
-static int check_extent_item(struct btrfs_fs_info *fs_info,
-			     struct extent_buffer *eb, int slot)
+static int check_extent_item(struct btrfs_trans_handle *trans,
+			     struct btrfs_fs_info *fs_info,
+			     struct btrfs_path *path)
 {
 	struct btrfs_extent_item *ei;
 	struct btrfs_extent_inline_ref *iref;
 	struct btrfs_extent_data_ref *dref;
+	struct extent_buffer *eb = path->nodes[0];
 	unsigned long end;
 	unsigned long ptr;
+	int slot = path->slots[0];
 	int type;
 	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 flags;
 	u64 offset;
+	u64 parent;
+	u64 num_bytes;
+	u64 root_objectid;
+	u64 owner;
+	u64 owner_offset;
 	int metadata = 0;
 	int level;
 	struct btrfs_key key;
@@ -11109,10 +11162,13 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 	int err = 0;
 
 	btrfs_item_key_to_cpu(eb, &key, slot);
-	if (key.type == BTRFS_EXTENT_ITEM_KEY)
+	if (key.type == BTRFS_EXTENT_ITEM_KEY) {
 		bytes_used += key.offset;
-	else
+		num_bytes = key.offset;
+	} else {
 		bytes_used += nodesize;
+		num_bytes = nodesize;
+	}
 
 	if (item_size < sizeof(*ei)) {
 		/*
@@ -11150,7 +11206,6 @@ static int check_extent_item(struct btrfs_fs_info *fs_info,
 		level = key.offset;
 	}
 	end = (unsigned long)ei + item_size;
-
 next:
 	/* Reached extent item end normally */
 	if (ptr == end)
@@ -11164,42 +11219,63 @@ next:
 		goto out;
 	}
 
+	parent = 0;
+	root_objectid = 0;
+	owner = 0;
+	owner_offset = 0;
 	/* Now check every backref in this extent item */
 	iref = (struct btrfs_extent_inline_ref *)ptr;
 	type = btrfs_extent_inline_ref_type(eb, iref);
 	offset = btrfs_extent_inline_ref_offset(eb, iref);
 	switch (type) {
 	case BTRFS_TREE_BLOCK_REF_KEY:
+		root_objectid = offset;
+		owner = level;
 		ret = check_tree_block_backref(fs_info, offset, key.objectid,
 					       level);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
+		parent = offset;
 		ret = check_shared_block_backref(fs_info, offset, key.objectid,
 						 level);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
 		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
-		ret = check_extent_data_backref(fs_info,
-				btrfs_extent_data_ref_root(eb, dref),
-				btrfs_extent_data_ref_objectid(eb, dref),
-				btrfs_extent_data_ref_offset(eb, dref),
-				key.objectid, key.offset,
-				btrfs_extent_data_ref_count(eb, dref));
+		root_objectid = btrfs_extent_data_ref_root(eb, dref);
+		owner = btrfs_extent_data_ref_objectid(eb, dref);
+		owner_offset = btrfs_extent_data_ref_offset(eb, dref);
+		ret = check_extent_data_backref(fs_info, root_objectid, owner,
+					owner_offset, key.objectid, key.offset,
+					btrfs_extent_data_ref_count(eb, dref));
 		err |= ret;
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
+		parent = offset;
 		ret = check_shared_data_backref(fs_info, offset, key.objectid);
 		err |= ret;
 		break;
 	default:
 		error("extent[%llu %d %llu] has unknown ref type: %d",
 			key.objectid, key.type, key.offset, type);
-		err |= UNKNOWN_TYPE;
+		ret = UNKNOWN_TYPE;
+		err |= ret;
 		goto out;
 	}
 
+	if (err && repair) {
+		ret = repair_extent_item(trans, fs_info->extent_root, path,
+			 key.objectid, num_bytes, parent, root_objectid,
+			 owner, owner_offset, ret);
+		if (ret < 0)
+			goto out;
+		if (ret) {
+			goto next;
+			err = ret;
+		}
+	}
+
 	ptr += btrfs_extent_inline_ref_size(type);
 	goto next;
 
@@ -11571,6 +11647,39 @@ out:
 	return err;
 }
 
+static int delete_extent_tree_item(struct btrfs_trans_handle *trans,
+				   struct btrfs_root *root,
+				   struct btrfs_path *path)
+{
+	struct btrfs_key key;
+	int ret = 0;
+
+	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+	btrfs_release_path(path);
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ret = btrfs_del_item(trans, root, path);
+	if (ret)
+		goto out;
+
+	if (path->slots[0] == 0)
+		btrfs_prev_leaf(root, path);
+	else
+		path->slots[0]--;
+out:
+	if (ret)
+		error("failed to delete root %llu item[%llu, %u, %llu]\n",
+		      root->objectid, key.objectid, key.type, key.offset);
+	else
+		printf("deleted root %llu item[%llu, %u, %llu]\n",
+		       root->objectid, key.objectid, key.type, key.offset);
+	return ret;
+}
+
 /*
  * Main entry function to check known items and update related accounting info
  */
@@ -11609,6 +11718,9 @@ again:
 		break;
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
 		ret = check_block_group_item(fs_info, eb, slot);
+		if (repair &&
+		    ret & REFERENCER_MISSING)
+			ret = delete_extent_tree_item(trans, root, path);
 		err |= ret;
 		break;
 	case BTRFS_DEV_ITEM_KEY:
@@ -11625,7 +11737,7 @@ again:
 		break;
 	case BTRFS_EXTENT_ITEM_KEY:
 	case BTRFS_METADATA_ITEM_KEY:
-		ret = check_extent_item(fs_info, eb, slot);
+		ret = check_extent_item(trans, fs_info, path);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
@@ -11635,6 +11747,9 @@ again:
 	case BTRFS_TREE_BLOCK_REF_KEY:
 		ret = check_tree_block_backref(fs_info, key.offset,
 					       key.objectid, -1);
+		if (repair &&
+		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
+			ret = delete_extent_tree_item(trans, root, path);
 		err |= ret;
 		break;
 	case BTRFS_EXTENT_DATA_REF_KEY:
@@ -11645,16 +11760,26 @@ again:
 				btrfs_extent_data_ref_offset(eb, dref),
 				key.objectid, 0,
 				btrfs_extent_data_ref_count(eb, dref));
+		if (repair &&
+		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
+			ret = delete_extent_tree_item(trans, root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_BLOCK_REF_KEY:
 		ret = check_shared_block_backref(fs_info, key.offset,
 						 key.objectid, -1);
+		if (repair &&
+		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
+			ret = delete_extent_tree_item(trans, root, path);
 		err |= ret;
 		break;
 	case BTRFS_SHARED_DATA_REF_KEY:
 		ret = check_shared_data_backref(fs_info, key.offset,
 						key.objectid);
+		if (repair &&
+		    ret & (REFERENCER_MISMATCH | REFERENCER_MISSING))
+			ret = delete_extent_tree_item(trans, root, path);
+
 		err |= ret;
 		break;
 	default:
-- 
2.7.4



