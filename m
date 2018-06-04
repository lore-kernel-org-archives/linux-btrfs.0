Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39766 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753601AbeFDO5z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2018 10:57:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w54Eu0f3008515
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2018 14:57:55 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2jbvypbx7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2018 14:57:55 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w54Evs0C018390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2018 14:57:54 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w54EvrgX014794
        for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2018 14:57:54 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: fix race between mkfs and mount
Date: Mon,  4 Jun 2018 23:00:30 +0800
Message-Id: <20180604150030.12883-3-anand.jain@oracle.com>
In-Reply-To: <20180604150030.12883-1-anand.jain@oracle.com>
References: <20180604150030.12883-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In an instrumented testing it is possible that the mount and
a newer mkfs.btrfs thread on the same device can race and if the new
mkfs.btrfs wins it will free the older fs_devices, then the mount thread
will lead to oops.

Thread1						Thread2
-------						-------
mkfs.btrfs -fq /dev/sdb
mount /dev/sdb /btrfs
|_btrfs_mount_root()
  |_btrfs_scan_one_device(... &fs_devices)

						mkfs.btrfs -fq /dev/sdb
						|_btrfs_contol_ioctl()
						  |_btrfs_scan_one_device(... &fs_devices)
						    |_::
						      |_btrfs_free_stale_devices()

  |_btrfs_open_devices(fs_devices ..) <-- stale fs_devices.

Fix this with a mutually exclusive flag BTRFS_VOL_FLAG_EXCL_OPS.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c   |  6 ++++++
 fs/btrfs/volumes.c | 10 +++++++++-
 fs/btrfs/volumes.h |  1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f0c13defc9eb..b60e7cbe39f5 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1565,7 +1565,13 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
 		goto error_fs_info;
 	}
 
+	if (test_and_set_bit(BTRFS_VOLUME_STATE_EXCL_OPS, &fs_devices->volume_state)) {
+		error = -EBUSY;
+		goto error_fs_info;
+	}
+
 	error = btrfs_open_devices(fs_devices, mode, fs_type);
+	clear_bit(BTRFS_VOLUME_STATE_EXCL_OPS, &fs_devices->volume_state);
 	if (error)
 		goto error_fs_info;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 87a4b12f98e3..3137cc990550 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -635,7 +635,7 @@ static void pending_bios_fn(struct btrfs_work *work)
  *		devices.
  */
 static void free_stale_devices(const char *path,
-				     struct btrfs_device *skip_device)
+			       struct btrfs_device *skip_device)
 {
 	struct btrfs_fs_devices *fs_devices, *tmp_fs_devices;
 	struct btrfs_device *device, *tmp_device;
@@ -643,9 +643,15 @@ static void free_stale_devices(const char *path,
 	list_for_each_entry_safe(fs_devices, tmp_fs_devices, &fs_uuids,
 				 fs_list) {
 
+		if (test_and_set_bit(BTRFS_VOLUME_STATE_EXCL_OPS,
+				     &fs_devices->volume_state))
+			continue;
+
 		mutex_lock(&fs_devices->device_list_mutex);
 		if (fs_devices->opened) {
 			mutex_unlock(&fs_devices->device_list_mutex);
+			clear_bit(BTRFS_VOLUME_STATE_EXCL_OPS,
+				  &fs_devices->volume_state);
 			continue;
 		}
 
@@ -680,6 +686,8 @@ static void free_stale_devices(const char *path,
 			list_del(&fs_devices->fs_list);
 			free_fs_devices(fs_devices);
 		}
+		clear_bit(BTRFS_VOLUME_STATE_EXCL_OPS,
+			  &fs_devices->volume_state);
 	}
 }
 
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index cd18916f2bbc..60eea973a501 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -214,6 +214,7 @@ BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
  */
 #define BTRFS_VOLUME_STATE_ROTATING	(0)
 #define BTRFS_VOLUME_STATE_SEEDING	(1)
+#define BTRFS_VOLUME_STATE_EXCL_OPS	(2)
 
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
-- 
2.15.0

