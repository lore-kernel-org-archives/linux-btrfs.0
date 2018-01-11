Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753749AbeAKFKH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:07 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1D001486A78B
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:53 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/67] btrfs-progs: add the stack prefix for root_bytenr set/get function
Date: Thu, 11 Jan 2018 13:08:40 +0800
Message-ID: <20180111050939.21251-9-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_bytenr set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c             | 12 ++++++------
 cmds-inspect-dump-tree.c |  3 ++-
 cmds-restore.c           |  2 +-
 convert/common.c         |  2 +-
 convert/main.c           |  2 +-
 ctree.h                  |  2 +-
 disk-io.c                |  4 ++--
 mkfs/common.c            |  2 +-
 mkfs/main.c              |  2 +-
 print-tree.c             |  2 +-
 transaction.c            |  6 +++---
 11 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 751ac258..3c366109 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2194,7 +2194,7 @@ static int calc_extent_flag_v2(struct btrfs_root *root, struct extent_buffer *eb
 		goto normal;
 
 	/* root node */
-	if (eb->start == btrfs_root_bytenr(ri))
+	if (eb->start == btrfs_stack_root_bytenr(ri))
 		goto normal;
 
 	if (btrfs_header_flag(eb, BTRFS_HEADER_FLAG_RELOC))
@@ -11544,7 +11544,7 @@ again:
 				level = btrfs_root_level(&ri);
 				ret = add_root_item_to_list(&normal_trees,
 						found_key.objectid,
-						btrfs_root_bytenr(&ri),
+						btrfs_stack_root_bytenr(&ri),
 						last_snapshot, level,
 						0, NULL);
 				if (ret < 0)
@@ -11556,7 +11556,7 @@ again:
 						      &ri.drop_progress);
 				ret = add_root_item_to_list(&dropping_trees,
 						objectid,
-						btrfs_root_bytenr(&ri),
+						btrfs_stack_root_bytenr(&ri),
 						last_snapshot, level,
 						ri.drop_level, &found_key);
 				if (ret < 0)
@@ -14376,7 +14376,7 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 	offset = btrfs_item_ptr_offset(path->nodes[0], path->slots[0]);
 	read_extent_buffer(path->nodes[0], &ri, offset, sizeof(ri));
 
