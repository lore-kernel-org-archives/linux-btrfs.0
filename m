Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47547 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab2KZJZQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 04:25:16 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ9PFqs009726
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 17:25:15 +0800
Message-ID: <50B33592.4090204@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 17:25:38 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/5] Btrfs: fix unprotected defragable inode insertion
References: <50B32FE7.5080908@cn.fujitsu.com>
In-Reply-To: <50B32FE7.5080908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forget to get the defrag lock when we re-add the defragable inode,
Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 70 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 924ce79..b59f12ef 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -91,7 +91,7 @@ static int __compare_inode_defrag(struct inode_defrag *defrag1,
  * If an existing record is found the defrag item you
  * pass in is freed
  */
-static void __btrfs_add_inode_defrag(struct inode *inode,
+static int __btrfs_add_inode_defrag(struct inode *inode,
 				    struct inode_defrag *defrag)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -119,18 +119,24 @@ static void __btrfs_add_inode_defrag(struct inode *inode,
 				entry->transid = defrag->transid;
 			if (defrag->last_offset > entry->last_offset)
 				entry->last_offset = defrag->last_offset;
-			goto exists;
+			return -EEXIST;
 		}
 	}
 	set_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
 	rb_link_node(&defrag->rb_node, parent, p);
 	rb_insert_color(&defrag->rb_node, &root->fs_info->defrag_inodes);
-	return;
+	return 0;
+}
 
-exists:
-	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-	return;
+static inline int __need_auto_defrag(struct btrfs_root *root)
+{
+	if (!btrfs_test_opt(root, AUTO_DEFRAG))
+		return 0;
+
+	if (btrfs_fs_closing(root->fs_info))
+		return 0;
 
+	return 1;
 }
 
 /*
@@ -143,11 +149,9 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct inode_defrag *defrag;
 	u64 transid;
+	int ret;
 
-	if (!btrfs_test_opt(root, AUTO_DEFRAG))
-		return 0;
-
-	if (btrfs_fs_closing(root->fs_info))
+	if (!__need_auto_defrag(root))
 		return 0;
 
 	if (test_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags))
@@ -167,15 +171,51 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	defrag->root = root->root_key.objectid;
 
 	spin_lock(&root->fs_info->defrag_inodes_lock);
-	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags))
-		__btrfs_add_inode_defrag(inode, defrag);
-	else
+	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags)) {
+		/*
+		 * If we set IN_DEFRAG flag and evict the inode from memory,
+		 * and then re-read this inode, this new inode doesn't have
+		 * IN_DEFRAG flag. At the case, we may find the existed defrag.
+		 */
+		ret = __btrfs_add_inode_defrag(inode, defrag);
+		if (ret)
+			kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	} else {
 		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	}
 	spin_unlock(&root->fs_info->defrag_inodes_lock);
 	return 0;
 }
 
 /*
+ * Requeue the defrag object. If there is a defrag object that points to
+ * the same inode in the tree, we will merge them together (by
+ * __btrfs_add_inode_defrag()) and free the one that we want to requeue.
+ */
+void btrfs_requeue_inode_defrag(struct inode *inode,
+				struct inode_defrag *defrag)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	if (!__need_auto_defrag(root))
+		goto out;
+
+	/*
+	 * Here we don't check the IN_DEFRAG flag, because we need merge
+	 * them together.
+	 */
+	spin_lock(&root->fs_info->defrag_inodes_lock);
+	ret = __btrfs_add_inode_defrag(inode, defrag);
+	spin_unlock(&root->fs_info->defrag_inodes_lock);
+	if (ret)
+		goto out;
+	return;
+out:
+	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+}
+
+/*
  * must be called with the defrag_inodes lock held
  */
 struct inode_defrag *btrfs_find_defrag_inode(struct btrfs_fs_info *info,
@@ -294,7 +334,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 		 */
 		if (num_defrag == defrag_batch) {
 			defrag->last_offset = range.start;
-			__btrfs_add_inode_defrag(inode, defrag);
+			btrfs_requeue_inode_defrag(inode, defrag);
 			/*
 			 * we don't want to kfree defrag, we added it back to
 			 * the rbtree
@@ -308,7 +348,7 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 			 */
 			defrag->last_offset = 0;
 			defrag->cycled = 1;
-			__btrfs_add_inode_defrag(inode, defrag);
+			btrfs_requeue_inode_defrag(inode, defrag);
 			defrag = NULL;
 		}
 
-- 
1.7.11.7

