Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14005 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754972AbaDPJB2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 05:01:28 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Karel Zak <kzak@redhat.com>
Subject: [PATCH RFC] btrfs: Add ctime/mtime update for btrfs device add/remove.
Date: Wed, 16 Apr 2014 17:02:32 +0800
Message-ID: <1397638952-16691-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs will send uevent to udev inform the device change,
but ctime/mtime for the block device inode is not udpated, which cause
libblkid used by btrfs-progs unable to detect device change and use old
cache, causing 'btrfs dev scan; btrfs dev rmove; btrfs dev scan' give an
error message.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: Karel Zak <kzak@redhat.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 49d7fab..ce232d7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1452,6 +1452,22 @@ out:
 	return ret;
 }
 
+/*
+ * Function to update ctime/mtime for a given device path.
+ * Mainly used for ctime/mtime based probe like libblkid.
+ */
+static void update_dev_time(char *path_name)
+{
+	struct file *filp;
+
+	filp = filp_open(path_name, O_RDWR, 0);
+	if (!filp)
+		return;
+	file_update_time(filp);
+	filp_close(filp, NULL);
+	return;
+}
+
 static int btrfs_rm_dev_item(struct btrfs_root *root,
 			     struct btrfs_device *device)
 {
@@ -1704,10 +1720,14 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 	ret = 0;
 
-	/* Notify udev that device has changed */
-	if (bdev)
+	if (bdev) {
+		/* Notify udev that device has changed */
 		btrfs_kobject_uevent(bdev, KOBJ_CHANGE);
 
+		/* Update ctime/mtime for device path for libblkid */
+		update_dev_time(device_path);
+	}
+
 error_brelse:
 	brelse(bh);
 	if (bdev)
@@ -2146,6 +2166,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		ret = btrfs_commit_transaction(trans, root);
 	}
 
+	/* Update ctime/mtime for libblkid */
+	update_dev_time(device_path);
 	return ret;
 
 error_trans:
-- 
1.9.2

