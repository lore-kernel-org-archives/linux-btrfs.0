From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Always update root items for fs trees at commit time
Date: Mon, 15 Jun 2009 21:22:31 +0800
Message-ID: <4A364B17.9030609@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

commit_fs_roots skips updating root items for fs trees that aren't modified.
This is unsafe since relocation code modifies root item's last_snapshot field
without modifying corresponding fs tree.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/transaction.c 2/fs/btrfs/transaction.c
--- 1/fs/btrfs/transaction.c	2009-06-12 21:32:39.812512710 +0800
+++ 2/fs/btrfs/transaction.c	2009-06-15 13:33:56.000000000 +0800
@@ -543,13 +543,13 @@ static noinline int commit_fs_roots(stru
 			btrfs_free_log(trans, root);
 			btrfs_update_reloc_root(trans, root);
 
-			if (root->commit_root == root->node)
-				continue;
+			if (root->commit_root != root->node) {
+				free_extent_buffer(root->commit_root);
+				root->commit_root = btrfs_root_node(root);
+				btrfs_set_root_node(&root->root_item,
+						    root->node);
+			}
 
-			free_extent_buffer(root->commit_root);
-			root->commit_root = btrfs_root_node(root);
-
-			btrfs_set_root_node(&root->root_item, root->node);
 			err = btrfs_update_root(trans, fs_info->tree_root,
 						&root->root_key,
 						&root->root_item);
