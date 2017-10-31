Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52869 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932447AbdJaRqm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 13:46:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 17F70ABF4
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:46:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 09/11] btrfs: switch to RCU for device traversal in btrfs_ioctl_dev_info
Date: Tue, 31 Oct 2017 18:44:51 +0100
Message-Id: <7beca6a0dc9c7406423690bde6b659235e695bde.1509471604.git.dsterba@suse.com>
In-Reply-To: <cover.1509471604.git.dsterba@suse.com>
References: <cover.1509471604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We don't need to use the mutex as we do not modify the devices nor the
list itself and just read some information:

does not change during device lifetime:
- devid
- uuid
- name (ie. the path)

may change in parallel to the ioctl call, but can lead only to reporting
inacurracy:
- bytes_used
- total_bytes

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fd172a93d11a..f0a3308a72c5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2779,7 +2779,6 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_ioctl_dev_info_args *di_args;
 	struct btrfs_device *dev;
-	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	int ret = 0;
 	char *s_uuid = NULL;
 
@@ -2790,7 +2789,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	if (!btrfs_is_empty_uuid(di_args->uuid))
 		s_uuid = di_args->uuid;
 
-	mutex_lock(&fs_devices->device_list_mutex);
+	rcu_read_lock();
 	dev = btrfs_find_device(fs_info, di_args->devid, s_uuid, NULL);
 
 	if (!dev) {
@@ -2805,17 +2804,15 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	if (dev->name) {
 		struct rcu_string *name;
 
-		rcu_read_lock();
 		name = rcu_dereference(dev->name);
 		strncpy(di_args->path, name->str, sizeof(di_args->path));
-		rcu_read_unlock();
 		di_args->path[sizeof(di_args->path) - 1] = 0;
 	} else {
 		di_args->path[0] = '\0';
 	}
 
 out:
-	mutex_unlock(&fs_devices->device_list_mutex);
+	rcu_read_unlock();
 	if (ret == 0 && copy_to_user(arg, di_args, sizeof(*di_args)))
 		ret = -EFAULT;
 
-- 
2.14.0

