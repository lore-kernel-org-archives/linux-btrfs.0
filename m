Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42499 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753812AbeAKFKJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 00:10:09 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 2B70848AEA0C
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 13:09:55 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 11/67] btrfs-progs: add the stack prefix for root_refs set/get function
Date: Thu, 11 Jan 2018 13:08:43 +0800
Message-ID: <20180111050939.21251-12-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The root_refs set/get function defined by
BTRFS_SETGET_STACK_FUNCS macro is missing the prefix stack.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c     | 16 ++++++++--------
 convert/common.c |  2 +-
 ctree.h          |  2 +-
 mkfs/common.c    |  2 +-
 print-tree.c     |  2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 836f3c7e..b79e9f6c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1449,7 +1449,7 @@ static int enter_shared_node(struct btrfs_root *root, u64 bytenr, u32 refs,
 	}
 
 	if (wc->root_level == wc->active_node &&
-	    btrfs_root_refs(&root->root_item) == 0) {
+	    btrfs_stack_root_refs(&root->root_item) == 0) {
 		if (--node->refs == 0) {
 			free_inode_recs_tree(&node->root_cache);
 			free_inode_recs_tree(&node->inode_cache);
@@ -1490,7 +1490,7 @@ static int leave_shared_node(struct btrfs_root *root,
 
 	dest = wc->nodes[wc->active_node];
 	if (wc->active_node < wc->root_level ||
-	    btrfs_root_refs(&root->root_item) > 0) {
+	    btrfs_stack_root_refs(&root->root_item) > 0) {
 		BUG_ON(node->refs <= 1);
 		splice_shared_node(node, dest);
 	} else {
@@ -1921,7 +1921,7 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 	struct shared_node *active_node;
 
 	if (wc->root_level == wc->active_node &&
-	    btrfs_root_refs(&root->root_item) == 0)
+	    btrfs_stack_root_refs(&root->root_item) == 0)
 		return 0;
 
 	active_node = wc->nodes[wc->active_node];
@@ -3846,7 +3846,7 @@ static int check_inode_recs(struct btrfs_root *root,
 	u64 error = 0;
 	u64 root_dirid = btrfs_stack_root_dirid(&root->root_item);
 
-	if (btrfs_root_refs(&root->root_item) == 0) {
+	if (btrfs_stack_root_refs(&root->root_item) == 0) {
 		if (!cache_tree_empty(inode_cache))
 			fprintf(stderr, "warning line %d\n", __LINE__);
 		return 0;
@@ -4453,7 +4453,7 @@ static int check_fs_root(struct btrfs_root *root,
 	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
 		rec = get_root_rec(root_cache, root->root_key.objectid);
 		BUG_ON(IS_ERR(rec));
-		if (btrfs_root_refs(root_item) > 0)
+		if (btrfs_stack_root_refs(root_item) > 0)
 			rec->found_root_item = 1;
 	}
 
@@ -4489,7 +4489,7 @@ static int check_fs_root(struct btrfs_root *root,
 	if (status != BTRFS_TREE_BLOCK_CLEAN)
 		return -EIO;
 
-	if (btrfs_root_refs(root_item) > 0 ||
+	if (btrfs_stack_root_refs(root_item) > 0 ||
 	    btrfs_stack_disk_key_objectid(&root_item->drop_progress) == 0) {
 		path.nodes[level] = root->node;
 		extent_buffer_get(root->node);
@@ -6442,7 +6442,7 @@ static int check_fs_first_inode(struct btrfs_root *root, unsigned int ext_ref)
 	key.offset = 0;
 
 	/* For root being dropped, we don't need to check first inode */
-	if (btrfs_root_refs(&root->root_item) == 0 &&
+	if (btrfs_stack_root_refs(&root->root_item) == 0 &&
 	    btrfs_stack_disk_key_objectid(&root->root_item.drop_progress) >=
 	    BTRFS_FIRST_FREE_OBJECTID)
 		return 0;
@@ -6588,7 +6588,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 	level = btrfs_header_level(root->node);
 	btrfs_init_path(&path);
 
-	if (btrfs_root_refs(root_item) > 0 ||
+	if (btrfs_stack_root_refs(root_item) > 0 ||
 	    btrfs_stack_disk_key_objectid(&root_item->drop_progress) == 0) {
 		path.nodes[level] = root->node;
 		path.slots[level] = 0;
diff --git a/convert/common.c b/convert/common.c
index 17b480b9..304ee6ed 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -192,7 +192,7 @@ static void insert_temp_root_item(struct extent_buffer *buf,
 	btrfs_set_stack_inode_nlink(inode_item, 1);
 	btrfs_set_stack_inode_nbytes(inode_item, cfg->nodesize);
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
-	btrfs_set_root_refs(&root_item, 1);
+	btrfs_set_stack_root_refs(&root_item, 1);
 	btrfs_set_root_used(&root_item, cfg->nodesize);
 	btrfs_set_stack_root_generation(&root_item, 1);
 	btrfs_set_stack_root_bytenr(&root_item, bytenr);
diff --git a/ctree.h b/ctree.h
index 7a59665b..9b96268a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2057,7 +2057,7 @@ BTRFS_SETGET_STACK_FUNCS(stack_root_bytenr, struct btrfs_root_item, bytenr, 64);
 BTRFS_SETGET_STACK_FUNCS(stack_root_level, struct btrfs_root_item, level, 8);
 BTRFS_SETGET_STACK_FUNCS(stack_root_dirid, struct btrfs_root_item, root_dirid,
 			 64);
-BTRFS_SETGET_STACK_FUNCS(root_refs, struct btrfs_root_item, refs, 32);
+BTRFS_SETGET_STACK_FUNCS(stack_root_refs, struct btrfs_root_item, refs, 32);
 BTRFS_SETGET_STACK_FUNCS(root_flags, struct btrfs_root_item, flags, 64);
 BTRFS_SETGET_STACK_FUNCS(root_used, struct btrfs_root_item, bytes_used, 64);
 BTRFS_SETGET_STACK_FUNCS(root_limit, struct btrfs_root_item, byte_limit, 64);
diff --git a/mkfs/common.c b/mkfs/common.c
index c3599861..82859503 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -57,7 +57,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 	btrfs_set_stack_inode_nlink(inode_item, 1);
 	btrfs_set_stack_inode_nbytes(inode_item, cfg->nodesize);
 	btrfs_set_stack_inode_mode(inode_item, S_IFDIR | 0755);
-	btrfs_set_root_refs(&root_item, 1);
+	btrfs_set_stack_root_refs(&root_item, 1);
 	btrfs_set_root_used(&root_item, cfg->nodesize);
 	btrfs_set_stack_root_generation(&root_item, 1);
 
diff --git a/print-tree.c b/print-tree.c
index 7a1626ea..8c53bb85 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -592,7 +592,7 @@ static void print_root_item(struct extent_buffer *leaf, int slot)
 		(unsigned long long)btrfs_stack_root_dirid(&root_item),
 		(unsigned long long)btrfs_stack_root_bytenr(&root_item),
 		btrfs_stack_root_level(&root_item),
-		btrfs_root_refs(&root_item));
+		btrfs_stack_root_refs(&root_item));
 	printf("\t\tlastsnap %llu byte_limit %llu bytes_used %llu flags 0x%llx(%s)\n",
 		(unsigned long long)btrfs_root_last_snapshot(&root_item),
 		(unsigned long long)btrfs_root_limit(&root_item),
-- 
2.15.1



