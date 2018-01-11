Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54301 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753729AbeAKFKG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:06 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 9966548AEA13
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:52 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/67] btrfs-progs: add the stack prefix for root_generation set/get function
Date: Thu, 11 Jan 2018 13:08:39 +0800
Message-ID: <20180111050939.21251-8-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_generation set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 btrfs-list.c     |  4 ++--
 cmds-check.c     | 14 ++++++++------
 convert/common.c |  2 +-
 convert/main.c   |  2 +-
 ctree.h          |  2 +-
 disk-io.c        |  4 ++--
 mkfs/common.c    |  2 +-
 mkfs/main.c      |  4 ++--
 print-tree.c     |  2 +-
 root-tree.c      |  4 ++--
 send-utils.c     |  2 +-
 transaction.c    |  4 ++--
 12 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index ffd143c0..5b870ba6 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -747,7 +747,7 @@ static u64 find_root_gen(int fd)
 			if (sh.objectid == ino_args.treeid &&
 			    sh.type == BTRFS_ROOT_ITEM_KEY) {
 				max_found = max(max_found,
-						btrfs_root_generation(item));
+					btrfs_stack_root_generation(item));
 			}
 		}
 		if (sk->min_offset < (u64)-1)
@@ -1023,7 +1023,7 @@ static int list_subvol_search(int fd, struct root_lookup *root_lookup)
 				u8 ruuid[BTRFS_UUID_SIZE];
 
 				ri = (struct btrfs_root_item *)(args.buf + off);
