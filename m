Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38066 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbbHNKd5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 06:33:57 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.cz
Subject: [PATCH 22/23] Btrfs: move kobj stuff out of dev_replace lock range
Date: Fri, 14 Aug 2015 18:33:07 +0800
Message-Id: <1439548388-29686-23-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <bo.li.liu@oracle.com>

To avoid deadlock described in commit 084b6e7c7607 ("btrfs: Fix a lockdep warning when running xfstest."),
we should move kobj stuff out of dev_replace lock range.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 0df3d9b..c326d51 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -369,10 +369,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	WARN_ON(!tgt_device);
 	dev_replace->tgtdev = tgt_device;
 
-	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
-	if (ret)
-		btrfs_err(root->fs_info, "kobj add dev failed %d\n", ret);
-
 	printk_in_rcu(KERN_INFO
 		      "BTRFS: dev_replace from %s (devid %llu) to %s started\n",
 		      src_device->missing ? "<missing disk>" :
@@ -395,6 +391,10 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 	btrfs_dev_replace_unlock(dev_replace);
 
+	ret = btrfs_sysfs_add_device_link(tgt_device->fs_devices, tgt_device);
+	if (ret)
+		btrfs_err(root->fs_info, "kobj add dev failed %d\n", ret);
+
 	btrfs_wait_ordered_roots(root->fs_info, -1);
 
 	/* force writing the updated state information to disk */
-- 
2.4.1

