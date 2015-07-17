Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30629 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946060AbbGQItw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jul 2015 04:49:52 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t6H8nqsj031797
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 08:49:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t6H8npgH023198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 08:49:51 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t6H8ngrr004039
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jul 2015 08:49:51 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: move kobj stuff out of dev_replace lock range
Date: Fri, 17 Jul 2015 16:49:18 +0800
Message-Id: <1437122959-23376-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To avoid deadlock described in commit 084b6e7c7607 ("btrfs: Fix a lockdep warning when running xfstest."),
we should move kobj stuff out of dev_replace lock range.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/dev-replace.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 862fbc2..9eb1401 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -376,10 +376,6 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	WARN_ON(!tgt_device);
 	dev_replace->tgtdev = tgt_device;
 
-	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
-	if (ret)
-		btrfs_error(root->fs_info, ret, "kobj add dev failed");
-
 	printk_in_rcu(KERN_INFO
 		      "BTRFS: dev_replace from %s (devid %llu) to %s started\n",
 		      src_device->missing ? "<missing disk>" :
@@ -402,6 +398,10 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
 	args->result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
 	btrfs_dev_replace_unlock(dev_replace);
 
+	ret = btrfs_kobj_add_device(tgt_device->fs_devices, tgt_device);
+	if (ret)
+		btrfs_error(root->fs_info, ret, "kobj add dev failed");
+
 	btrfs_wait_ordered_roots(root->fs_info, -1);
 
 	/* force writing the updated state information to disk */
-- 
2.1.0

