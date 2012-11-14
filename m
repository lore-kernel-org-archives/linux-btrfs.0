Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42093 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422661Ab2KNOg4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 09:36:56 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qAEEasV8001047
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 14:36:55 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qAEEasF8029715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 14:36:54 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qAEEaslp025867
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 08:36:54 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: protect devices list with its mutex
Date: Wed, 14 Nov 2012 22:35:30 +0800
Message-Id: <1352903730-7090-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we've kill the bigger one volume_mutex, we need to add devices
list mutex back.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0f5ebb7..a6a7596 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1678,16 +1678,17 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	filemap_write_and_wait(bdev->bd_inode->i_mapping);
 
 	devices = &root->fs_info->fs_devices->devices;
-	/*
-	 * we have the volume lock, so we don't need the extra
-	 * device list mutex while reading the list here.
-	 */
+
+	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	list_for_each_entry(device, devices, dev_list) {
 		if (device->bdev == bdev) {
 			ret = -EEXIST;
+			mutex_unlock(
+				&root->fs_info->fs_devices->device_list_mutex);
 			goto error;
 		}
 	}
+	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
 	device = kzalloc(sizeof(*device), GFP_NOFS);
 	if (!device) {
-- 
1.7.7.6

