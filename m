Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33790 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcDNBQD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Apr 2016 21:16:03 -0400
Received: by mail-pf0-f193.google.com with SMTP id e190so5515217pfe.0
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Apr 2016 18:16:02 -0700 (PDT)
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org,
        Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Subject: [PATCH] Btrfs: Set superblock s_bdev field properly at device closing
Date: Wed, 13 Apr 2016 18:15:04 -0700
Message-Id: <1460596504-30172-1-git-send-email-yauhen.kharuzhy@zavadatar.com>
In-Reply-To: <1460470563-752-12-git-send-email-anand.jain@oracle.com>
References: <1460470563-752-12-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_info->sb->s_bdev field isn't set to any value at mount time but is set
after device replacing or at device closing. Existing code of
device_force_close() checks if current s_bdev is not equal to closing
bdev and, if equal, replace it by bdev field of first btrfs_device from
device list. This device may be the same as closed, and s_bdev field will
be invalid.

If s_bdev is not NULL but references an freed block device, kernel
oopses at filesystem sync time on unmount.

For multi-device FS setting of this field may be senseless, but using of
it should be consistent over the all btrfs code. So, set it on mount
time and select valid device at device closing time.

Alternative solution may be to not set s_bdev entirely.

Signed-off-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
---
 fs/btrfs/super.c   |  1 +
 fs/btrfs/volumes.c | 16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3dd154e..1a2c58f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1522,6 +1522,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 		char b[BDEVNAME_SIZE];
 
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
+		s->s_bdev = bdev;
 		btrfs_sb(s)->bdev_holder = fs_type;
 		error = btrfs_fill_super(s, fs_devices, data,
 					 flags & MS_SILENT ? 1 : 0);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 08ab116..f14f3f2 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7132,6 +7132,7 @@ void device_force_close(struct btrfs_device *device)
 {
 	struct btrfs_device *next_device;
 	struct btrfs_fs_devices *fs_devices;
+	int found = 0;
 
 	fs_devices = device->fs_devices;
 
@@ -7139,13 +7140,20 @@ void device_force_close(struct btrfs_device *device)
 	mutex_lock(&fs_devices->fs_info->chunk_mutex);
 	spin_lock(&fs_devices->fs_info->free_chunk_lock);
 
-	next_device = list_entry(fs_devices->devices.next,
-					struct btrfs_device, dev_list);
+	list_for_each_entry(next_device, &fs_devices->devices, dev_list) {
+		if (next_device->bdev && next_device->bdev != device->bdev) {
+			found = 1;
+			break;
+		}
+	}
+
 	if (device->bdev == fs_devices->fs_info->sb->s_bdev)
-		fs_devices->fs_info->sb->s_bdev = next_device->bdev;
+		fs_devices->fs_info->sb->s_bdev =
+			found ? next_device->bdev : NULL;
 
 	if (device->bdev == fs_devices->latest_bdev)
-		fs_devices->latest_bdev = next_device->bdev;
+		fs_devices->latest_bdev =
+			found ? next_device->bdev : NULL;
 
 	if (device->bdev)
 		fs_devices->open_devices--;
-- 
2.5.0

