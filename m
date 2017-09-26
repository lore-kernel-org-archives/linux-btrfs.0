Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17918 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936977AbdIZIdx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 04:33:53 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 1/2] btrfs: undo writable when sprouting fails
Date: Tue, 26 Sep 2017 16:41:34 +0800
Message-Id: <20170926084135.3189-2-anand.jain@oracle.com>
In-Reply-To: <20170926084135.3189-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170926084135.3189-1-anand.jain@oracle.com>

When new device is being added to seed FS, seed FS is marked writable,
but when we fail to bring in the new device, we missed to undo the
writable part. This patch fixes it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e8f16c305df..9d64700cc9b6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2501,6 +2501,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 	return ret;
 
 error_trans:
+	if (seeding_dev)
+		sb->s_flags |= MS_RDONLY;
 	btrfs_end_transaction(trans);
 	rcu_string_free(device->name);
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, device);
-- 
2.13.1

