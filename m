Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752116AbdFOMwq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 08:52:46 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6974EAD55
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 12:52:45 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, jeffm@suse.com, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: Round up values which are written for total_bytes_size
Date: Thu, 15 Jun 2017 15:52:35 +0300
Message-Id: <1497531155-9703-3-git-send-email-nborisov@suse.com>
In-Reply-To: <1497531155-9703-1-git-send-email-nborisov@suse.com>
References: <1497531155-9703-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e37f95976443..adf32f46a73f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2387,7 +2387,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	device->io_width = fs_info->sectorsize;
 	device->io_align = fs_info->sectorsize;
 	device->sector_size = fs_info->sectorsize;
-	device->total_bytes = i_size_read(bdev->bd_inode);
+	device->total_bytes = round_down(i_size_read(bdev->bd_inode),
+					 fs_info->sectorsize);
 	device->disk_total_bytes = device->total_bytes;
 	device->commit_total_bytes = device->total_bytes;
 	device->fs_info = fs_info;
@@ -2424,7 +2425,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 	tmp = btrfs_super_total_bytes(fs_info->super_copy);
 	btrfs_set_super_total_bytes(fs_info->super_copy,
-				    tmp + device->total_bytes);
+		round_down(tmp + device->total_bytes, fs_info->sectorsize));
 
 	tmp = btrfs_super_num_devices(fs_info->super_copy);
 	btrfs_set_super_num_devices(fs_info->super_copy, tmp + 1);
@@ -2687,6 +2688,8 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 	if (!device->writeable)
 		return -EACCES;
 
+	new_size = round_down(new_size, fs_info->sectorsize);
+
 	mutex_lock(&fs_info->chunk_mutex);
 	old_total = btrfs_super_total_bytes(super_copy);
 	diff = new_size - device->total_bytes;
@@ -2699,7 +2702,8 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 
 	fs_devices = fs_info->fs_devices;
 
-	btrfs_set_super_total_bytes(super_copy, old_total + diff);
+	btrfs_set_super_total_bytes(super_copy,
+			round_down(old_total + diff, fs_info->sectorsize));
 	device->fs_devices->total_rw_bytes += diff;
 
 	btrfs_device_set_total_bytes(device, new_size);
@@ -4389,7 +4393,10 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	struct btrfs_super_block *super_copy = fs_info->super_copy;
 	u64 old_total = btrfs_super_total_bytes(super_copy);
 	u64 old_size = btrfs_device_get_total_bytes(device);
-	u64 diff = old_size - new_size;
+	u64 diff;
+
+	new_size = round_down(new_size, fs_info->sectorsize);
+	diff = old_size - new_size;
 
 	if (device->is_tgtdev_for_dev_replace)
 		return -EINVAL;
@@ -4516,7 +4523,8 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 			      &fs_info->fs_devices->resized_devices);
 
 	WARN_ON(diff > old_total);
-	btrfs_set_super_total_bytes(super_copy, old_total - diff);
+	btrfs_set_super_total_bytes(super_copy,
+			round_down(old_total - diff, fs_info->sectorsize));
 	mutex_unlock(&fs_info->chunk_mutex);
 
 	/* Now btrfs_update_device() will change the on-disk size. */
-- 
2.7.4

