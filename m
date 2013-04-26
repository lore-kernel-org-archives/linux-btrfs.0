Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab3DZPU2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 11:20:28 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 187005E000202
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 17:20:27 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs: read entire device info under lock
Date: Fri, 26 Apr 2013 17:20:23 +0200
Message-Id: <1366989623-18876-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's a theoretical possibility of reading stale (or even more
theoretically, freed) data from DEV_INFO ioctl when the device would
disappear between an early mutex unlock and data being copied from the
device structure.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5e93bb8..0b48641 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2432,7 +2432,6 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 
 	mutex_lock(&fs_devices->device_list_mutex);
 	dev = btrfs_find_device(root->fs_info, di_args->devid, s_uuid, NULL);
-	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (!dev) {
 		ret = -ENODEV;
@@ -2456,6 +2455,7 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 	}
 
 out:
+	mutex_unlock(&fs_devices->device_list_mutex);
 	if (ret == 0 && copy_to_user(arg, di_args, sizeof(*di_args)))
 		ret = -EFAULT;
 
-- 
1.7.9

