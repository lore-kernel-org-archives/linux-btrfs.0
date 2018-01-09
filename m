Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36578 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752694AbeAIOWe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:22:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09EMNhv153578
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:22:34 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fcpfyt4vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:22:34 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w09ECWoO016972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:32 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w09ECWGY006797
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: make btrfs_free_stale_device() to iterate all stales
Date: Tue,  9 Jan 2018 22:13:11 +0800
Message-Id: <20180109141314.23795-4-anand.jain@oracle.com>
In-Reply-To: <20180109141314.23795-1-anand.jain@oracle.com>
References: <20180109141314.23795-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Let the list iterator iterate further and find other stale
devices and delete it. This is in preparation to add support
for user land request-able stale devices cleanup.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ab6ccad08ef7..7b253da6c0a4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -608,19 +608,20 @@ static void pending_bios_fn(struct btrfs_work *work)
 
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
@@ -634,14 +635,12 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
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
@@ -652,7 +651,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 				list_del(&dev->dev_list);
 				free_device(dev);
 			}
-			break;
 		}
 	}
 }
-- 
2.7.0

