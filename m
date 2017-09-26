Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24855 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966936AbdIZHlE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 03:41:04 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 3/3] btrfs: fix BUG_ON in btrfs_init_new_device()
Date: Tue, 26 Sep 2017 15:48:43 +0800
Message-Id: <20170926074843.31910-4-anand.jain@oracle.com>
In-Reply-To: <20170926074843.31910-1-anand.jain@oracle.com>
References: <20170925123104.16526-1-anand.jain@oracle.com>
 <20170926074843.31910-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of BUG_ON return error to the caller. And handle the fail
condition by calling the abort transaction through the error path.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: do not consolidate btrfs_abort_transaction()
 fs/btrfs/volumes.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 22eb81794375..4cb575fbf643 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2399,7 +2399,10 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	if (seeding_dev) {
 		sb->s_flags &= ~MS_RDONLY;
 		ret = btrfs_prepare_sprout(fs_info);
-		BUG_ON(ret); /* -ENOMEM */
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
+			goto error_trans;
+		}
 	}
 
 	device->fs_devices = fs_info->fs_devices;
@@ -2502,6 +2505,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 
 error_sysfs:
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
+error_trans:
 	if (seeding_dev)
 		sb->s_flags |= MS_RDONLY;
 	btrfs_end_transaction(trans);
-- 
2.13.1

