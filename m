Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38683 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbaCRMFC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 08:05:02 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2IC4uW6001921
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 20:04:57 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] Btrfs-progs: fsck: deal with snapshot one by one when rebuilding extent tree
Date: Tue, 18 Mar 2014 20:02:44 +0800
Message-Id: <1395144167-775-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously, we deal with node block firstly and then leaf block which can
maximize readahead. However, to rebuild extent tree, we need deal with snapshot
one by one.

This patch makes us deal with snapshot one by one if we need rebuild extent
tree otherwise we drop into previous way.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 248 +++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 158 insertions(+), 90 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index b3f7e22..e40b806 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -123,10 +123,14 @@ struct inode_backref {
 	char name[0];
 };
 
-struct dropping_root_item_record {
+struct root_item_record {
 	struct list_head list;
-	struct btrfs_root_item ri;
-	struct btrfs_key found_key;
+	u64 objectid;
+	u64 bytenr;
+	u8 level;
+	u8 drop_level;
+	int level_size;
+	struct btrfs_key drop_key;
 };
 
 #define REF_ERR_NO_DIR_ITEM		(1 << 0)
@@ -3839,7 +3843,7 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 			  struct rb_root *dev_cache,
 			  struct block_group_tree *block_group_cache,
 			  struct device_extent_tree *dev_extent_cache,
-			  struct btrfs_root_item *ri)
+			  struct root_item_record *ri)
 {
 	struct extent_buffer *buf;
 	u64 bytenr;
@@ -4072,11 +4076,8 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 			size = btrfs_level_size(root, level - 1);
 			btrfs_node_key_to_cpu(buf, &key, i);
 			if (ri != NULL) {
-				struct btrfs_key drop_key;
-				btrfs_disk_key_to_cpu(&drop_key,
-						      &ri->drop_progress);
 				if ((level == ri->drop_level)
-				    && is_dropped_key(&key, &drop_key)) {
+				    && is_dropped_key(&key, &ri->drop_key)) {
 					continue;
 				}
 			}
@@ -4117,7 +4118,7 @@ static int add_root_to_pending(struct extent_buffer *buf,
 			       struct cache_tree *pending,
 			       struct cache_tree *seen,
 			       struct cache_tree *nodes,
-			       struct btrfs_key *root_key)
+			       u64 objectid)
 {
 	if (btrfs_header_level(buf) > 0)
 		add_pending(nodes, seen, buf->start, buf->len);
@@ -4126,13 +4127,12 @@ static int add_root_to_pending(struct extent_buffer *buf,
 	add_extent_rec(extent_cache, NULL, 0, buf->start, buf->len,
 		       0, 1, 1, 0, 1, 0, buf->len);
 
-	if (root_key->objectid == BTRFS_TREE_RELOC_OBJECTID ||
+	if (objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
 		add_tree_backref(extent_cache, buf->start, buf->start,
 				 0, 1);
 	else
-		add_tree_backref(extent_cache, buf->start, 0,
-				 root_key->objectid, 1);
+		add_tree_backref(extent_cache, buf->start, 0, objectid, 1);
 	return 0;
 }
 
@@ -5695,6 +5695,99 @@ static int check_devices(struct rb_root *dev_cache,
 	return ret;
 }
 
+static int add_root_item_to_list(struct list_head *head,
+				  u64 objectid, u64 bytenr,
+				  u8 level, u8 drop_level,
+				  int level_size, struct btrfs_key *drop_key)
+{
+
+	struct root_item_record *ri_rec;
+	ri_rec = malloc(sizeof(*ri_rec));
+	if (!ri_rec)
+		return -ENOMEM;
+	ri_rec->bytenr = bytenr;
+	ri_rec->objectid = objectid;
+	ri_rec->level = level;
+	ri_rec->level_size = level_size;
+	ri_rec->drop_level = drop_level;
+	if (drop_key)
+		memcpy(&ri_rec->drop_key, drop_key, sizeof(*drop_key));
+	list_add_tail(&ri_rec->list, head);
+
+	return 0;
+}
+
+static int deal_root_from_list(struct list_head *list,
+			       struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct block_info *bits,
+			       int bits_nr,
+			       struct cache_tree *pending,
+			       struct cache_tree *seen,
+			       struct cache_tree *reada,
+			       struct cache_tree *nodes,
+			       struct cache_tree *extent_cache,
+			       struct cache_tree *chunk_cache,
+			       struct rb_root *dev_cache,
+			       struct block_group_tree *block_group_cache,
+			       struct device_extent_tree *dev_extent_cache)
+{
+	int ret = 0;
+	u64 last;
+
+	while (!list_empty(list)) {
+		struct root_item_record *rec;
+		struct extent_buffer *buf;
+		rec = list_entry(list->next,
+				 struct root_item_record, list);
+		last = 0;
+		buf = read_tree_block(root->fs_info->tree_root,
+				      rec->bytenr, rec->level_size, 0);
+		if (!extent_buffer_uptodate(buf)) {
+			free_extent_buffer(buf);
+			ret = -EIO;
+			break;
+		}
+		add_root_to_pending(buf, extent_cache, pending,
+				    seen, nodes, rec->objectid);
+		/*
+		 * To rebuild extent tree, we need deal with snapshot
+		 * one by one, otherwise we deal with node firstly which
+		 * can maximize readahead.
+		 */
+		if (!init_extent_tree && !rec->drop_level)
+			goto skip;
+		while (1) {
+			ret = run_next_block(trans, root, bits, bits_nr, &last,
+					     pending, seen, reada,
+					     nodes, extent_cache,
+					     chunk_cache, dev_cache,
+					     block_group_cache,
+					     dev_extent_cache, rec);
+			if (ret != 0)
+				break;
+		}
+skip:
+		free_extent_buffer(buf);
+		list_del(&rec->list);
+		free(rec);
+	}
+	while (ret >= 0) {
+		ret = run_next_block(trans, root, bits, bits_nr, &last,
+				     pending, seen, reada,
+				     nodes, extent_cache,
+				     chunk_cache, dev_cache,
+				     block_group_cache,
+				     dev_extent_cache, NULL);
+		if (ret != 0) {
+			if (ret > 0)
+				ret = 0;
+			break;
+		}
+	}
+	return ret;
+}
+
 static int check_chunks_and_extents(struct btrfs_root *root)
 {
 	struct rb_root dev_cache;
@@ -5711,7 +5804,6 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	int ret, err = 0;
-	u64 last = 0;
 	struct block_info *bits;
 	int bits_nr;
 	struct extent_buffer *leaf;
@@ -5719,6 +5811,11 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 	int slot;
 	struct btrfs_root_item ri;
 	struct list_head dropping_trees;
+	struct list_head normal_trees;
+	struct btrfs_root *root1;
+	u64 objectid;
+	u32 level_size;
+	u8 level;
 
 	dev_cache = RB_ROOT;
 	cache_tree_init(&chunk_cache);
@@ -5732,6 +5829,7 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 	cache_tree_init(&reada);
 	cache_tree_init(&corrupt_blocks);
 	INIT_LIST_HEAD(&dropping_trees);
+	INIT_LIST_HEAD(&normal_trees);
 
 	if (repair) {
 		trans = btrfs_start_transaction(root, 1);
@@ -5752,14 +5850,20 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 	}
 
 again:
-	add_root_to_pending(root->fs_info->tree_root->node,
-			    &extent_cache, &pending, &seen, &nodes,
-			    &root->fs_info->tree_root->root_key);
-
-	add_root_to_pending(root->fs_info->chunk_root->node,
-			    &extent_cache, &pending, &seen, &nodes,
-			    &root->fs_info->chunk_root->root_key);
-
+	root1 = root->fs_info->tree_root;
+	level = btrfs_header_level(root1->node);
+	ret = add_root_item_to_list(&normal_trees, root1->root_key.objectid,
+				    root1->node->start, level, 0,
+				    btrfs_level_size(root1, level), NULL);
+	if (ret < 0)
+		goto out;
+	root1 = root->fs_info->chunk_root;
+	level = btrfs_header_level(root1->node);
+	ret = add_root_item_to_list(&normal_trees, root1->root_key.objectid,
+				    root1->node->start, level, 0,
+				    btrfs_level_size(root1, level), NULL);
+	if (ret < 0)
+		goto out;
 	btrfs_init_path(&path);
 	key.offset = 0;
 	key.objectid = 0;
@@ -5780,86 +5884,50 @@ again:
 		btrfs_item_key_to_cpu(leaf, &found_key, path.slots[0]);
 		if (btrfs_key_type(&found_key) == BTRFS_ROOT_ITEM_KEY) {
 			unsigned long offset;
-			struct extent_buffer *buf;
 
 			offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
 			if (btrfs_disk_key_objectid(&ri.drop_progress) == 0) {
-				buf = read_tree_block(root->fs_info->tree_root,
-						      btrfs_root_bytenr(&ri),
-						      btrfs_level_size(root,
-						      btrfs_root_level(&ri)),
-						      0);
-				if (!buf) {
-					ret = -EIO;
+				level = btrfs_root_level(&ri);
+				level_size = btrfs_level_size(root, level);
+				ret = add_root_item_to_list(&normal_trees,
+						found_key.objectid,
+						btrfs_root_bytenr(&ri), level,
+						0, level_size, NULL);
+				if (ret < 0)
 					goto out;
-				}
-				add_root_to_pending(buf, &extent_cache,
-						    &pending, &seen, &nodes,
-						    &found_key);
-				free_extent_buffer(buf);
 			} else {
-				struct dropping_root_item_record *dri_rec;
-				dri_rec = malloc(sizeof(*dri_rec));
-				if (!dri_rec) {
-					perror("malloc");
-					exit(1);
-				}
-				memcpy(&dri_rec->ri, &ri, sizeof(ri));
-				memcpy(&dri_rec->found_key, &found_key,
-				       sizeof(found_key));
-				list_add_tail(&dri_rec->list, &dropping_trees);
+				level = btrfs_root_level(&ri);
+				level_size = btrfs_level_size(root, level);
+				objectid = found_key.objectid;
+				btrfs_disk_key_to_cpu(&found_key,
+						      &ri.drop_progress);
+				ret = add_root_item_to_list(&dropping_trees,
+						objectid,
+						btrfs_root_bytenr(&ri),
+						level, ri.drop_level,
+						level_size, &found_key);
+				if (ret < 0)
+					goto out;
 			}
 		}
 		path.slots[0]++;
 	}
 	btrfs_release_path(&path);
-	while (1) {
-		ret = run_next_block(trans, root, bits, bits_nr, &last,
-				     &pending, &seen, &reada, &nodes,
-				     &extent_cache, &chunk_cache, &dev_cache,
-				     &block_group_cache, &dev_extent_cache,
-				     NULL);
-		if (ret != 0)
-			break;
-	}
-
-	while (!list_empty(&dropping_trees)) {
-		struct dropping_root_item_record *rec;
-		struct extent_buffer *buf;
-		rec = list_entry(dropping_trees.next,
-				 struct dropping_root_item_record, list);
-		last = 0;
-		if (!bits) {
-			perror("realloc");
-			exit(1);
-		}
-		buf = read_tree_block(root->fs_info->tree_root,
-				      btrfs_root_bytenr(&rec->ri),
-				      btrfs_level_size(root,
-				      btrfs_root_level(&rec->ri)), 0);
-		if (!buf) {
-			ret = -EIO;
-			goto out;
-		}
-		add_root_to_pending(buf, &extent_cache, &pending,
-				    &seen, &nodes, &rec->found_key);
-		while (1) {
-			ret = run_next_block(trans, root, bits, bits_nr, &last,
-					     &pending, &seen, &reada,
-					     &nodes, &extent_cache,
-					     &chunk_cache, &dev_cache,
-					     &block_group_cache,
-					     &dev_extent_cache,
-					     &rec->ri);
-			if (ret != 0)
-				break;
-		}
-		free_extent_buffer(buf);
-		list_del(&rec->list);
-		free(rec);
-	}
-
+	ret = deal_root_from_list(&normal_trees, trans, root,
+				  bits, bits_nr, &pending, &seen,
+				  &reada, &nodes, &extent_cache,
+				  &chunk_cache, &dev_cache, &block_group_cache,
+				  &dev_extent_cache);
+	if (ret < 0)
+		goto out;
+	ret = deal_root_from_list(&dropping_trees, trans, root,
+				  bits, bits_nr, &pending, &seen,
+				  &reada, &nodes, &extent_cache,
+				  &chunk_cache, &dev_cache, &block_group_cache,
+				  &dev_extent_cache);
+	if (ret < 0)
+		goto out;
 	if (ret >= 0)
 		ret = check_extent_refs(trans, root, &extent_cache);
 	if (ret == -EAGAIN) {
-- 
1.9.0

