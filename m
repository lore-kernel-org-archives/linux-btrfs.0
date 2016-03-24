Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40607 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbcCXKsb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 06:48:31 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/3] btrfs: keep sysfs target add in the last
Date: Thu, 24 Mar 2016 18:48:13 +0800
Message-Id: <1458816494-483-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1458816494-483-1-git-send-email-anand.jain@oracle.com>
References: <1458816494-483-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sysfs create context should come in the last, so that we
don't have to undo sysfs operation for the reason that any
other operation has failed.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index d38cad37ba27..025f42ef5ab3 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -397,10 +397,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 	btrfs_dev_replace_unlock(dev_replace, 1);
 
-	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
-	if (ret)
-		btrfs_err(fs_info, "kobj add dev failed %d\n", ret);
-
 	btrfs_wait_ordered_roots(fs_info, -1);
 
 	/* force writing the updated state information to disk */
@@ -428,6 +424,9 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 		WARN_ON(ret);
 	}
 
+	if (btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device))
+		btrfs_err(fs_info, "kobj add dev failed during replace\n");
+
 	return ret;
 
 leave:
-- 
2.7.0

