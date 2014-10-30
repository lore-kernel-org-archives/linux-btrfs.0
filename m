Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33682 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752020AbaJ3CyI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 22:54:08 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9U2rx27000485
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 10:53:59 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: rebuild missing block group during chunk recovery if possible
Date: Thu, 30 Oct 2014 10:54:03 +0800
Message-ID: <1414637643-12271-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before the patch, chunk will be considered bad if the corresponding
block group is missing, even the only uncertain data is the 'used'
member of the block group.

This patch will try to recalculate the 'used' value of the block group
and rebuild it.
So even only chunk item and dev extent item is found, the chunk can be
recovered.
Although if extent tree is damanged and needed extent item can't be
read, the block group's 'used' value will be the block group length, to
prevent any later write/block reserve damaging the block group.
In that case, we will prompt user and recommend them to use
'--init-extent-tree' to rebuild extent tree if possible.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfsck.h       |   3 +-
 chunk-recover.c | 242 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 cmds-check.c    |  29 ++++---
 3 files changed, 234 insertions(+), 40 deletions(-)

diff --git a/btrfsck.h b/btrfsck.h
index 356c767..7a50648 100644
--- a/btrfsck.h
+++ b/btrfsck.h
@@ -179,5 +179,6 @@ btrfs_new_device_extent_record(struct extent_buffer *leaf,
 int check_chunks(struct cache_tree *chunk_cache,
 		 struct block_group_tree *block_group_cache,
 		 struct device_extent_tree *dev_extent_cache,
-		 struct list_head *good, struct list_head *bad, int silent);
+		 struct list_head *good, struct list_head *bad,
+		 struct list_head *rebuild, int silent);
 #endif
diff --git a/chunk-recover.c b/chunk-recover.c
index 6f43066..dbf98b5 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -61,6 +61,7 @@ struct recover_control {
 
 	struct list_head good_chunks;
 	struct list_head bad_chunks;
+	struct list_head rebuild_chunks;
 	struct list_head unrepaired_chunks;
 	pthread_mutex_t rc_lock;
 };
@@ -203,6 +204,7 @@ static void init_recover_control(struct recover_control *rc, int verbose,
 
 	INIT_LIST_HEAD(&rc->good_chunks);
 	INIT_LIST_HEAD(&rc->bad_chunks);
+	INIT_LIST_HEAD(&rc->rebuild_chunks);
 	INIT_LIST_HEAD(&rc->unrepaired_chunks);
 
 	rc->verbose = verbose;
@@ -529,22 +531,32 @@ static void print_check_result(struct recover_control *rc)
 		return;
 
 	printf("CHECK RESULT:\n");
-	printf("Healthy Chunks:\n");
+	printf("Recoverable Chunks:\n");
 	list_for_each_entry(chunk, &rc->good_chunks, list) {
 		print_chunk_info(chunk, "  ");
 		good++;
 		total++;
 	}
-	printf("Bad Chunks:\n");
+	list_for_each_entry(chunk, &rc->rebuild_chunks, list) {
+		print_chunk_info(chunk, "  ");
+		good++;
+		total++;
+	}
+	list_for_each_entry(chunk, &rc->unrepaired_chunks, list) {
+		print_chunk_info(chunk, "  ");
+		good++;
+		total++;
+	}
+	printf("Unrecoverable Chunks:\n");
 	list_for_each_entry(chunk, &rc->bad_chunks, list) {
 		print_chunk_info(chunk, "  ");
 		bad++;
 		total++;
 	}
 	printf("\n");
-	printf("Total Chunks:\t%d\n", total);
-	printf("  Heathy:\t%d\n", good);
-	printf("  Bad:\t%d\n", bad);
+	printf("Total Chunks:\t\t%d\n", total);
+	printf("  Recoverable:\t\t%d\n", good);
+	printf("  Unrecoverable:\t%d\n", bad);
 
 	printf("\n");
 	printf("Orphan Block Groups:\n");
@@ -555,6 +567,7 @@ static void print_check_result(struct recover_control *rc)
 	printf("Orphan Device Extents:\n");
 	list_for_each_entry(devext, &rc->devext.no_chunk_orphans, chunk_list)
 		print_device_extent_info(devext, "  ");
+	printf("\n");
 }
 
 static int check_chunk_by_metadata(struct recover_control *rc,
@@ -938,6 +951,11 @@ static int build_device_maps_by_chunk_records(struct recover_control *rc,
 		if (ret)
 			return ret;
 	}
+	list_for_each_entry(chunk, &rc->rebuild_chunks, list) {
+		ret = build_device_map_by_chunk_record(root, chunk);
+		if (ret)
+			return ret;
+	}
 	return ret;
 }
 
