Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17180 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752674AbdFMJT7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:59 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 17/19] btrfs-progs: Refactor btrfs_add_device() to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:33 +0800
Message-ID: <20170613091935.23277-18-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTW, there is a duplicated definition of btrfs_add_device() in
volumes.h, also remove it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c   | 11 ++++++-----
 volumes.c |  7 +++----
 volumes.h |  5 +----
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/utils.c b/utils.c
index 823b7f3d..243ee1e5 100644
--- a/utils.c
+++ b/utils.c
@@ -179,7 +179,8 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      u32 sectorsize)
 {
 	struct btrfs_super_block *disk_super;
-	struct btrfs_super_block *super = root->fs_info->super_copy;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_super_block *super = fs_info->super_copy;
 	struct btrfs_device *device;
 	struct btrfs_dev_item *dev_item;
 	char *buf = NULL;
@@ -214,7 +215,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	device->total_bytes = device_total_bytes;
 	device->bytes_used = 0;
 	device->total_ios = 0;
-	device->dev_root = root->fs_info->dev_root;
+	device->dev_root = fs_info->dev_root;
 	device->name = strdup(path);
 	if (!device->name) {
 		ret = -ENOMEM;
@@ -222,7 +223,7 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	}
 
 	INIT_LIST_HEAD(&device->dev_list);
-	ret = btrfs_add_device(trans, root, device);
+	ret = btrfs_add_device(trans, fs_info, device);
 	if (ret)
 		goto out;
 
@@ -248,8 +249,8 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 	BUG_ON(ret != sectorsize);
 
 	free(buf);
-	list_add(&device->dev_list, &root->fs_info->fs_devices->devices);
-	device->fs_devices = root->fs_info->fs_devices;
+	list_add(&device->dev_list, &fs_info->fs_devices->devices);
+	device->fs_devices = fs_info->fs_devices;
 	return 0;
 
 out:
diff --git a/volumes.c b/volumes.c
index bdaca19d..2c1bb62e 100644
--- a/volumes.c
+++ b/volumes.c
@@ -585,7 +585,7 @@ error:
  * the btrfs_device struct should be fully filled in
  */
 int btrfs_add_device(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root,
+		     struct btrfs_fs_info *fs_info,
 		     struct btrfs_device *device)
 {
 	int ret;
@@ -593,11 +593,10 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 	struct btrfs_dev_item *dev_item;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
+	struct btrfs_root *root = fs_info->chunk_root;
 	unsigned long ptr;
 	u64 free_devid = 0;
 
-	root = root->fs_info->chunk_root;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -635,7 +634,7 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 	ptr = (unsigned long)btrfs_device_fsid(dev_item);
-	write_extent_buffer(leaf, root->fs_info->fsid, ptr, BTRFS_UUID_SIZE);
+	write_extent_buffer(leaf, fs_info->fsid, ptr, BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 	ret = 0;
 
diff --git a/volumes.h b/volumes.h
index 44130adb..0f82281f 100644
--- a/volumes.h
+++ b/volumes.h
@@ -213,15 +213,12 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *extent_root, u64 *start,
 			   u64 num_bytes, u64 type, int convert);
 int btrfs_read_super_device(struct btrfs_root *root, struct extent_buffer *buf);
-int btrfs_add_device(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root,
-		     struct btrfs_device *device);
 int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       int flags);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_close_all_devices(void);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
-		     struct btrfs_root *root,
+		     struct btrfs_fs_info *fs_info,
 		     struct btrfs_device *device);
 int btrfs_update_device(struct btrfs_trans_handle *trans,
 			struct btrfs_device *device);
-- 
2.13.1



