Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21926 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaBEMre (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 07:47:34 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s15ClX2Z012448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 12:47:34 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s15ClXRY018035
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 12:47:33 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s15ClWQc028049
	for <linux-btrfs@vger.kernel.org>; Wed, 5 Feb 2014 12:47:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: looping across fs_devices isn't necessary
Date: Wed,  5 Feb 2014 20:57:32 +0800
Message-Id: <1391605052-15198-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_show_devname() is trying to know dev name with
lowest devid for a given FSID, so looping across the
FSID isn't necessary

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/super.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 378157c..6ed76d8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1885,22 +1885,18 @@ static int btrfs_unfreeze(struct super_block *sb)
 static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(root->d_sb);
-	struct btrfs_fs_devices *cur_devices;
 	struct btrfs_device *dev, *first_dev = NULL;
 	struct list_head *head;
 	struct rcu_string *name;
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
-	cur_devices = fs_info->fs_devices;
-	while (cur_devices) {
-		head = &cur_devices->devices;
-		list_for_each_entry(dev, head, dev_list) {
-			if (dev->missing)
-				continue;
-			if (!first_dev || dev->devid < first_dev->devid)
-				first_dev = dev;
-		}
-		cur_devices = cur_devices->seed;
+
+	head = &fs_info->fs_devices->devices;
+	list_for_each_entry(dev, head, dev_list) {
+		if (dev->missing)
+			continue;
+		if (!first_dev || dev->devid < first_dev->devid)
+			first_dev = dev;
 	}
 
 	if (first_dev) {
-- 
1.7.1

