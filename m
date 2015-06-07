Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43707 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbbFGLIB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Jun 2015 07:08:01 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] Btrfs: sysfs support for the replace of the seed device
Date: Sun,  7 Jun 2015 17:44:32 +0800
Message-Id: <1433670272-1563-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1433670272-1563-1-git-send-email-anand.jain@oracle.com>
References: <1433670272-1563-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Earlier as reported "replace seed/sprout hangs (regression ?)"
and since now I don't see that regression, was able to test
this scenario. And thus added the support in the sysfs.

Test case
 mount seed device
 add sprout
 replace seed device
 (so now sprout fs is independent of seed fs)
 The sysfs layout should change accordingly.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index a6a2b84..5a6f732 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -585,7 +585,11 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 
 	/* replace the sysfs entry */
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, src_device, 0);
-	btrfs_sysfs_rm_device_attr(src_device);
+	if (src_device->fs_devices->seeding &&
+			!src_device->fs_devices->num_devices)
+		btrfs_sysfs_remove_fsid(src_device->fs_devices);
+	else
+		btrfs_sysfs_rm_device_attr(src_device);
 	btrfs_rm_dev_replace_free_srcdev(fs_info, src_device);
 
 	/* write back the superblocks */
-- 
2.4.1

