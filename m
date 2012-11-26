Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18340 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab2KZJYW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 04:24:22 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ9OKlu009629
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 17:24:20 +0800
Message-ID: <50B3355B.5010508@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 17:24:43 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] Btrfs: use slabs for auto defrag allocation
References: <50B32FE7.5080908@cn.fujitsu.com>
In-Reply-To: <50B32FE7.5080908@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The auto defrag allocation is in the fast path of the IO, so use slabs
to improve the speed of the allocation.

And besides that, it can do check for leaked objects when the module is removed.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h |  2 ++
 fs/btrfs/file.c  | 28 ++++++++++++++++++++++++----
 fs/btrfs/super.c |  9 ++++++++-
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2ce1135..fc00ad9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3370,6 +3370,8 @@ void btrfs_get_block_group_info(struct list_head *groups_list,
 				struct btrfs_ioctl_space_info *space);
 
 /* file.c */
+int btrfs_auto_defrag_init(void);
+void btrfs_auto_defrag_exit(void);
 int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 			   struct inode *inode);
 int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 110d3cb..924ce79 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -41,6 +41,7 @@
 #include "compat.h"
 #include "volumes.h"
 
+static struct kmem_cache *btrfs_inode_defrag_cachep;
 /*
  * when auto defrag is enabled we
  * queue up these defrag structs to remember which
@@ -127,7 +128,7 @@ static void __btrfs_add_inode_defrag(struct inode *inode,
 	return;
 
 exists:
-	kfree(defrag);
+	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
 	return;
 
 }
@@ -157,7 +158,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	else
 		transid = BTRFS_I(inode)->root->last_trans;
 
-	defrag = kzalloc(sizeof(*defrag), GFP_NOFS);
+	defrag = kmem_cache_zalloc(btrfs_inode_defrag_cachep, GFP_NOFS);
 	if (!defrag)
 		return -ENOMEM;
 
@@ -169,7 +170,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags))
 		__btrfs_add_inode_defrag(inode, defrag);
 	else
-		kfree(defrag);
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
 	spin_unlock(&root->fs_info->defrag_inodes_lock);
 	return 0;
 }
@@ -315,7 +316,8 @@ int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
 next:
 		spin_lock(&fs_info->defrag_inodes_lock);
 next_free:
-		kfree(defrag);
+		if (defrag)
+			kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
 	}
 	spin_unlock(&fs_info->defrag_inodes_lock);
 
@@ -2293,3 +2295,21 @@ const struct file_operations btrfs_file_operations = {
 	.compat_ioctl	= btrfs_ioctl,
 #endif
 };
+
+void btrfs_auto_defrag_exit(void)
+{
+	if (btrfs_inode_defrag_cachep)
+		kmem_cache_destroy(btrfs_inode_defrag_cachep);
+}
+
+int btrfs_auto_defrag_init(void)
+{
+	btrfs_inode_defrag_cachep = kmem_cache_create("btrfs_inode_defrag",
+					sizeof(struct inode_defrag), 0,
+					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					NULL);
+	if (!btrfs_inode_defrag_cachep)
+		return -ENOMEM;
+
+	return 0;
+}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 915ac14..b3b041a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1647,10 +1647,14 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_ordered_data;
 
-	err = btrfs_interface_init();
+	err = btrfs_auto_defrag_init();
 	if (err)
 		goto free_delayed_inode;
 
+	err = btrfs_interface_init();
+	if (err)
+		goto free_auto_defrag;
+
 	err = register_filesystem(&btrfs_fs_type);
 	if (err)
 		goto unregister_ioctl;
@@ -1662,6 +1666,8 @@ static int __init init_btrfs_fs(void)
 
 unregister_ioctl:
 	btrfs_interface_exit();
+free_auto_defrag:
+	btrfs_auto_defrag_exit();
 free_delayed_inode:
 	btrfs_delayed_inode_exit();
 free_ordered_data:
@@ -1681,6 +1687,7 @@ free_compress:
 static void __exit exit_btrfs_fs(void)
 {
 	btrfs_destroy_cachep();
+	btrfs_auto_defrag_exit();
 	btrfs_delayed_inode_exit();
 	ordered_data_exit();
 	extent_map_exit();
-- 
1.7.11.7

