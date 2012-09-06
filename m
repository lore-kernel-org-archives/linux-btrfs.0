Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24575 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758128Ab2IFKov (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Sep 2012 06:44:51 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q86A247h017547
	for <linux-btrfs@vger.kernel.org>; Thu, 6 Sep 2012 18:02:07 +0800
Message-ID: <5048748F.2070601@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 18:01:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH V4 04/12] Btrfs: use a slab for ordered extents allocation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <50487434.1010305@cn.fujitsu.com>

The ordered extent allocation is in the fast path of the IO, so use a slab
to improve the speed of the allocation.

 "Size of the struct is 280, so this will fall into the size-512 bucket,
  giving 8 objects per page, while own slab will pack 14 objects into a page.

  Another benefit I see is to check for leaked objects when the module is
  removed (and the cache destroy takes place)."
						-- David Sterba

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- just change the changelog of this patch.
---
 fs/btrfs/ordered-data.c |   23 +++++++++++++++++++++--
 fs/btrfs/ordered-data.h |    2 ++
 fs/btrfs/super.c        |    9 ++++++++-
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 2eb79cc..4ae1014 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -25,6 +25,8 @@
 #include "btrfs_inode.h"
 #include "extent_io.h"
 
+static struct kmem_cache *btrfs_ordered_extent_cache;
+
 static u64 entry_end(struct btrfs_ordered_extent *entry)
 {
 	if (entry->file_offset + entry->len < entry->file_offset)
@@ -187,7 +189,7 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	struct btrfs_ordered_extent *entry;
 
 	tree = &BTRFS_I(inode)->ordered_tree;
-	entry = kzalloc(sizeof(*entry), GFP_NOFS);
+	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
 	if (!entry)
 		return -ENOMEM;
 
@@ -421,7 +423,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 			list_del(&sum->list);
 			kfree(sum);
 		}
-		kfree(entry);
+		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
 
@@ -958,3 +960,20 @@ void btrfs_add_ordered_operation(struct btrfs_trans_handle *trans,
 	}
 	spin_unlock(&root->fs_info->ordered_extent_lock);
 }
+
+int __init ordered_data_init(void)
+{
+	btrfs_ordered_extent_cache = kmem_cache_create("btrfs_ordered_extent",
+				     sizeof(struct btrfs_ordered_extent), 0,
+				     SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+				     NULL);
+	if (!btrfs_ordered_extent_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void ordered_data_exit(void)
+{
+	if (btrfs_ordered_extent_cache)
+		kmem_cache_destroy(btrfs_ordered_extent_cache);
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
index 073c236..48e53d6 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1595,10 +1595,14 @@ static int __init init_btrfs_fs(void)
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
@@ -1616,6 +1620,8 @@ unregister_ioctl:
 	btrfs_interface_exit();
 free_delayed_inode:
 	btrfs_delayed_inode_exit();
+free_ordered_data:
+	ordered_data_exit();
 free_extent_map:
 	extent_map_exit();
 free_extent_io:
@@ -1632,6 +1638,7 @@ static void __exit exit_btrfs_fs(void)
 {
 	btrfs_destroy_cachep();
 	btrfs_delayed_inode_exit();
+	ordered_data_exit();
 	extent_map_exit();
 	extent_io_exit();
 	btrfs_interface_exit();
-- 
1.7.6.5
