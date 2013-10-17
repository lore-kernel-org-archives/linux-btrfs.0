Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:30805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab3JQG10 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Oct 2013 02:27:26 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: fix btrfsck improper prompt on dropping snapshots
Date: Thu, 17 Oct 2013 14:25:29 +0800
Message-Id: <1381991129-2341-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Exec btrfsck on btrfs with snapshots that are under a dropping
progress will cause prompt on "ref mismatch".
However we do not want this kind of prompt, since an remount
operation will continue the dropping progress.
Here the prompt is nonsense.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-check.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 91 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 668af15..268cc64 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -119,6 +119,12 @@ struct inode_backref {
 	char name[0];
 };
 
+struct dropping_root_item_record {
+	struct list_head list;
+	struct btrfs_root_item ri;
+	struct btrfs_key found_key;
+};
+
 #define REF_ERR_NO_DIR_ITEM		(1 << 0)
 #define REF_ERR_NO_DIR_INDEX		(1 << 1)
 #define REF_ERR_NO_INODE_REF		(1 << 2)
@@ -3600,6 +3606,21 @@ static int check_csums(struct btrfs_root *root)
 	return errors;
 }
 
+static int is_dropped_key(struct btrfs_key *key,
+			  struct btrfs_key *drop_key) {
+	if (key->objectid < drop_key->objectid)
+		return 1;
+	else if (key->objectid == drop_key->objectid) {
+		if (key->type < drop_key->type)
+			return 1;
+		else if (key->type == drop_key->type) {
+			if (key->offset < drop_key->offset)
+				return 1;
+		}
+	}
+	return 0;
+}
+
 static int run_next_block(struct btrfs_root *root,
 			  struct block_info *bits,
 			  int bits_nr,
@@ -3612,7 +3633,8 @@ static int run_next_block(struct btrfs_root *root,
 			  struct cache_tree *chunk_cache,
 			  struct rb_root *dev_cache,
 			  struct block_group_tree *block_group_cache,
-			  struct device_extent_tree *dev_extent_cache)
+			  struct device_extent_tree *dev_extent_cache,
+			  struct btrfs_root_item *ri)
 {
 	struct extent_buffer *buf;
 	u64 bytenr;
@@ -3817,6 +3839,15 @@ static int run_next_block(struct btrfs_root *root,
 			ptr = btrfs_node_blockptr(buf, i);
 			size = btrfs_level_size(root, level - 1);
 			btrfs_node_key_to_cpu(buf, &key, i);
+			if (ri != NULL) {
+				struct btrfs_key drop_key;
+				btrfs_disk_key_to_cpu(&drop_key,
+						      &ri->drop_progress);
+				if ((level == ri->drop_level)
+				    && is_dropped_key(&key, &drop_key)) {
+					continue;
+				}
+			}
 			ret = add_extent_rec(extent_cache, &key,
 					     ptr, size, 0, 0, 1, 0, 1, 0,
 					     size);
@@ -5449,6 +5480,7 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 	struct btrfs_trans_handle *trans = NULL;
 	int slot;
 	struct btrfs_root_item ri;
+	struct list_head dropping_trees;
 
 	dev_cache = RB_ROOT;
 	cache_tree_init(&chunk_cache);
@@ -5461,6 +5493,7 @@ static int check_chunks_and_extents(struct btrfs_root *root)
 	cache_tree_init(&nodes);
 	cache_tree_init(&reada);
 	cache_tree_init(&corrupt_blocks);
+	INIT_LIST_HEAD(&dropping_trees);
 
 	if (repair) {
 		trans = btrfs_start_transaction(root, 1);
@@ -5513,26 +5546,74 @@ again:
 
 			offset = btrfs_item_ptr_offset(leaf, path.slots[0]);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
-			buf = read_tree_block(root->fs_info->tree_root,
-					      btrfs_root_bytenr(&ri),
-					      btrfs_level_size(root,
-					       btrfs_root_level(&ri)), 0);
-			add_root_to_pending(buf, &extent_cache, &pending,
-					    &seen, &nodes, &found_key);
-			free_extent_buffer(buf);
+			if (btrfs_disk_key_objectid(&ri.drop_progress) == 0) {
+				buf = read_tree_block(root->fs_info->tree_root,
+						      btrfs_root_bytenr(&ri),
+						      btrfs_level_size(root,
+						      btrfs_root_level(&ri)),
+						      0);
+				add_root_to_pending(buf, &extent_cache,
+						    &pending, &seen, &nodes,
+						    &found_key);
+				free_extent_buffer(buf);
+			} else {
+				struct dropping_root_item_record *dri_rec;
+				dri_rec = malloc(sizeof(*dri_rec));
+				if (!dri_rec) {
+					perror("malloc");
+					exit(1);
+				}
+				memcpy(&dri_rec->ri, &ri, sizeof(ri));
+				memcpy(&dri_rec->found_key, &found_key,
+				       sizeof(found_key));
+				list_add_tail(&dri_rec->list, &dropping_trees);
+			}
 		}
 		path.slots[0]++;
 	}
 	btrfs_release_path(&path);
-	while(1) {
+	while (1) {
 		ret = run_next_block(root, bits, bits_nr, &last, &pending,
 				     &seen, &reada, &nodes, &extent_cache,
 				     &chunk_cache, &dev_cache,
-				     &block_group_cache, &dev_extent_cache);
+				     &block_group_cache, &dev_extent_cache,
+				     NULL);
 		if (ret != 0)
 			break;
 	}
 
+	while (!list_empty(&dropping_trees)) {
+		struct dropping_root_item_record *rec;
+		struct extent_buffer *buf;
+		rec = list_entry(dropping_trees.next,
+				 struct dropping_root_item_record, list);
+		last = 0;
+		if (!bits) {
+			perror("realloc");
+			exit(1);
+		}
+		buf = read_tree_block(root->fs_info->tree_root,
+				      btrfs_root_bytenr(&rec->ri),
+				      btrfs_level_size(root,
+				      btrfs_root_level(&rec->ri)), 0);
+		add_root_to_pending(buf, &extent_cache, &pending,
+				    &seen, &nodes, &rec->found_key);
+		while (1) {
+			ret = run_next_block(root, bits, bits_nr, &last,
+					     &pending, &seen, &reada,
+					     &nodes, &extent_cache,
+					     &chunk_cache, &dev_cache,
+					     &block_group_cache,
+					     &dev_extent_cache,
+					     &rec->ri);
+			if (ret != 0)
+				break;
+		}
+		free_extent_buffer(buf);
+		list_del(&rec->list);
+		free(rec);
+	}
+
 	ret = check_extent_refs(trans, root, &extent_cache);
 	if (ret == -EAGAIN) {
 		ret = btrfs_commit_transaction(trans, root);
-- 
1.8.0.1

