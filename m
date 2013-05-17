Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58995 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab3EQNgk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 09:36:40 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6A49E7C0425
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 07:36:39 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id sXXTKZK2ytc7egi0 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 07:36:38 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add --init-extent-tree to btrfsck
Date: Fri, 17 May 2013 09:36:35 -0400
Message-ID: <1368797795-1811-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some cases the extent tree can just be so gone there is no point in trying to
figure out how to put it back together.  So add a --init-extent-tree mode which
will zero out the extent tree and then re-add extents for all of the blocks we
find.  This will also undo any balance that was going on at the time of the
crash, this is needed because the reloc tree seems to confuse fsck at the
moment.  With this patch I can put back together a users file system that was
completely gone.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c  |  360 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ctree.c       |    9 +-
 ctree.h       |    5 +-
 extent-tree.c |   31 ++++--
 4 files changed, 392 insertions(+), 13 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c5bca84..7bb68ce 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4643,6 +4643,353 @@ out:
 	return ret;
 }
 
+static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
+				struct extent_buffer *eb, int tree_root)
+{
+	struct extent_buffer *tmp;
+	struct btrfs_root_item *ri;
+	struct btrfs_key key;
+	u64 bytenr;
+	u32 leafsize;
+	int level = btrfs_header_level(eb);
+	int nritems;
+	int ret;
+	int i;
+
+	btrfs_pin_extent(fs_info, eb->start, eb->len);
+
+	leafsize = btrfs_super_leafsize(fs_info->super_copy);
+	nritems = btrfs_header_nritems(eb);
+	for (i = 0; i < nritems; i++) {
+		if (level == 0) {
+			btrfs_item_key_to_cpu(eb, &key, i);
+			if (key.type != BTRFS_ROOT_ITEM_KEY)
+				continue;
+			/* Skip the extent root and reloc roots */
+			if (key.objectid == BTRFS_EXTENT_TREE_OBJECTID ||
+			    key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
+			    key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
+				continue;
+			ri = btrfs_item_ptr(eb, i, struct btrfs_root_item);
+			bytenr = btrfs_disk_root_bytenr(eb, ri);
+
+			/*
+			 * If at any point we start needing the real root we
+			 * will have to build a stump root for the root we are
+			 * in, but for now this doesn't actually use the root so
+			 * just pass in extent_root.
+			 */
+			tmp = read_tree_block(fs_info->extent_root, bytenr,
+					      leafsize, 0);
+			if (!tmp) {
+				fprintf(stderr, "Error reading root block\n");
+				return -EIO;
+			}
+			ret = pin_down_tree_blocks(fs_info, tmp, 0);
+			free_extent_buffer(tmp);
+			if (ret)
+				return ret;
+		} else {
+			bytenr = btrfs_node_blockptr(eb, i);
+
+			/* If we aren't the tree root don't read the block */
+			if (level == 1 && !tree_root) {
+				btrfs_pin_extent(fs_info, bytenr, leafsize);
+				continue;
+			}
+
+			tmp = read_tree_block(fs_info->extent_root, bytenr,
+					      leafsize, 0);
+			if (!tmp) {
+				fprintf(stderr, "Error reading tree block\n");
+				return -EIO;
+			}
+			ret = pin_down_tree_blocks(fs_info, tmp, tree_root);
+			free_extent_buffer(tmp);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int pin_metadata_blocks(struct btrfs_fs_info *fs_info)
+{
+	int ret;
+
+	ret = pin_down_tree_blocks(fs_info, fs_info->chunk_root->node, 0);
+	if (ret)
+		return ret;
+
+	return pin_down_tree_blocks(fs_info, fs_info->tree_root->node, 1);
+}
+
+static int reset_block_groups(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_chunk *chunk;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = 0;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, fs_info->chunk_root, &key, path, 0, 0);
+	if (ret < 0) {
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	/*
+	 * We do this in case the block groups were screwed up and had alloc
+	 * bits that aren't actually set on the chunks.  This happens with
+	 * restored images every time and could happen in real life I guess.
+	 */
+	fs_info->avail_data_alloc_bits = 0;
+	fs_info->avail_metadata_alloc_bits = 0;
+	fs_info->avail_system_alloc_bits = 0;
+
+	/* First we need to create the in-memory block groups */
+	while (1) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(fs_info->chunk_root, path);
+			if (ret < 0) {
+				btrfs_free_path(path);
+				return ret;
+			}
+			if (ret) {
+				ret = 0;
+				break;
+			}
+		}
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.type != BTRFS_CHUNK_ITEM_KEY) {
+			path->slots[0]++;
+			continue;
+		}
+
+		chunk = btrfs_item_ptr(leaf, path->slots[0],
+				       struct btrfs_chunk);
+		btrfs_add_block_group(fs_info, 0,
+				      btrfs_chunk_type(leaf, chunk),
+				      key.objectid, key.offset,
+				      btrfs_chunk_length(leaf, chunk));
+		path->slots[0]++;
+	}
+
+	btrfs_free_path(path);
+	return 0;
+}
+
+static int reset_balance(struct btrfs_trans_handle *trans,
+			 struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *root = fs_info->tree_root;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	int del_slot, del_nr = 0;
+	int ret;
+	int found = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = BTRFS_BALANCE_OBJECTID;
+	key.type = BTRFS_BALANCE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret) {
+		if (ret > 0)
+			ret = 0;
+		goto out;
+	}
+
+	ret = btrfs_del_item(trans, root, path);
+	if (ret)
+		goto out;
+	btrfs_release_path(root, path);
+
+	key.objectid = BTRFS_TREE_RELOC_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+	while (1) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			if (!found)
+				break;
+
+			if (del_nr) {
+				ret = btrfs_del_items(trans, root, path,
+						      del_slot, del_nr);
+				del_nr = 0;
+				if (ret)
+					goto out;
+			}
+			key.offset++;
+			btrfs_release_path(root, path);
+
+			found = 0;
+			ret = btrfs_search_slot(trans, root, &key, path,
+						-1, 1);
+			if (ret < 0)
+				goto out;
+			continue;
+		}
+		found = 1;
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		if (key.objectid > BTRFS_TREE_RELOC_OBJECTID)
+			break;
+		if (key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
+			path->slots[0]++;
+			continue;
+		}
+		if (!del_nr) {
+			del_slot = path->slots[0];
+			del_nr = 1;
+		} else {
+			del_nr++;
+		}
+		path->slots[0]++;
+	}
+
+	if (del_nr) {
+		ret = btrfs_del_items(trans, root, path, del_slot, del_nr);
+		if (ret)
+			goto out;
+	}
+	btrfs_release_path(root, path);
+
+	key.objectid = BTRFS_DATA_RELOC_TREE_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+	root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(root)) {
+		fprintf(stderr, "Error reading data reloc tree\n");
+		return PTR_ERR(root);
+	}
+	root->track_dirty = 1;
+	if (root->last_trans != trans->transid) {
+		root->last_trans = trans->transid;
+		root->commit_root = root->node;
+		extent_buffer_get(root->node);
+	}
+	ret = btrfs_fsck_reinit_root(trans, root, 0);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int reinit_extent_tree(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_trans_handle *trans;
+	u64 start = 0;
+	int ret;
+
+	/*
+	 * The only reason we don't do this is because right now we're just
+	 * walking the trees we find and pinning down their bytes, we don't look
+	 * at any of the leaves.  In order to do mixed groups we'd have to check
+	 * the leaves of any fs roots and pin down the bytes for any file
+	 * extents we find.  Not hard but why do it if we don't have to?
+	 */
+	if (btrfs_fs_incompat(fs_info, BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)) {
+		fprintf(stderr, "We don't support re-initing the extent tree "
+			"for mixed block groups yet, please notify a btrfs "
+			"developer you want to do this so they can add this "
+			"functionality.\n");
+		return -EINVAL;
+	}
+
+	trans = btrfs_start_transaction(fs_info->extent_root, 1);
+	if (IS_ERR(trans)) {
+		fprintf(stderr, "Error starting transaction\n");
+		return PTR_ERR(trans);
+	}
+
+	/*
+	 * first we need to walk all of the trees except the extent tree and pin
+	 * down the bytes that are in use so we don't overwrite any existing
+	 * metadata.
+	 */
+	ret = pin_metadata_blocks(fs_info);
+	if (ret) {
+		fprintf(stderr, "error pinning down used bytes\n");
+		return ret;
+	}
+
+	/*
+	 * Need to drop all the block groups since we're going to recreate all
+	 * of them again.
+	 */
+	btrfs_free_block_groups(fs_info);
+	ret = reset_block_groups(fs_info);
+	if (ret) {
+		fprintf(stderr, "error resetting the block groups\n");
+		return ret;
+	}
+
+	/* Ok we can allocate now, reinit the extent root */
+	ret = btrfs_fsck_reinit_root(trans, fs_info->extent_root, 1);
+	if (ret) {
+		fprintf(stderr, "extent root initialization failed\n");
+		/*
+		 * When the transaction code is updated we should end the
+		 * transaction, but for now progs only knows about commit so
+		 * just return an error.
+		 */
+		return ret;
+	}
+
+	ret = reset_balance(trans, fs_info);
+	if (ret) {
+		fprintf(stderr, "error reseting the pending balance\n");
+		return ret;
+	}
+
+	/*
+	 * Now we have all the in-memory block groups setup so we can make
+	 * allocations properly, and the metadata we care about is safe since we
+	 * pinned all of it above.
+	 */
+	while (1) {
+		struct btrfs_block_group_cache *cache;
+
+		cache = btrfs_lookup_first_block_group(fs_info, start);
+		if (!cache)
+			break;
+		start = cache->key.objectid + cache->key.offset;
+		ret = btrfs_insert_item(trans, fs_info->extent_root,
+					&cache->key, &cache->item,
+					sizeof(cache->item));
+		if (ret) {
+			fprintf(stderr, "Error adding block group\n");
+			return ret;
+		}
+		btrfs_extent_post_op(trans, fs_info->extent_root);
+	}
+
+	/*
+	 * Ok now we commit and run the normal fsck, which will add extent
+	 * entries for all of the items it finds.
+	 */
+	return btrfs_commit_transaction(trans, fs_info->extent_root);
+}
+
 static struct option long_options[] = {
 	{ "super", 1, NULL, 's' },
 	{ "repair", 0, NULL, 0 },
@@ -4674,6 +5021,7 @@ int cmd_check(int argc, char **argv)
 	int repair = 0;
 	int option_index = 0;
 	int init_csum_tree = 0;
+	int init_extent_tree = 0;
 	int rw = 0;
 
 	while(1) {
@@ -4702,6 +5050,10 @@ int cmd_check(int argc, char **argv)
 			printf("Creating a new CRC tree\n");
 			init_csum_tree = 1;
 			rw = 1;
+		} else if (option_index == 3) {
+			init_extent_tree = 1;
+			rw = 1;
+			repair = 1;
 		}
 
 	}
