Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24378 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaFCDgk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 23:36:40 -0400
From: Anand Jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 5/6 v2] btrfs: create sprout should rename fsid on the sysfs as well
Date: Tue,  3 Jun 2014 11:36:03 +0800
Message-Id: <1401766564-7381-6-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1401766564-7381-1-git-send-email-Anand.Jain@oracle.com>

Creating sprout will change the fsid of the mounted root.
do the same on the sysfs as well.

reproducer:
 mount /dev/sdb /btrfs (seed disk)
 btrfs dev add /dev/sdc /btrfs
 mount -o rw,remount /btrfs
 btrfs dev del /dev/sdb /btrfs
 mount /dev/sdb /btrfs

Error:
kobject_add_internal failed for fe350492-dc28-4051-a601-e017b17e6145 with -EEXIST, don't try to register things with the same name in the same directory.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 v2: function name change and defined BTRFS_UUID_UNPARSED_SIZE
     in btrfs.h include file

 fs/btrfs/volumes.c         | 9 +++++++++
 include/uapi/linux/btrfs.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4a66e6b..d169bd8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2108,6 +2108,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	if (seeding_dev) {
+		char fsid_buf[BTRFS_UUID_UNPARSED_SIZE];
 		ret = init_first_rw_device(trans, root, device);
 		if (ret) {
 			btrfs_abort_transaction(trans, root, ret);
@@ -2118,6 +2119,14 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 			btrfs_abort_transaction(trans, root, ret);
 			goto error_trans;
 		}
+
+		/* Sprouting would change fsid of the mounted root,
+		 * so rename the fsid on the sysfs
+		 */
+		snprintf(fsid_buf, BTRFS_UUID_UNPARSED_SIZE, "%pU",
+						root->fs_info->fsid);
+		if (kobject_rename(&root->fs_info->super_kobj, fsid_buf))
+			goto error_trans;
 	} else {
 		ret = btrfs_add_device(trans, root, device);
 		if (ret) {
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 839d574c..8ff61c2 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -38,6 +38,7 @@ struct btrfs_ioctl_vol_args {
 #define BTRFS_SUBVOL_QGROUP_INHERIT	(1ULL << 2)
 #define BTRFS_FSID_SIZE 16
 #define BTRFS_UUID_SIZE 16
+#define BTRFS_UUID_UNPARSED_SIZE	37
 
 #define BTRFS_QGROUP_INHERIT_SET_LIMITS	(1ULL << 0)
 
-- 
1.8.5.3

