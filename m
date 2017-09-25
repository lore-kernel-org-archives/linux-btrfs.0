Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23916 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934450AbdIYMXa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 08:23:30 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 3/3] btrfs: fix BUG_ON in btrfs_init_new_device()
Date: Mon, 25 Sep 2017 20:31:04 +0800
Message-Id: <20170925123104.16526-4-anand.jain@oracle.com>
In-Reply-To: <20170925123104.16526-1-anand.jain@oracle.com>
References: <20170925123104.16526-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here we will simply return the error to the caller. And handle the
fail condition by calling the abort transaction through the error
path.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5c34eea9d12d..93eaf314fe72 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2399,7 +2399,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
 		ret = btrfs_prepare_sprout(fs_info);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret)
+			goto error_trans;
 	}
 
 	device->fs_devices = fs_info->fs_devices;
@@ -2496,6 +2497,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 error_sysfs:
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
+error_trans:
 	if (seeding_dev)
 		sb->s_flags |= MS_RDONLY;
 	btrfs_abort_transaction(trans, ret);
-- 
2.13.1

