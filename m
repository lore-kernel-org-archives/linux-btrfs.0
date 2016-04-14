Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35780 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbcDNKYl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Apr 2016 06:24:41 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com
Subject: [PATCH] btrfs: s_bdev is not null after missing replace
Date: Thu, 14 Apr 2016 18:24:10 +0800
Message-Id: <1460629450-2271-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yauhen reported in the ML that s_bdev is null at mount, and
s_bdev gets updated to some device when missing device is
replaced, as because bdev is null for missing device, things
gets matched up. Fix this by checking if s_bdev is set. I
didn't want to completely remove updating s_bdev because
the future multi device support at vfs layer may need it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reported-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
 fs/btrfs/dev-replace.c | 3 ++-
 fs/btrfs/volumes.c     | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index ddc4843604df..f8ff67609c18 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -569,7 +569,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	ASSERT(list_empty(&src_device->resized_list));
 	tgt_device->commit_total_bytes = src_device->commit_total_bytes;
 	tgt_device->commit_bytes_used = src_device->bytes_used;
-	if (fs_info->sb->s_bdev == src_device->bdev)
+	if (fs_info->sb->s_bdev &&
+		(fs_info->sb->s_bdev == src_device->bdev))
 		fs_info->sb->s_bdev = tgt_device->bdev;
 	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
 		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c2a87fc127a7..06de1e9b7891 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1898,7 +1898,8 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 	next_device = list_entry(root->fs_info->fs_devices->devices.next,
 				 struct btrfs_device, dev_list);
-	if (device->bdev == root->fs_info->sb->s_bdev)
+	if (root->fs_info->sb->s_bdev &&
+		(root->fs_info->sb->s_bdev == device->bdev))
 		root->fs_info->sb->s_bdev = next_device->bdev;
 	if (device->bdev == root->fs_info->fs_devices->latest_bdev)
 		root->fs_info->fs_devices->latest_bdev = next_device->bdev;
@@ -2084,7 +2085,8 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
 
 	next_device = list_entry(fs_info->fs_devices->devices.next,
 				 struct btrfs_device, dev_list);
-	if (tgtdev->bdev == fs_info->sb->s_bdev)
+	if (fs_info->sb->s_bdev &&
+		(tgtdev->bdev == fs_info->sb->s_bdev))
 		fs_info->sb->s_bdev = next_device->bdev;
 	if (tgtdev->bdev == fs_info->fs_devices->latest_bdev)
 		fs_info->fs_devices->latest_bdev = next_device->bdev;
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel
