Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:40947 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3CRO7r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 10:59:47 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7DE1B7C04FA
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 08:59:46 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id ars6jX75yYAPwQfO (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 08:59:45 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix memory leaks on cleanup
Date: Mon, 18 Mar 2013 11:07:03 -0400
Message-ID: <1363619223-4242-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've been working on btrfs-image and I kept seeing these leaks pop up on
valgrind so I'm just fixing them.  We don't properly cleanup the device cache,
the chunk tree mapping cache, or the space infos on close.  With this patch
valgrind doesn't complain about any memory leaks running btrfs-image.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 disk-io.c     |   26 +++++++++++++++++++++-----
 extent-tree.c |    9 +++++++++
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index da7086f..72b33da 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1269,23 +1269,38 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 static int close_all_devices(struct btrfs_fs_info *fs_info)
 {
 	struct list_head *list;
-	struct list_head *next;
 	struct btrfs_device *device;
 
-	return 0;
-
 	list = &fs_info->fs_devices->devices;
-	list_for_each(next, list) {
-		device = list_entry(next, struct btrfs_device, dev_list);
+	while (!list_empty(list)) {
+		device = list_entry(list->next, struct btrfs_device, dev_list);
+		list_del_init(&device->dev_list);
 		if (device->fd) {
 			fsync(device->fd);
 			posix_fadvise(device->fd, 0, 0, POSIX_FADV_DONTNEED);
 		}
 		close(device->fd);
+		kfree(device->name);
+		kfree(device->label);
+		kfree(device);
 	}
+	kfree(fs_info->fs_devices);
 	return 0;
 }
 
+static void free_mapping_cache(struct btrfs_fs_info *fs_info)
+{
+	struct cache_tree *cache_tree = &fs_info->mapping_tree.cache_tree;
+	struct cache_extent *ce;
+	struct map_lookup *map;
+
+	while ((ce = find_first_cache_extent(cache_tree, 0))) {
+		map = container_of(ce, struct map_lookup, ce);
+		remove_cache_extent(cache_tree, ce);
+		kfree(map);
+	}
+}
+
 int close_ctree(struct btrfs_root *root)
 {
 	int ret;
@@ -1326,6 +1341,7 @@ int close_ctree(struct btrfs_root *root)
 	}
 
 	close_all_devices(fs_info);
+	free_mapping_cache(fs_info);
 	extent_io_tree_cleanup(&fs_info->extent_cache);
 	extent_io_tree_cleanup(&fs_info->free_space_cache);
 	extent_io_tree_cleanup(&fs_info->block_group_cache);
diff --git a/extent-tree.c b/extent-tree.c
index eede633..ba47688 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3172,10 +3172,12 @@ out:
 
 int btrfs_free_block_groups(struct btrfs_fs_info *info)
 {
+	struct btrfs_space_info *sinfo;
 	u64 start;
 	u64 end;
 	u64 ptr;
 	int ret;
+
 	while(1) {
 		ret = find_first_extent_bit(&info->block_group_cache, 0,
 					    &start, &end, (unsigned int)-1);
@@ -3195,6 +3197,13 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		clear_extent_dirty(&info->free_space_cache, start,
 				   end, GFP_NOFS);
 	}
+
+	while (!list_empty(&info->space_info)) {
+		sinfo = list_entry(info->space_info.next,
+				   struct btrfs_space_info, list);
+		list_del_init(&sinfo->list);
+		kfree(sinfo);
+	}
 	return 0;
 }
 
-- 
1.7.7.6