@@ -1168,12 +1186,31 @@ static int __rebuild_device_items(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int __insert_chunk_item(struct btrfs_trans_handle *trans,
+				struct chunk_record *chunk_rec,
+				struct btrfs_root *chunk_root)
+{
+	struct btrfs_key key;
+	struct btrfs_chunk *chunk = NULL;
+	int ret = 0;
+
+	chunk = create_chunk_item(chunk_rec);
+	if (!chunk)
+		return -ENOMEM;
+	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
+	key.type = BTRFS_CHUNK_ITEM_KEY;
+	key.offset = chunk_rec->offset;
+
+	ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
+				btrfs_chunk_item_size(chunk->num_stripes));
+	free(chunk);
+	return ret;
+}
+
 static int __rebuild_chunk_items(struct btrfs_trans_handle *trans,
 				 struct recover_control *rc,
 				 struct btrfs_root *root)
 {
-	struct btrfs_key key;
-	struct btrfs_chunk *chunk = NULL;
 	struct btrfs_root *chunk_root;
 	struct chunk_record *chunk_rec;
 	int ret;
@@ -1181,17 +1218,12 @@ static int __rebuild_chunk_items(struct btrfs_trans_handle *trans,
 	chunk_root = root->fs_info->chunk_root;
 
 	list_for_each_entry(chunk_rec, &rc->good_chunks, list) {
-		chunk = create_chunk_item(chunk_rec);
-		if (!chunk)
-			return -ENOMEM;
-
-		key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
-		key.type = BTRFS_CHUNK_ITEM_KEY;
-		key.offset = chunk_rec->offset;
-
-		ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
-				btrfs_chunk_item_size(chunk->num_stripes));
-		free(chunk);
+		ret = __insert_chunk_item(trans, chunk_rec, chunk_root);
+		if (ret)
+			return ret;
+	}
+	list_for_each_entry(chunk_rec, &rc->rebuild_chunks, list) {
+		ret = __insert_chunk_item(trans, chunk_rec, chunk_root);
 		if (ret)
 			return ret;
 	}
@@ -1255,6 +1287,131 @@ static int rebuild_sys_array(struct recover_control *rc,
 
 }
 
+static int calculate_bg_used(struct btrfs_root *extent_root,
+			     struct chunk_record *chunk_rec,
+			     struct btrfs_path *path,
+			     u64 *used)
+{
+	struct extent_buffer *node;
+	struct btrfs_key found_key;
+	int slot;
+	int ret = 0;
+	u64 used_ret = 0;
+
+	while (1) {
+		node = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(node, &found_key, slot);
+		if (found_key.objectid >= chunk_rec->offset + chunk_rec->length)
+			break;
+		if (found_key.type != BTRFS_METADATA_ITEM_KEY &&
+		    found_key.type != BTRFS_EXTENT_DATA_KEY)
+			goto next;
+		if (found_key.type == BTRFS_METADATA_ITEM_KEY)
+			used_ret += extent_root->nodesize;
+		else
+			used_ret += found_key.offset;
+next:
+		if (slot + 1 < btrfs_header_nritems(node))
+			slot++;
+		else {
+			ret = btrfs_next_leaf(extent_root, path);
+			if (ret > 0) {
+				ret = 0;
+				break;
+			}
+			if (ret < 0)
+				break;
+		}
+	}
+	if (!ret)
+		*used = used_ret;
+	return ret;
+}
+
+static int __insert_block_group(struct btrfs_trans_handle *trans,
+				struct chunk_record *chunk_rec,
+				struct btrfs_root *extent_root,
+				u64 used)
+{
+	struct btrfs_block_group_item bg_item;
+	struct btrfs_key key;
+	int ret = 0;
+
+	btrfs_set_block_group_used(&bg_item, used);
+	btrfs_set_block_group_chunk_objectid(&bg_item, used);
+	btrfs_set_block_group_flags(&bg_item, chunk_rec->type_flags);
+	key.objectid = chunk_rec->offset;
+	key.type = BTRFS_BLOCK_GROUP_ITEM_KEY;
+	key.offset = chunk_rec->length;
+
+	ret = btrfs_insert_item(trans, extent_root, &key, &bg_item,
+				sizeof(bg_item));
+	return ret;
+}
+
+/*
+ * Search through the extent tree to rebuild the 'used' member of the block
+ * group.
+ * However, since block group and extent item shares the extent tree,
+ * the extent item may also missing.
+ * In that case, we fill the 'used' with the length of the block group to
+ * ensure no write into the block group.
+ * Btrfsck will hate it but we will inform user to call '--init-extent-tree'
+ * if possible, or just salvage as much data as possible from the fs.
+ */
+static int rebuild_block_group(struct btrfs_trans_handle *trans,
+			       struct recover_control *rc,
+			       struct btrfs_root *root)
+{
+	struct chunk_record *chunk_rec;
+	struct btrfs_key search_key;
+	struct btrfs_path *path;
+	u64 used = 0;
+	int ret = 0;
+
+	if (list_empty(&rc->rebuild_chunks))
+		return 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	list_for_each_entry(chunk_rec, &rc->rebuild_chunks, list) {
+		search_key.objectid = chunk_rec->offset;
+		search_key.type = BTRFS_EXTENT_ITEM_KEY;
+		search_key.offset = 0;
+		ret = btrfs_search_slot(NULL, root->fs_info->extent_root,
+					&search_key, path, 0, 0);
+		if (ret < 0)
+			goto out;
+		ret = calculate_bg_used(root->fs_info->extent_root,
+					chunk_rec, path, &used);
+		/*
+		 * Extent tree is damaged, better to rebuild the whole extent
+		 * tree. Currently, change the used to chunk's len to prevent
+		 * write/block reserve happening in that block group.
+		 */
+		if (ret < 0) {
+			fprintf(stderr,
+				"Fail to search extent tree for block group: [%llu,%llu]\n",
+				chunk_rec->offset,
+				chunk_rec->offset + chunk_rec->length);
+			fprintf(stderr,
+				"Mark the block group full to prevent block rsv problems\n");
+			used = chunk_rec->length;
+		}
+		btrfs_release_path(path);
+		ret = __insert_block_group(trans, chunk_rec,
+					   root->fs_info->extent_root,
+					   used);
+		if (ret < 0)
+			goto out;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
 static struct btrfs_root *
 open_ctree_with_broken_chunk(struct recover_control *rc)
 {
@@ -2063,6 +2220,7 @@ static int btrfs_recover_chunks(struct recover_control *rc)
 		ret = insert_cache_extent(&rc->chunk, &chunk->cache);
 		BUG_ON(ret);
 
+		list_del_init(&bg->list);
 		if (!nstripes) {
 			list_add_tail(&chunk->list, &rc->bad_chunks);
 			continue;
@@ -2093,6 +2251,33 @@ static int btrfs_recover_chunks(struct recover_control *rc)
 	return 0;
 }
 
+static inline int is_chunk_overlap(struct chunk_record *chunk1,
+				   struct chunk_record *chunk2)
+{
+	if (chunk1->offset >= chunk2->offset + chunk2->length ||
+	    chunk1->offset + chunk1->length <= chunk2->offset)
+		return 0;
+	return 1;
+}
+
+/* Move invalid(overlap with good chunks) rebuild chunks to bad chunk list */
+static void validate_rebuild_chunks(struct recover_control *rc)
+{
+	struct chunk_record *good;
+	struct chunk_record *rebuild;
+	struct chunk_record *tmp;
+
+	list_for_each_entry_safe(rebuild, tmp, &rc->rebuild_chunks, list) {
+		list_for_each_entry(good, &rc->good_chunks, list) {
+			if (is_chunk_overlap(rebuild, good)) {
+				list_move_tail(&rebuild->list,
+					       &rc->bad_chunks);
+				break;
+			}
+		}
+	}
+}
+
 /*
  * Return 0 when succesful, < 0 on error and > 0 if aborted by user
  */
@@ -2127,8 +2312,7 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 	print_scan_result(&rc);
 
 	ret = check_chunks(&rc.chunk, &rc.bg, &rc.devext, &rc.good_chunks,
-			   &rc.bad_chunks, 1);
-	print_check_result(&rc);
+			   &rc.bad_chunks, &rc.rebuild_chunks, 1);
 	if (ret) {
 		if (!list_empty(&rc.bg.block_groups) ||
 		    !list_empty(&rc.devext.no_chunk_orphans)) {
@@ -2136,17 +2320,13 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 			if (ret)
 				goto fail_rc;
 		}
-		/*
-		 * If the chunk is healthy, its block group item and device
-		 * extent item should be written on the disks. So, it is very
-		 * likely that the bad chunk is a old one that has been
-		 * droppped from the fs. Don't deal with them now, we will
-		 * check it after the fs is opened.
-		 */
 	} else {
-		fprintf(stderr, "Check chunks successfully with no orphans\n");
+		print_check_result(&rc);
+		printf("Check chunks successfully with no orphans\n");
 		goto fail_rc;
 	}
+	validate_rebuild_chunks(&rc);
+	print_check_result(&rc);
 
 	root = open_ctree_with_broken_chunk(&rc);
 	if (IS_ERR(root)) {
@@ -2185,6 +2365,12 @@ int btrfs_recover_chunk_tree(char *path, int verbose, int yes)
 	ret = rebuild_sys_array(&rc, root);
 	BUG_ON(ret);
 
+	ret = rebuild_block_group(trans, &rc, root);
+	if (ret) {
+		printf("Fail to rebuild block groups.\n");
+		printf("Recommend to run 'btrfs check --init-extent-tree <dev>' after recovery\n");
+	}
+
 	btrfs_commit_transaction(trans, root);
 fail_close_ctree:
 	close_ctree(root);
diff --git a/cmds-check.c b/cmds-check.c
index 2a5f823..2795ccf 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6133,6 +6133,13 @@ u64 calc_stripe_length(u64 type, u64 length, int num_stripes)
 	return stripe_size;
 }
 
+/*
+ * Check the chunk with its block group/dev list ref:
+ * Return 0 if all refs seems valid.
+ * Return 1 if part of refs seems valid, need later check for rebuild ref
+ * like missing block group and needs to search extent tree to rebuild them.
+ * Return -1 if essential refs are missing and unable to rebuild.
+ */
 static int check_chunk_refs(struct chunk_record *chunk_rec,
 			    struct block_group_tree *block_group_cache,
 			    struct device_extent_tree *dev_extent_cache,
@@ -6188,7 +6195,7 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
 				chunk_rec->length,
 				chunk_rec->offset,
 				chunk_rec->type_flags);
-		ret = -1;
+		ret = 1;
 	}
 
 	length = calc_stripe_length(chunk_rec->type_flags, chunk_rec->length,
@@ -6241,7 +6248,8 @@ static int check_chunk_refs(struct chunk_record *chunk_rec,
 int check_chunks(struct cache_tree *chunk_cache,
 		 struct block_group_tree *block_group_cache,
 		 struct device_extent_tree *dev_extent_cache,
-		 struct list_head *good, struct list_head *bad, int silent)
+		 struct list_head *good, struct list_head *bad,
+		 struct list_head *rebuild, int silent)
 {
 	struct cache_extent *chunk_item;
 	struct chunk_record *chunk_rec;
@@ -6256,15 +6264,14 @@ int check_chunks(struct cache_tree *chunk_cache,
 					 cache);
 		err = check_chunk_refs(chunk_rec, block_group_cache,
 				       dev_extent_cache, silent);
-		if (err) {
+		if (err)
 			ret = err;
-			if (bad)
-				list_add_tail(&chunk_rec->list, bad);
-		} else {
-			if (good)
-				list_add_tail(&chunk_rec->list, good);
-		}
-
+		if (err == 0 && good)
+			list_add_tail(&chunk_rec->list, good);
+		if (err > 0 && rebuild)
+			list_add_tail(&chunk_rec->list, rebuild);
+		if (err < 0 && bad)
+			list_add_tail(&chunk_rec->list, bad);
 		chunk_item = next_cache_extent(chunk_item);
 	}
 
@@ -6548,7 +6555,7 @@ again:
 	}
 
 	err = check_chunks(&chunk_cache, &block_group_cache,
-			   &dev_extent_cache, NULL, NULL, 0);
+			   &dev_extent_cache, NULL, NULL, NULL, 0);
 	if (err && !ret)
 		ret = err;
 
-- 
2.1.2

