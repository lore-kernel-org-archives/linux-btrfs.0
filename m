Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934600AbdBQQ2L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 11:28:11 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ED1A8AB9A
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 16:28:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: constify device path passed to relevant helpers
Date: Fri, 17 Feb 2017 17:27:40 +0100
Message-Id: <3f1269a19eddb846a4fbddab4541de0c70778cbf.1487348702.git.dsterba@suse.com>
In-Reply-To: <cover.1487348702.git.dsterba@suse.com>
References: <cover.1487348702.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c |  5 +++--
 fs/btrfs/dev-replace.h |  5 +++--
 fs/btrfs/volumes.c     | 18 ++++++++++--------
 fs/btrfs/volumes.h     | 12 ++++++------
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 5de280b9ad73..e653921f05d9 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -304,8 +304,9 @@ void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info)
 		dev_replace->cursor_left_last_write_of_item;
 }
 
-int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info, char *tgtdev_name,
-				u64 srcdevid, char *srcdev_name, int read_src)
+int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
+		const char *tgtdev_name, u64 srcdevid, const char *srcdev_name,
+		int read_src)
 {
 	struct btrfs_root *root = fs_info->dev_root;
 	struct btrfs_trans_handle *trans;
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 54ea12bda15b..f94a76844ae7 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -27,8 +27,9 @@ int btrfs_run_dev_replace(struct btrfs_trans_handle *trans,
 void btrfs_after_dev_replace_commit(struct btrfs_fs_info *fs_info);
 int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
 			    struct btrfs_ioctl_dev_replace_args *args);
-int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info, char *tgtdev_name,
-				u64 srcdevid, char *srcdev_name, int read_src);
+int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
+		const char *tgtdev_name, u64 srcdevid, const char *srcdev_name,
+		int read_src);
 void btrfs_dev_replace_status(struct btrfs_fs_info *fs_info,
 			      struct btrfs_ioctl_dev_replace_args *args);
 int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1fac98728814..b443cc71830f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1725,7 +1725,7 @@ static int btrfs_add_device(struct btrfs_trans_handle *trans,
  * Function to update ctime/mtime for a given device path.
  * Mainly used for ctime/mtime based probe like libblkid.
  */
-static void update_dev_time(char *path_name)
+static void update_dev_time(const char *path_name)
 {
 	struct file *filp;
 
@@ -1851,7 +1851,8 @@ void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
 		fs_info->fs_devices->latest_bdev = next_device->bdev;
 }
 
-int btrfs_rm_device(struct btrfs_fs_info *fs_info, char *device_path, u64 devid)
+int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
+		u64 devid)
 {
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *cur_devices;
@@ -2091,7 +2092,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 }
 
 static int btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
-				     char *device_path,
+				     const char *device_path,
 				     struct btrfs_device **device)
 {
 	int ret = 0;
@@ -2118,7 +2119,7 @@ static int btrfs_find_device_by_path(struct btrfs_fs_info *fs_info,
 }
 
 int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
-					 char *device_path,
+					 const char *device_path,
 					 struct btrfs_device **device)
 {
 	*device = NULL;
@@ -2151,7 +2152,8 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
  * Lookup a device given by device id, or the path if the id is 0.
  */
 int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
-				 char *devpath, struct btrfs_device **device)
+				 const char *devpath,
+				 struct btrfs_device **device)
 {
 	int ret;
 
@@ -2307,7 +2309,7 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
+int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path)
 {
 	struct btrfs_root *root = fs_info->dev_root;
 	struct request_queue *q;
@@ -2515,7 +2517,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 }
 
 int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
-				  char *device_path,
+				  const char *device_path,
 				  struct btrfs_device *srcdev,
 				  struct btrfs_device **device_out)
 {
@@ -7102,7 +7104,7 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-void btrfs_scratch_superblocks(struct block_device *bdev, char *device_path)
+void btrfs_scratch_superblocks(struct block_device *bdev, const char *device_path)
 {
 	struct buffer_head *bh;
 	struct btrfs_super_block *disk_super;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 24ba6bc3ec34..59be81206dd7 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -422,16 +422,16 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
 void btrfs_assign_next_active_device(struct btrfs_fs_info *fs_info,
 		struct btrfs_device *device, struct btrfs_device *this_dev);
 int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
-					 char *device_path,
+					 const char *device_path,
 					 struct btrfs_device **device);
 int btrfs_find_device_by_devspec(struct btrfs_fs_info *fs_info, u64 devid,
-					 char *devpath,
+					 const char *devpath,
 					 struct btrfs_device **device);
 struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
 					const u64 *devid,
 					const u8 *uuid);
 int btrfs_rm_device(struct btrfs_fs_info *fs_info,
-		    char *device_path, u64 devid);
+		    const char *device_path, u64 devid);
 void btrfs_cleanup_fs_uuids(void);
 int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len);
 int btrfs_grow_device(struct btrfs_trans_handle *trans,
@@ -439,9 +439,9 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
-int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *path);
+int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *path);
 int btrfs_init_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
-				  char *device_path,
+				  const char *device_path,
 				  struct btrfs_device *srcdev,
 				  struct btrfs_device **device_out);
 int btrfs_balance(struct btrfs_balance_control *bctl,
@@ -474,7 +474,7 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 				      struct btrfs_device *tgtdev);
 void btrfs_init_dev_replace_tgtdev_for_resume(struct btrfs_fs_info *fs_info,
 					      struct btrfs_device *tgtdev);
-void btrfs_scratch_superblocks(struct block_device *bdev, char *device_path);
+void btrfs_scratch_superblocks(struct block_device *bdev, const char *device_path);
 int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
 			   u64 logical, u64 len, int mirror_num);
 unsigned long btrfs_full_stripe_len(struct btrfs_fs_info *fs_info,
-- 
2.10.1

