Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50887 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3C0KHa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 06:07:30 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: sandeen@redhat.com, dsterba@suse.cz
Subject: [PATCH 5/5 v5] btrfs-progs: disable using backup superblock by default
Date: Wed, 27 Mar 2013 18:07:36 +0800
Message-Id: <1364378856-21053-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1364378856-21053-1-git-send-email-anand.jain@oracle.com>
References: <1362132800-29563-1-git-send-email-anand.jain@oracle.com>
 <1364378856-21053-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

except for check_mounted rest of the function thread
should have the access to the backup SB disabled.
this patch will just do that.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 disk-io.c   | 2 +-
 find-root.c | 2 +-
 utils.c     | 2 +-
 volumes.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 82c3b66..589b37a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -881,7 +881,7 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, sb_bytenr,
-				   BTRFS_SCAN_BACKUP_SB);
+				   0ull);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/find-root.c b/find-root.c
index eac3d79..27512df 100644
--- a/find-root.c
+++ b/find-root.c
@@ -153,7 +153,7 @@ static struct btrfs_root *open_ctree_broken(int fd, const char *device)
 	disk_super = fs_info->super_copy;
 	ret = btrfs_read_dev_super(fs_devices->latest_bdev,
 				   disk_super, BTRFS_SUPER_INFO_OFFSET,
-				   BTRFS_SCAN_BACKUP_SB);
+				   0ull);
 	if (ret) {
 		printk("No valid btrfs found\n");
 		goto out_devices;
diff --git a/utils.c b/utils.c
index a2001de..b9b675d 100644
--- a/utils.c
+++ b/utils.c
@@ -923,7 +923,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 	/* scan the initial device */
 	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
 				    &total_devs, BTRFS_SUPER_INFO_OFFSET,
-				    0ull);
+				    BTRFS_SCAN_BACKUP_SB);
 	is_btrfs = (ret >= 0);
 
 	/* scan other devices */
diff --git a/volumes.c b/volumes.c
index a18b219..2de69af 100644
--- a/volumes.c
+++ b/volumes.c
@@ -228,7 +228,7 @@ int btrfs_scan_one_device(int fd, const char *path,
 	}
 	disk_super = (struct btrfs_super_block *)buf;
 	ret = btrfs_read_dev_super(fd, disk_super, super_offset,
-			BTRFS_SCAN_BACKUP_SB);
+			0ull);
 	if (ret < 0) {
 		ret = -EIO;
 		goto error_brelse;
-- 
1.8.1.227.g44fe835