-				gen = btrfs_root_generation(ri);
+				gen = btrfs_stack_root_generation(ri);
 				flags = btrfs_root_flags(ri);
 				if(sh.len >
 				   sizeof(struct btrfs_root_item_v0)) {
diff --git a/cmds-check.c b/cmds-check.c
index 8c66cff1..751ac258 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13521,7 +13521,7 @@ init:
 	 * same block bytenr here.
 	 */
 	if (old->start == c->start) {
-		btrfs_set_root_generation(&root->root_item,
+		btrfs_set_stack_root_generation(&root->root_item,
 					  trans->transid);
 		root->root_item.level = btrfs_header_level(root->node);
 		ret = btrfs_update_root(trans, root->fs_info->tree_root,
@@ -14378,7 +14378,7 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 
 	if (btrfs_root_bytenr(&ri) != rii->bytenr ||
 	    btrfs_root_level(&ri) != rii->level ||
-	    btrfs_root_generation(&ri) != rii->gen) {
+	    btrfs_stack_root_generation(&ri) != rii->gen) {
 
 		/*
 		 * If we're in repair mode but our caller told us to not update
@@ -14394,21 +14394,23 @@ static int maybe_repair_root_item(struct btrfs_path *path,
 				" new bytenr %llu, new gen %llu, new level %u\n",
 				(read_only_mode ? "" : "fixing "),
 				root_id,
-				btrfs_root_bytenr(&ri), btrfs_root_generation(&ri),
+				btrfs_root_bytenr(&ri),
+				btrfs_stack_root_generation(&ri),
 				btrfs_root_level(&ri),
 				rii->bytenr, rii->gen, rii->level);
 
-		if (btrfs_root_generation(&ri) > rii->gen) {
+		if (btrfs_stack_root_generation(&ri) > rii->gen) {
 			fprintf(stderr,
 				"root %llu has a root item with a more recent gen (%llu) compared to the found root node (%llu)\n",
-				root_id, btrfs_root_generation(&ri), rii->gen);
+				root_id, btrfs_stack_root_generation(&ri),
+				rii->gen);
 			return -EINVAL;
 		}
 
 		if (!read_only_mode) {
 			btrfs_set_root_bytenr(&ri, rii->bytenr);
 			btrfs_set_root_level(&ri, rii->level);
-			btrfs_set_root_generation(&ri, rii->gen);
+			btrfs_set_stack_root_generation(&ri, rii->gen);
 			write_extent_buffer(path->nodes[0], &ri,
 					    offset, sizeof(ri));
 		}
diff --git a/convert/common.c b/convert/common.c
index b1e1dd13..81471e29 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -194,7 +194,7 @@ static void insert_temp_root_item(struct extent_buffer *buf,
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 	btrfs_set_root_refs(&root_item, 1);
 	btrfs_set_root_used(&root_item, cfg->nodesize);
-	btrfs_set_root_generation(&root_item, 1);
+	btrfs_set_stack_root_generation(&root_item, 1);
 	btrfs_set_root_bytenr(&root_item, bytenr);
 
 	memset(&disk_key, 0, sizeof(disk_key));
diff --git a/convert/main.c b/convert/main.c
index 89f92611..e8aa9d18 100644
--- a/convert/main.c
+++ b/convert/main.c
@@ -855,7 +855,7 @@ static int create_subvol(struct btrfs_trans_handle *trans,
 	memcpy(&root_item, &root->root_item, sizeof(root_item));
 	btrfs_set_root_bytenr(&root_item, tmp->start);
 	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
-	btrfs_set_root_generation(&root_item, trans->transid);
+	btrfs_set_stack_root_generation(&root_item, trans->transid);
 	free_extent_buffer(tmp);
 
 	key.objectid = root_objectid;
diff --git a/ctree.h b/ctree.h
index 92b294c9..18692d30 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2051,7 +2051,7 @@ BTRFS_SETGET_FUNCS(disk_root_refs, struct btrfs_root_item, refs, 32);
 BTRFS_SETGET_FUNCS(disk_root_bytenr, struct btrfs_root_item, bytenr, 64);
 BTRFS_SETGET_FUNCS(disk_root_level, struct btrfs_root_item, level, 8);
 
-BTRFS_SETGET_STACK_FUNCS(root_generation, struct btrfs_root_item,
+BTRFS_SETGET_STACK_FUNCS(stack_root_generation, struct btrfs_root_item,
 			 generation, 64);
 BTRFS_SETGET_STACK_FUNCS(root_bytenr, struct btrfs_root_item, bytenr, 64);
 BTRFS_SETGET_STACK_FUNCS(root_level, struct btrfs_root_item, level, 8);
diff --git a/disk-io.c b/disk-io.c
index f5edc479..3b9d94ca 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -494,7 +494,7 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 	if (ret)
 		return ret;
 
-	generation = btrfs_root_generation(&root->root_item);
+	generation = btrfs_stack_root_generation(&root->root_item);
 	root->node = read_tree_block(fs_info,
 			btrfs_root_bytenr(&root->root_item), generation);
 	if (!extent_buffer_uptodate(root->node))
@@ -606,7 +606,7 @@ out:
 		free(root);
 		return ERR_PTR(ret);
 	}
-	generation = btrfs_root_generation(&root->root_item);
+	generation = btrfs_stack_root_generation(&root->root_item);
 	root->node = read_tree_block(fs_info,
 			btrfs_root_bytenr(&root->root_item), generation);
 	if (!extent_buffer_uptodate(root->node)) {
diff --git a/mkfs/common.c b/mkfs/common.c
index 0fec2bdd..4839e3b7 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -59,7 +59,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
 	btrfs_set_root_refs(&root_item, 1);
 	btrfs_set_root_used(&root_item, cfg->nodesize);
-	btrfs_set_root_generation(&root_item, 1);
+	btrfs_set_stack_root_generation(&root_item, 1);
 
 	btrfs_set_stack_disk_key_type(&disk_key, BTRFS_ROOT_ITEM_KEY);
 	btrfs_set_stack_disk_key_offset(&disk_key, 0);
diff --git a/mkfs/main.c b/mkfs/main.c
index d817ad8d..b6727903 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -204,7 +204,7 @@ static int __recow_root(struct btrfs_trans_handle *trans,
 	struct extent_buffer *tmp;
 	int ret;
 
-	if (trans->transid != btrfs_root_generation(&root->root_item)) {
+	if (trans->transid != btrfs_stack_root_generation(&root->root_item)) {
 		extent_buffer_get(root->node);
 		ret = __btrfs_cow_block(trans, root, root->node,
 					NULL, 0, &tmp, 0, 0);
@@ -338,7 +338,7 @@ static int create_tree(struct btrfs_trans_handle *trans,
 	memcpy(&root_item, &root->root_item, sizeof(root_item));
 	btrfs_set_root_bytenr(&root_item, tmp->start);
 	btrfs_set_root_level(&root_item, btrfs_header_level(tmp));
-	btrfs_set_root_generation(&root_item, trans->transid);
+	btrfs_set_stack_root_generation(&root_item, trans->transid);
 	free_extent_buffer(tmp);
 
 	location.objectid = objectid;
diff --git a/print-tree.c b/print-tree.c
index ff4e1199..e7176af1 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -588,7 +588,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 	root_flags_to_str(btrfs_root_flags(&root_item), flags_str);
 
 	printf("\t\tgeneration %llu root_dirid %llu bytenr %llu level %hhu refs %u\n",
-		(unsigned long long)btrfs_root_generation(&root_item),
+		(unsigned long long)btrfs_stack_root_generation(&root_item),
 		(unsigned long long)btrfs_root_dirid(&root_item),
 		(unsigned long long)btrfs_root_bytenr(&root_item),
 		btrfs_root_level(&root_item),
diff --git a/root-tree.c b/root-tree.c
index 6b8f8c1c..2de63f6c 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -121,7 +121,7 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	 * Update generation_v2 so at the next mount we know the new root
 	 * fields are valid.
 	 */
-	btrfs_set_root_generation_v2(item, btrfs_root_generation(item));
+	btrfs_set_root_generation_v2(item, btrfs_stack_root_generation(item));
 
 	write_extent_buffer(l, item, ptr, sizeof(*item));
 	btrfs_mark_buffer_dirty(path->nodes[0]);
@@ -139,7 +139,7 @@ int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	/*
 	 * Make sure generation v1 and v2 match. See update_root for details.
 	 */
-	btrfs_set_root_generation_v2(item, btrfs_root_generation(item));
+	btrfs_set_root_generation_v2(item, btrfs_stack_root_generation(item));
 	ret = btrfs_insert_item(trans, root, key, item, sizeof(*item));
 	return ret;
 }
diff --git a/send-utils.c b/send-utils.c
index 384cc5b7..3da6b9c7 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -153,7 +153,7 @@ static int btrfs_read_root_item(int mnt_fd, u64 root_id,
 		return ret;
 
 	if (read_len < sizeof(*item) ||
-	    btrfs_root_generation(item) != btrfs_root_generation_v2(item))
+	    btrfs_stack_root_generation(item) != btrfs_root_generation_v2(item))
 		memset(&item->generation_v2, 0,
 			sizeof(*item) - offsetof(struct btrfs_root_item,
 						 generation_v2));
diff --git a/transaction.c b/transaction.c
index ad705728..1cc27ff0 100644
--- a/transaction.c
+++ b/transaction.c
@@ -67,7 +67,7 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 			break;
 		btrfs_set_root_bytenr(&root->root_item,
 				       root->node->start);
-		btrfs_set_root_generation(&root->root_item,
+		btrfs_set_stack_root_generation(&root->root_item,
 					  trans->transid);
 		root->root_item.level = btrfs_header_level(root->node);
 		ret = btrfs_update_root(trans, tree_root,
@@ -158,7 +158,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	root->commit_root = NULL;
 
 	btrfs_set_root_bytenr(&root->root_item, root->node->start);
-	btrfs_set_root_generation(&root->root_item, trans->transid);
+	btrfs_set_stack_root_generation(&root->root_item, trans->transid);
 	root->root_item.level = btrfs_header_level(root->node);
 	ret = btrfs_update_root(trans, root->fs_info->tree_root,
 				&root->root_key, &root->root_item);
-- 
2.15.1



