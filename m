Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab3LKLa3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 06:30:29 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBBBUL67008777
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 19:30:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] Btrfs: fix an oops when doing balance relocation
Date: Wed, 11 Dec 2013 19:29:51 +0800
Message-Id: <1386761392-5002-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I hit an oops when inserting reloc root into @reloc_root_tree(it can be
easily triggered when forcing cow for relocation root)

[  866.494539]  [<ffffffffa0499579>] btrfs_init_reloc_root+0x79/0xb0 [btrfs]
[  866.495321]  [<ffffffffa044c240>] record_root_in_trans+0xb0/0x110 [btrfs]
[  866.496109]  [<ffffffffa044d758>] btrfs_record_root_in_trans+0x48/0x80 [btrfs]
[  866.496908]  [<ffffffffa0494da8>] select_reloc_root+0xa8/0x210 [btrfs]
[  866.497703]  [<ffffffffa0495c8a>] do_relocation+0x16a/0x540 [btrfs]

This is because reloc root inserted into @reloc_root_tree is not within one
transaction,reloc root may be cowed and root block bytenr will be reused then
oops happens.We should update reloc root in @reloc_root_tree when cow reloc
root node, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
v1->v2: on the right way to fix this problem.
---
 fs/btrfs/relocation.c | 70 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4c56444..55bffcf 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1266,10 +1266,10 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
 }
 
 /*
- * helper to update/delete the 'address of tree root -> reloc tree'
+ * helper to delete the 'address of tree root -> reloc tree'
  * mapping
  */
-static int __update_reloc_root(struct btrfs_root *root, int del)
+static void __del_reloc_root(struct btrfs_root *root)
 {
 	struct rb_node *rb_node;
 	struct mapping_node *node = NULL;
@@ -1277,7 +1277,7 @@ static int __update_reloc_root(struct btrfs_root *root, int del)
 
 	spin_lock(&rc->reloc_root_tree.lock);
 	rb_node = tree_search(&rc->reloc_root_tree.rb_root,
-			      root->commit_root->start);
+			      root->node->start);
 	if (rb_node) {
 		node = rb_entry(rb_node, struct mapping_node, rb_node);
 		rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
@@ -1285,23 +1285,45 @@ static int __update_reloc_root(struct btrfs_root *root, int del)
 	spin_unlock(&rc->reloc_root_tree.lock);
 
 	if (!node)
-		return 0;
+		return;
 	BUG_ON((struct btrfs_root *)node->data != root);
 
-	if (!del) {
-		spin_lock(&rc->reloc_root_tree.lock);
-		node->bytenr = root->node->start;
-		rb_node = tree_insert(&rc->reloc_root_tree.rb_root,
-				      node->bytenr, &node->rb_node);
-		spin_unlock(&rc->reloc_root_tree.lock);
-		if (rb_node)
-			backref_tree_panic(rb_node, -EEXIST, node->bytenr);
-	} else {
-		spin_lock(&root->fs_info->trans_lock);
-		list_del_init(&root->root_list);
-		spin_unlock(&root->fs_info->trans_lock);
-		kfree(node);
+	spin_lock(&root->fs_info->trans_lock);
+	list_del_init(&root->root_list);
+	spin_unlock(&root->fs_info->trans_lock);
+	kfree(node);
+}
+
+/*
+ * helper to update the 'address of tree root -> reloc tree'
+ * mapping
+ */
+static int __update_reloc_root(struct btrfs_root *root, u64 new_bytenr)
+{
+	struct rb_node *rb_node;
+	struct mapping_node *node = NULL;
+	struct reloc_control *rc = root->fs_info->reloc_ctl;
+
+	spin_lock(&rc->reloc_root_tree.lock);
+	rb_node = tree_search(&rc->reloc_root_tree.rb_root,
+			      root->node->start);
+	if (rb_node) {
+		node = rb_entry(rb_node, struct mapping_node, rb_node);
+		rb_erase(&node->rb_node, &rc->reloc_root_tree.rb_root);
 	}
+	spin_unlock(&rc->reloc_root_tree.lock);
+
+	if (!node)
+		return 0;
+	BUG_ON((struct btrfs_root *)node->data != root);
+
+	spin_lock(&rc->reloc_root_tree.lock);
+	node->bytenr = new_bytenr;
+	rb_node = tree_insert(&rc->reloc_root_tree.rb_root,
+			      node->bytenr, &node->rb_node);
+	spin_unlock(&rc->reloc_root_tree.lock);
+	if (rb_node)
+		backref_tree_panic(rb_node, -EEXIST, node->bytenr);
 	return 0;
 }
 
@@ -1422,7 +1444,6 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_root *reloc_root;
 	struct btrfs_root_item *root_item;
-	int del = 0;
 	int ret;
 
 	if (!root->reloc_root)
@@ -1434,11 +1455,9 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 	if (root->fs_info->reloc_ctl->merge_reloc_tree &&
 	    btrfs_root_refs(root_item) == 0) {
 		root->reloc_root = NULL;
-		del = 1;
+		__del_reloc_root(reloc_root);
 	}
 
-	__update_reloc_root(reloc_root, del);
-
 	if (reloc_root->commit_root != reloc_root->node) {
 		btrfs_set_root_node(root_item, reloc_root->node);
 		free_extent_buffer(reloc_root->commit_root);
@@ -2289,7 +2308,7 @@ void free_reloc_roots(struct list_head *list)
 	while (!list_empty(list)) {
 		reloc_root = list_entry(list->next, struct btrfs_root,
 					root_list);
-		__update_reloc_root(reloc_root, 1);
+		__del_reloc_root(reloc_root);
 		free_extent_buffer(reloc_root->node);
 		free_extent_buffer(reloc_root->commit_root);
 		kfree(reloc_root);
@@ -2334,7 +2353,7 @@ again:
 
 			ret = merge_reloc_root(rc, root);
 			if (ret) {
-				__update_reloc_root(reloc_root, 1);
+				__del_reloc_root(reloc_root);
 				free_extent_buffer(reloc_root->node);
 				free_extent_buffer(reloc_root->commit_root);
 				kfree(reloc_root);
@@ -4520,6 +4539,11 @@ int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
 	BUG_ON(rc->stage == UPDATE_DATA_PTRS &&
 	       root->root_key.objectid == BTRFS_DATA_RELOC_TREE_OBJECTID);
 
+	if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID) {
+		if (buf == root->node)
+			__update_reloc_root(root, cow->start);
+	}
+
 	level = btrfs_header_level(buf);
 	if (btrfs_header_generation(buf) <=
 	    btrfs_root_last_snapshot(&root->root_item))
-- 
1.8.3.1

