Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32654 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755967AbaGPKhA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 06:37:00 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6GAavGZ026187
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Jul 2014 18:36:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: fix wrong total device counter after removing a seed device
Date: Wed, 16 Jul 2014 18:38:37 +0800
Message-ID: <1405507117-8880-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The total device counters of all the descendant filesystem account the seed
device, so after removing a seed device, we need decrease all those counters.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4cfbe76..184e1c4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1715,12 +1715,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	 * (super_copy) should hold the device list mutex.
 	 */
 
-	cur_devices = device->fs_devices;
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	list_del_rcu(&device->dev_list);
 
 	device->fs_devices->num_devices--;
-	device->fs_devices->total_devices--;
+
+	cur_devices = root->fs_info->fs_devices;
+	do {
+		cur_devices->total_devices--;
+		cur_devices = cur_devices->seed;
+	} while (device->fs_devices != cur_devices);
 
 	if (device->missing)
 		device->fs_devices->missing_devices--;
@@ -1738,12 +1742,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	/* remove sysfs entry */
 	btrfs_kobj_rm_device(root->fs_info, device);
 
-	call_rcu(&device->rcu, free_device);
-
 	num_devices = btrfs_super_num_devices(root->fs_info->super_copy) - 1;
 	btrfs_set_super_num_devices(root->fs_info->super_copy, num_devices);
 	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 
+	call_rcu(&device->rcu, free_device);
+
 	if (cur_devices->open_devices == 0) {
 		struct btrfs_fs_devices *fs_devices;
 		fs_devices = root->fs_info->fs_devices;
-- 
1.9.3