@@ -4740,6 +5092,12 @@ int cmd_check(int argc, char **argv)
 
 	root = info->fs_root;
 
+	if (init_extent_tree) {
+		printf("Creating a new extent tree\n");
+		ret = reinit_extent_tree(info);
+		if (ret)
+			return ret;
+	}
 	fprintf(stderr, "checking extents\n");
 	if (init_csum_tree) {
 		struct btrfs_trans_handle *trans;
@@ -4751,7 +5109,7 @@ int cmd_check(int argc, char **argv)
 			return PTR_ERR(trans);
 		}
 
-		ret = btrfs_fsck_reinit_root(trans, info->csum_root);
+		ret = btrfs_fsck_reinit_root(trans, info->csum_root, 0);
 		if (ret) {
 			fprintf(stderr, "crc root initialization failed\n");
 			return -EIO;
diff --git a/ctree.c b/ctree.c
index 4598665..2a400ec 100644
--- a/ctree.c
+++ b/ctree.c
@@ -138,7 +138,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root)
+			   struct btrfs_root *root, int overwrite)
 {
 	struct extent_buffer *c;
 	struct extent_buffer *old = root->node;
@@ -147,6 +147,11 @@ int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 
 	level = 0;
 
+	if (overwrite) {
+		c = old;
+		extent_buffer_get(c);
+		goto init;
+	}
 	c = btrfs_alloc_free_block(trans, root,
 				   btrfs_level_size(root, 0),
 				   root->root_key.objectid,
@@ -155,7 +160,7 @@ int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 		c = old;
 		extent_buffer_get(c);
 	}
-
+init:
 	memset_extent_buffer(c, 0, 0, sizeof(struct btrfs_header));
 	btrfs_set_header_level(c, level);
 	btrfs_set_header_bytenr(c, c->start);
diff --git a/ctree.h b/ctree.h
index 615bce4..4966549 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2132,6 +2132,9 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				    struct btrfs_root *root);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
 int btrfs_read_block_groups(struct btrfs_root *root);
