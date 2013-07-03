Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab3GCOAe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Jul 2013 10:00:34 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r63DODNt003961
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jul 2013 21:24:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 03/12] Btrfs-progs: Don't free the devices when close the ctree
Date: Wed, 3 Jul 2013 21:25:11 +0800
Message-Id: <1372857920-4678-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
References: <1372857920-4678-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some commands(such as btrfs-convert) access the devices again after we close
the ctree, so it is better that we don't free the devices objects when the ctree
is closed, or we need re-allocate the memory for the devices. We needn't worry
the memory leak problem, because all the memory will be freed after the taskes
die.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 btrfs-find-root.c | 21 +--------------------
 disk-io.c         | 30 ++----------------------------
 volumes.c         |  3 +++
 3 files changed, 6 insertions(+), 48 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 3e1396d..da22c1d 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -65,25 +65,6 @@ int csum_block(void *buf, u32 len)
 	return ret;
 }
 
-static int close_all_devices(struct btrfs_fs_info *fs_info)
-{
-	struct list_head *list;
-	struct list_head *next;
-	struct btrfs_device *device;
-
-	return 0;
-
-	list = &fs_info->fs_devices->devices;
-	list_for_each(next, list) {
-		device = list_entry(next, struct btrfs_device, dev_list);
-		if (device->fd != -1) {
-			close(device->fd);
-			device->fd = -1;
-		}
-	}
-	return 0;
-}
-
 static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 {
 	u32 sectorsize;
@@ -217,7 +198,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 out_chunk:
 	free_extent_buffer(fs_info->chunk_root->node);
 out_devices:
-	close_all_devices(fs_info);
+	btrfs_close_devices(fs_info->fs_devices);
 out_cleanup:
 	extent_io_tree_cleanup(&fs_info->extent_cache);
 	extent_io_tree_cleanup(&fs_info->free_space_cache);
diff --git a/disk-io.c b/disk-io.c
index 4003636..a8176a5 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -35,8 +35,6 @@
 #include "utils.h"
 #include "print-tree.h"
 
-static int close_all_devices(struct btrfs_fs_info *fs_info);
-
 static int check_tree_block(struct btrfs_root *root, struct extent_buffer *buf)
 {
 
@@ -1028,7 +1026,7 @@ out_chunk:
 	if (fs_info->chunk_root)
 		free_extent_buffer(fs_info->chunk_root->node);
 out_devices:
-	close_all_devices(fs_info);
+	btrfs_close_devices(fs_info->fs_devices);
 out_cleanup:
 	extent_io_tree_cleanup(&fs_info->extent_cache);
 	extent_io_tree_cleanup(&fs_info->free_space_cache);
@@ -1261,30 +1259,6 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int close_all_devices(struct btrfs_fs_info *fs_info)
-{
-	struct list_head *list;
-	struct btrfs_device *device;
-
-	list = &fs_info->fs_devices->devices;
-	while (!list_empty(list)) {
-		device = list_entry(list->next, struct btrfs_device, dev_list);
-		list_del_init(&device->dev_list);
-		if (device->fd != -1) {
-			fsync(device->fd);
-			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
-				fprintf(stderr, "Warning, could not drop caches\n");
-			close(device->fd);
-			device->fd = -1;
-		}
-		kfree(device->name);
-		kfree(device->label);
-		kfree(device);
-	}
-	kfree(fs_info->fs_devices);
-	return 0;
-}
-
 static void free_mapping_cache(struct btrfs_fs_info *fs_info)
 {
 	struct cache_tree *cache_tree = &fs_info->mapping_tree.cache_tree;
@@ -1337,7 +1311,7 @@ int close_ctree(struct btrfs_root *root)
 		free(fs_info->log_root_tree);
 	}
 
-	close_all_devices(fs_info);
+	btrfs_close_devices(fs_info->fs_devices);
 	free_mapping_cache(fs_info);
 	extent_io_tree_cleanup(&fs_info->extent_cache);
 	extent_io_tree_cleanup(&fs_info->free_space_cache);
diff --git a/volumes.c b/volumes.c
index b88385b..0f6a35b 100644
--- a/volumes.c
+++ b/volumes.c
@@ -163,6 +163,9 @@ again:
 	list_for_each(cur, &fs_devices->devices) {
 		device = list_entry(cur, struct btrfs_device, dev_list);
 		if (device->fd != -1) {
+			fsync(device->fd);
+			if (posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED))
+				fprintf(stderr, "Warning, could not drop caches\n");
 			close(device->fd);
 			device->fd = -1;
 		}
-- 
1.8.1.4