-	if (btrfs_root_bytenr(&ri) != rii->bytenr ||
+	if (btrfs_stack_root_bytenr(&ri) != rii->bytenr ||
 	    btrfs_root_level(&ri) != rii->level ||
 	    btrfs_stack_root_generation(&ri) != rii->gen) {
 
@@ -14394,7 +14394,7 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 				" new bytenr %llu, new gen %llu, new level %u\n",
 				(read_only_mode ? "" : "fixing "),
 				root_id,
-				btrfs_root_bytenr(&ri),
+				btrfs_stack_root_bytenr(&ri),
 				btrfs_stack_root_generation(&ri),
 				btrfs_root_level(&ri),
 				rii->bytenr, rii->gen, rii->level);
@@ -14408,7 +14408,7 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 		}
 
 		if (!read_only_mode) {
-			btrfs_set_root_bytenr(&ri, rii->bytenr);
+			btrfs_set_stack_root_bytenr(&ri, rii->bytenr);
 			btrfs_set_root_level(&ri, rii->level);
 			btrfs_set_stack_root_generation(&ri, rii->gen);
 			write_extent_buffer(path->nodes[0], &ri,
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index df44bb63..66e7227d 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -438,7 +438,8 @@ again:
 
 			offset = btrfs_item_ptr_offset(leaf, slot);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
-			buf = read_tree_block(info, btrfs_root_bytenr(&ri), 0);
+			buf = read_tree_block(info,
+					      btrfs_stack_root_bytenr(&ri), 0);
 			if (!extent_buffer_uptodate(buf))
 				goto next;
 			if (tree_id && found_key.objectid != tree_id) {
diff --git a/cmds-restore.c b/cmds-restore.c
index 6196a1ed..2f72fbbf 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1263,7 +1263,7 @@ static int do_list_roots(struct btrfs_root *root)
 		read_extent_buffer(leaf, &ri, offset, sizeof(ri));
 		printf(" tree ");
 		btrfs_print_key(&disk_key);
-		printf(" %Lu level %d\n", btrfs_root_bytenr(&ri),
+		printf(" %Lu level %d\n", btrfs_stack_root_bytenr(&ri),
 		       btrfs_root_level(&ri));
 		path.slots[0]++;
 	}
diff --git a/convert/common.c b/convert/common.c
index 81471e29..17b480b9 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -195,7 +195,7 @@ static void insert_temp_root_item(struct extent_buffer *buf,
 	btrfs_set_root_refs(&root_item, 1);
 	btrfs_set_root_used(&root_item, cfg->nodesize);
 	btrfs_set_stack_root_generation(&root_item, 1);
-	btrfs_set_root_bytenr(&root_item, bytenr);
+	btrfs_set_stack_root_bytenr(&root_item, bytenr);
 
 	memset(&disk_key, 0, sizeof(disk_key));
 	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
diff --git a/convert/main.c b/convert/main.c
index e8aa9d18..8f0921c0 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -853,7 +853,7 @@ static int create_subvol(struct btrfs_trans_handle *trans,
 		return ret;
 
 	memcpy(&root_item, &root->root_item, sizeof(root_item));
-	btrfs_set_root_bytenr(&root_item, tmp->start);
+	btrfs_set_stack_root_bytenr(&root_item, tmp->start);
 	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
 	btrfs_set_stack_root_generation(&root_item, trans->transid);
 	free_extent_buffer(tmp);
diff --git a/ctree.h b/ctree.h
index 18692d30..f27326bb 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2053,7 +2053,7 @@ BTRFS_SETGET_FUNCS(disk_root_level, struct btrfs_root_item, level, 8);
 
 BTRFS_SETGET_STACK_FUNCS(stack_root_generation, struct btrfs_root_item,
 			 generation, 64);
-BTRFS_SETGET_STACK_FUNCS(root_bytenr, struct btrfs_root_item, bytenr, 64);
+BTRFS_SETGET_STACK_FUNCS(stack_root_bytenr, struct btrfs_root_item, bytenr, 64);
 BTRFS_SETGET_STACK_FUNCS(root_level, struct btrfs_root_item, level, 8);
 BTRFS_SETGET_STACK_FUNCS(root_dirid, struct btrfs_root_item, root_dirid, 64);
 BTRFS_SETGET_STACK_FUNCS(root_refs, struct btrfs_root_item, refs, 32);
diff --git a/disk-io.c b/disk-io.c
index 3b9d94ca..6f9258d2 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -496,7 +496,7 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 
 	generation = btrfs_stack_root_generation(&root->root_item);
 	root->node = read_tree_block(fs_info,
-			btrfs_root_bytenr(&root->root_item), generation);
+			btrfs_stack_root_bytenr(&root->root_item), generation);
 	if (!extent_buffer_uptodate(root->node))
 		return -EIO;
 
@@ -608,7 +608,7 @@ out:
 	}
 	generation = btrfs_stack_root_generation(&root->root_item);
 	root->node = read_tree_block(fs_info,
-			btrfs_root_bytenr(&root->root_item), generation);
+			btrfs_stack_root_bytenr(&root->root_item), generation);
 	if (!extent_buffer_uptodate(root->node)) {
 		free(root);
 		return ERR_PTR(-EIO);
diff --git a/mkfs/common.c b/mkfs/common.c
index 4839e3b7..c3599861 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -70,7 +70,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 		    || blk == MKFS_CHUNK_TREE)
 			continue;
 
-		btrfs_set_root_bytenr(&root_item, cfg->blocks[blk]);
+		btrfs_set_stack_root_bytenr(&root_item, cfg->blocks[blk]);
 		btrfs_set_stack_disk_key_objectid(&disk_key,
 			reference_root_table[blk]);
 		btrfs_set_item_key(buf, &disk_key, nritems);
diff --git a/mkfs/main.c b/mkfs/main.c
index b6727903..cda0c65b 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -336,7 +336,7 @@ static int create_tree(struct btrfs_trans_handle *trans,
 		return ret;
 
 	memcpy(&root_item, &root->root_item, sizeof(root_item));
-	btrfs_set_root_bytenr(&root_item, tmp->start);
+	btrfs_set_stack_root_bytenr(&root_item, tmp->start);
 	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
 	btrfs_set_stack_root_generation(&root_item, trans->transid);
 	free_extent_buffer(tmp);
diff --git a/print-tree.c b/print-tree.c
index e7176af1..6f5f362b 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -590,7 +590,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 	printf("\t\tgeneration %llu root_dirid %llu bytenr %llu level %hhu refs %u\n",
 		(unsigned long long)btrfs_stack_root_generation(&root_item),
 		(unsigned long long)btrfs_root_dirid(&root_item),
-		(unsigned long long)btrfs_root_bytenr(&root_item),
+		(unsigned long long)btrfs_stack_root_bytenr(&root_item),
 		btrfs_root_level(&root_item),
 		btrfs_root_refs(&root_item));
 	printf("\t\tlastsnap %llu byte_limit %llu bytes_used %llu flags 0x%llx(%s)\n",
diff --git a/transaction.c b/transaction.c
index 1cc27ff0..f709bc66 100644
--- a/transaction.c
+++ b/transaction.c
@@ -62,10 +62,10 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 
 	btrfs_write_dirty_block_groups(trans, root);
 	while(1) {
-		old_root_bytenr = btrfs_root_bytenr(&root->root_item);
+		old_root_bytenr = btrfs_stack_root_bytenr(&root->root_item);
 		if (old_root_bytenr == root->node->start)
 			break;
-		btrfs_set_root_bytenr(&root->root_item,
+		btrfs_set_stack_root_bytenr(&root->root_item,
 				       root->node->start);
 		btrfs_set_stack_root_generation(&root->root_item,
 					  trans->transid);
@@ -157,7 +157,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	free_extent_buffer(root->commit_root);
 	root->commit_root = NULL;
 
-	btrfs_set_root_bytenr(&root->root_item, root->node->start);
+	btrfs_set_stack_root_bytenr(&root->root_item, root->node->start);
 	btrfs_set_stack_root_generation(&root->root_item, trans->transid);
 	root->root_item.level = btrfs_header_level(root->node);
 	ret = btrfs_update_root(trans, root->fs_info->tree_root,
-- 
2.15.1



