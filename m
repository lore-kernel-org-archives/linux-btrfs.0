From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix locking issue in btrfs_remove_block_group
Date: Wed, 21 Jan 2009 19:53:15 +0800
Message-ID: <49770CAB.6020302@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

We should hold the block_group_cache_lock while modifying the
block groups red-black tree. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/extent-tree.c 2/fs/btrfs/extent-tree.c
--- 1/fs/btrfs/extent-tree.c	2009-01-07 07:16:42.762364700 +0800
+++ 2/fs/btrfs/extent-tree.c	2009-01-21 10:41:38.000000000 +0800
@@ -5957,9 +5957,11 @@ int btrfs_remove_block_group(struct btrf
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
-	btrfs_remove_free_space_cache(block_group);
+	spin_lock(&root->fs_info->block_group_cache_lock);
 	rb_erase(&block_group->cache_node,
 		 &root->fs_info->block_group_cache_tree);
+	spin_unlock(&root->fs_info->block_group_cache_lock);
+	btrfs_remove_free_space_cache(block_group);
 	down_write(&block_group->space_info->groups_sem);
 	list_del(&block_group->list);
 	up_write(&block_group->space_info->groups_sem);