+struct btrfs_block_group_cache *
+btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
+		      u64 chunk_objectid, u64 chunk_offset, u64 size);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
@@ -2151,7 +2154,7 @@ int btrfs_check_leaf(struct btrfs_root *root,
 		      struct btrfs_disk_key *parent_key,
 		      struct extent_buffer *buf);
 int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
-		      struct btrfs_root *root);
+			   struct btrfs_root *root, int overwrite);
 void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 			     int level, int slot, u64 objectid);
 struct extent_buffer *read_node_slot(struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index 7906664..91bc513 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3340,19 +3340,16 @@ error:
 	return ret;
 }
 
-int btrfs_make_block_group(struct btrfs_trans_handle *trans,
-			   struct btrfs_root *root, u64 bytes_used,
-			   u64 type, u64 chunk_objectid, u64 chunk_offset,
-			   u64 size)
+struct btrfs_block_group_cache *
+btrfs_add_block_group(struct btrfs_fs_info *fs_info, u64 bytes_used, u64 type,
+		      u64 chunk_objectid, u64 chunk_offset, u64 size)
 {
 	int ret;
 	int bit = 0;
-	struct btrfs_root *extent_root;
 	struct btrfs_block_group_cache *cache;
 	struct extent_io_tree *block_group_cache;
 
-	extent_root = root->fs_info->extent_root;
-	block_group_cache = &root->fs_info->block_group_cache;
+	block_group_cache = &fs_info->block_group_cache;
 
 	cache = kzalloc(sizeof(*cache), GFP_NOFS);
 	BUG_ON(!cache);
@@ -3365,7 +3362,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	cache->flags = type;
 	btrfs_set_block_group_flags(&cache->item, type);
 
-	ret = update_space_info(root->fs_info, cache->flags, size, bytes_used,
+	ret = update_space_info(fs_info, cache->flags, size, bytes_used,
 				&cache->space_info);
 	BUG_ON(ret);
 
@@ -3376,13 +3373,29 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 
 	set_state_private(block_group_cache, chunk_offset,
 			  (unsigned long)cache);
+	set_avail_alloc_bits(fs_info, type);
+
+	return cache;
+}
+
+int btrfs_make_block_group(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root, u64 bytes_used,
+			   u64 type, u64 chunk_objectid, u64 chunk_offset,
+			   u64 size)
+{
+	int ret;
+	struct btrfs_root *extent_root;
+	struct btrfs_block_group_cache *cache;
+
+	cache = btrfs_add_block_group(root->fs_info, bytes_used, type,
+				      chunk_objectid, chunk_offset, size);
+	extent_root = root->fs_info->extent_root;
 	ret = btrfs_insert_item(trans, extent_root, &cache->key, &cache->item,
 				sizeof(cache->item));
 	BUG_ON(ret);
 
 	finish_current_insert(trans, extent_root);
 	ret = del_pending_extents(trans, extent_root);
-	set_avail_alloc_bits(extent_root->fs_info, type);
 	return 0;
 }
 
-- 
1.7.7.6

