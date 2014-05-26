Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47920 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaEZJ1d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 05:27:33 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jeffm@suse.com, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 4/4] btrfs: create sprout should rename fsid on the sysfs as well
Date: Mon, 26 May 2014 17:30:26 +0800
Message-Id: <1401096626-13210-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
References: <1401096626-13210-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
 fs/btrfs/volumes.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5a577ab..e6cf3a7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2084,6 +2084,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	if (seeding_dev) {
+		char fsid_buf[37];
 		ret = init_first_rw_device(trans, root, device);
 		if (ret) {
 			btrfs_abort_transaction(trans, root, ret);
@@ -2094,6 +2095,13 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 			btrfs_abort_transaction(trans, root, ret);
 			goto error_trans;
 		}
+
+		/* Sprouting would change fsid of the mounted root,
+		 * so rename the fsid on the sysfs
+		 */
+		sprintf(fsid_buf, "%pU", root->fs_info->fsid);
+		if (kobject_rename(&root->fs_info->super_kobj, fsid_buf))
+			goto error_trans;
 	} else {
 		ret = btrfs_add_device(trans, root, device);
 		if (ret) {
-- 
1.7.1

