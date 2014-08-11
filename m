Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49928 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaHKJkP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 05:40:15 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s7B9eDG5020459
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:14 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s7B9eB5H007701
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:12 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by userz7022.oracle.com (8.14.5+Sun/8.14.4) with ESMTP id s7B9eA5u007634
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 09:40:11 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs: preparatory to make btrfs_rm_dev_replace_srcdev() seed aware
Date: Mon, 11 Aug 2014 17:42:53 +0800
Message-Id: <1407750176-15853-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is no logical change in this patch, just a preparatory patch,
so that changes can be easily reasoned.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5f634b6..5fd0132 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1960,19 +1960,23 @@ error_undo:
 void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
 				 struct btrfs_device *srcdev)
 {
+	struct btrfs_fs_devices *fs_devices;
+
 	WARN_ON(!mutex_is_locked(&fs_info->fs_devices->device_list_mutex));
 
+	fs_devices = fs_info->fs_devices;
+
 	list_del_rcu(&srcdev->dev_list);
 	list_del_rcu(&srcdev->dev_alloc_list);
-	fs_info->fs_devices->num_devices--;
+	fs_devices->num_devices--;
 	if (srcdev->missing) {
-		fs_info->fs_devices->missing_devices--;
-		fs_info->fs_devices->rw_devices++;
+		fs_devices->missing_devices--;
+		fs_devices->rw_devices++;
 	}
 	if (srcdev->can_discard)
-		fs_info->fs_devices->num_can_discard--;
+		fs_devices->num_can_discard--;
 	if (srcdev->bdev) {
-		fs_info->fs_devices->open_devices--;
+		fs_devices->open_devices--;
 
 		/*
 		 * zero out the old super if it is not writable
-- 
2.0.0.153.g79dcccc

