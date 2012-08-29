Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62416 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab2H2ENN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Aug 2012 00:13:13 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q7T4DCru031836
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2012 12:13:12 +0800
Message-ID: <503D96C2.7000802@cn.fujitsu.com>
Date: Wed, 29 Aug 2012 12:12:50 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/7] Btrfs: use a slab for ordered extents allocation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The ordered extent allocation is in the fast path of the IO, so use a slab
to improve the speed of the allocation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c |   23 +++++++++++++++++++++--
 fs/btrfs/ordered-data.h |    2 ++
 fs/btrfs/super.c        |    9 ++++++++-
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 2eb79cc..a07ae77 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -25,6 +25,8 @@
 #include "btrfs_inode.h"
 #include "extent_io.h"
 
+static struct kmem_cache *ordered_extent_cache;
+
 static u64 entry_end(struct btrfs_ordered_extent *entry)
 {
 	if (entry->file_offset + entry->len < entry->file_offset)
@@ -187,7 +189,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	struct btrfs_ordered_extent *entry;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	entry = kzalloc(sizeof(*entry), GFP_NOFS);
+	entry = kmem_cache_zalloc(ordered_extent_cache, GFP_NOFS);
 	if (!entry)
 		return -ENOMEM;
 
@@ -421,7 +423,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			list_del(&sum->list);
 			kfree(sum);
 		}
-		kfree(entry);
+		kmem_cache_free(ordered_extent_cache, entry);
 	}
 }
 
@@ -958,3 +960,20 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	}
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 }
+
+int __init ordered_data_init(void)
+{
+	ordered_extent_cache = kmem_cache_create("ordered_extent",
+				sizeof(struct btrfs_ordered_extent), 0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+				NULL);
+	if (!ordered_extent_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void ordered_data_exit(void)
+{
+	if (ordered_extent_cache)
+		kmem_cache_destroy(ordered_extent_cache);
+}
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index c2443a4..d1ddaef 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -192,4 +192,6 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 				 struct inode *inode);
 void btrfs_wait_ordered_extents(struct btrfs_root *root,
 				int nocow_only, int delay_iput);
+int __init ordered_data_init(void);
+void ordered_data_exit(void);
 #endif
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 2e06f12..70312e5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1590,10 +1590,14 @@ static int __init init_btrfs_fs(void)
 	if (err)
 		goto free_extent_io;
 
-	err = btrfs_delayed_inode_init();
+	err = ordered_data_init();
 	if (err)
 		goto free_extent_map;
 
+	err = btrfs_delayed_inode_init();
+	if (err)
+		goto free_ordered_data;
+
 	err = btrfs_interface_init();
 	if (err)
 		goto free_delayed_inode;
@@ -1611,6 +1615,8 @@ unregister_ioctl:
 	btrfs_interface_exit();
 free_delayed_inode:
 	btrfs_delayed_inode_exit();
+free_ordered_data:
+	ordered_data_exit();
 free_extent_map:
 	extent_map_exit();
 free_extent_io:
@@ -1627,6 +1633,7 @@ static void __exit exit_btrfs_fs(void)
 {
 	btrfs_destroy_cachep();
 	btrfs_delayed_inode_exit();
+	ordered_data_exit();
 	extent_map_exit();
 	extent_io_exit();
 	btrfs_interface_exit();
-- 
1.7.6.5
