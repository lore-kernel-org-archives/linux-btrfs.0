Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40610 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754917AbdLOD5N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 22:57:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF3vCwW113416
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:57:12 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2ev6wq004b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:57:12 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3lBxl022055
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:11 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3lBDl021870
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:11 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: make btrfs_free_stale_device() to iterate all stales
Date: Fri, 15 Dec 2017 11:47:36 +0800
Message-Id: <20171215034739.26090-4-anand.jain@oracle.com>
In-Reply-To: <20171215034739.26090-1-anand.jain@oracle.com>
References: <20171215034739.26090-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Let the list iterator iterate further and find other stale
devices and delete it. This is in preparation to add support
for user land request-able stale devices cleanup.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e89409112d5..70db6a1d5658 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -610,19 +610,20 @@ static void pending_bios_fn(struct btrfs_work *work)
 
 static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 {
-	struct btrfs_fs_devices *fs_devs;
-	struct btrfs_device *dev;
+	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
+	struct btrfs_device *dev, *tmp_dev;
 
 	if (!cur_dev->name)
 		return;
 
-	list_for_each_entry(fs_devs, &fs_uuids, list) {
-		int del = 1;
+	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, list) {
 
 		if (fs_devs->opened)
 			continue;
 
-		list_for_each_entry(dev, &fs_devs->devices, dev_list) {
+		list_for_each_entry_safe(dev, tmp_dev,
+				         &fs_devs->devices, dev_list) {
+			int not_found;
 
 			if (dev == cur_dev)
 				continue;
@@ -636,14 +637,12 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 			 * either use mapper or non mapper path throughout.
 			 */
 			rcu_read_lock();
-			del = strcmp(rcu_str_deref(dev->name),
+			not_found = strcmp(rcu_str_deref(dev->name),
 						rcu_str_deref(cur_dev->name));
 			rcu_read_unlock();
-			if (!del)
-				break;
-		}
+			if (not_found)
+				continue;
 
-		if (!del) {
 			/* delete the stale device */
 			if (fs_devs->num_devices == 1) {
 				btrfs_sysfs_remove_fsid(fs_devs);
@@ -654,7 +653,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 				list_del(&dev->dev_list);
 				free_device(dev);
 			}
-			break;
 		}
 	}
 }
-- 
2.7.0

