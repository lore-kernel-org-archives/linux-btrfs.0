Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48426 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbeHQI4k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 04:56:40 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 756A9AD09
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Aug 2018 05:54:37 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: image: Rebuild dev extents for restore
Date: Fri, 17 Aug 2018 13:54:33 +0800
Message-Id: <20180817055433.27542-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When restoring image from a dump of multiple device, we just restore
device as is, even the restore destination is just a single device.

In that case, due to dev extents mismatch, latest kernel will refuse to
mount it as it detects such mismatch as good as btrfs check.

Fix it by rebuilding the whole device tree when finishing restore, so
kernel or btrfs check will give no complain about restore image any
more.

This fixes misc/021 test case.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h      |   6 +++
 image/main.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 135 insertions(+)

diff --git a/ctree.h b/ctree.h
index 4719962df67d..69bf3be4b9b1 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1707,6 +1707,12 @@ BTRFS_SETGET_FUNCS(dev_extent_chunk_offset, struct btrfs_dev_extent,
 		   chunk_offset, 64);
 BTRFS_SETGET_FUNCS(dev_extent_length, struct btrfs_dev_extent, length, 64);
 
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_tree, struct btrfs_dev_extent,
+		   chunk_tree, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_objectid,
+		   struct btrfs_dev_extent, chunk_objectid, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_chunk_offset, struct btrfs_dev_extent,
+		   chunk_offset, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_dev_extent_length, struct btrfs_dev_extent,
 			 length, 64);
 
diff --git a/image/main.c b/image/main.c
index 351c5a256938..9a899105f65e 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2171,6 +2171,128 @@ again:
 	return 0;
 }
 
+/* Insert dev extents using one chunk (@ce) */
+static int insert_dev_extents(struct btrfs_trans_handle *trans,
+			      struct cache_extent *ce)
+{
+	struct btrfs_root *root = trans->fs_info->dev_root;
+	struct btrfs_key key;
+	struct btrfs_dev_extent de;
+	struct map_lookup *map;
+	u64 stripe_len;
+	int i;
+	int ret;
+
+	map = container_of(ce, struct map_lookup, ce);
+
+	stripe_len = calc_stripe_length(map->type, ce->size,
+					    map->num_stripes);
+
+	/* These members are shared between dev extents of this chunk */
+	btrfs_set_stack_dev_extent_chunk_objectid(&de,
+			BTRFS_FIRST_CHUNK_TREE_OBJECTID);
+	btrfs_set_stack_dev_extent_chunk_tree(&de, BTRFS_CHUNK_TREE_OBJECTID);
+	btrfs_set_stack_dev_extent_length(&de, stripe_len);
+	btrfs_set_stack_dev_extent_chunk_offset(&de, ce->start);
+	read_extent_buffer(root->node, btrfs_dev_extent_chunk_tree_uuid(&de),
+			btrfs_header_chunk_tree_uuid(root->node),
+			BTRFS_UUID_SIZE);
+
+	/* Insert dev extents items */
+	for (i = 0; i < map->num_stripes; i++) {
+		key.objectid = map->stripes[i].dev->devid;
+		key.offset = map->stripes[i].physical;
+		key.type = BTRFS_DEV_EXTENT_KEY;
+
+		ret = btrfs_insert_item(trans, root, &key, &de, sizeof(de));
+		if (ret < 0) {
+			error(
+		"failed to insert dev extent for devid %llu offset %llu: %s",
+			      key.objectid, key.offset, strerror(-ret));
+			return ret;
+		}
+	}
+	return 0;
+}
+
+/*
+ * btrfs-image restore just restore tree dump as is.
+ * For most trees this behavior is fine, as we have chunk level mapping.
+ * But for trees has info related to physical offset, namely device tree,
+ * we need to fix the dev extents to reflect the real chunk mapping.
+ */
+static int rebuild_dev_extents(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *root = fs_info->dev_root;
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct cache_extent *ce;
+	int ret;
+
+	trans = btrfs_start_transaction(root, 1);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		error("failed to start transaction: %s", strerror(-ret));
+		return ret;
+	}
+
+	key.objectid = 1;
+	key.offset = 0;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
+	if (ret < 0) {
+		error("failed to search dev extents: %s", strerror(-ret));
+		goto out;
+	}
+
+	/*
+	 * Delete all existing dev extents first, don't have function to drop
+	 * a whole tree yet, so only do it by deleting all items
+	 */
+	while (1) {
+		int nr_items = btrfs_header_nritems(path.nodes[0]);
+
+		if (path.nodes[1] == NULL && path.slots[0] >= nr_items)
+			break;
+
+		ret = btrfs_del_items(trans, root, &path, path.slots[0],
+				nr_items - path.slots[0]);
+		if (ret < 0) {
+			error("failed to delete old dev extents: %s",
+			      strerror(-ret));
+			goto out;
+		}
+	}
+	btrfs_release_path(&path);
+
+	/* Now re-generate dev extents using current chunk mappings */
+	for (ce = first_cache_extent(&map_tree->cache_tree); ce;
+	     ce = next_cache_extent(ce)) {
+		ret = insert_dev_extents(trans, ce);
+		if (ret < 0) {
+			error("failed to insert dev extents for chunk %llu: %s",
+			      ce->start, strerror(-ret));
+			goto out;
+		}
+	}
+
+out:
+	btrfs_release_path(&path);
+	if (ret < 0) {
+		btrfs_abort_transaction(trans, ret);
+	} else {
+		ret = btrfs_commit_transaction(trans, root);
+		if (ret < 0) {
+			error("failed to commit transaction: %s",
+			      strerror(-ret));
+		}
+	}
+	return ret;
+}
+
 static int restore_metadump(const char *input, FILE *out, int old_restore,
 			    int num_threads, int fixup_offset,
 			    const char *target, int multi_devices)
@@ -2276,6 +2398,13 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 		}
 
 		ret = fixup_devices(info, &mdrestore, st.st_size);
+		if (ret < 0) {
+			error("failed to fixup device items: %s",
+			      strerror(-ret));
+			close_ctree(info->chunk_root);
+			goto out;
+		}
+		ret = rebuild_dev_extents(info);
 		close_ctree(info->chunk_root);
 		if (ret)
 			goto out;
-- 
2.18.0
