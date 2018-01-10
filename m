Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42154 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbeAJFOe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 00:14:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0A5CTf5000897
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:33 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2fd8jn0ftq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:33 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0A5EWBY016021
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:33 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0A5EW55011492
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:32 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: make btrfs_free_stale_device() argument optional
Date: Wed, 10 Jan 2018 13:15:21 +0800
Message-Id: <20180110051523.3681-5-anand.jain@oracle.com>
In-Reply-To: <20180110051523.3681-1-anand.jain@oracle.com>
References: <20180110051523.3681-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This updates btrfs_free_stale_device() helper function to delete all
unmouted devices, when arg is NULL.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index cd234a5dc763..bba98d043402 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -611,9 +611,6 @@ static void btrfs_free_stale_devices(struct btrfs_device *cur_dev)
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
 
-	if (!cur_dev->name)
-		return;
-
 	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, list) {
 
 		if (fs_devs->opened)
@@ -621,11 +618,9 @@ static void btrfs_free_stale_devices(struct btrfs_device *cur_dev)
 
 		list_for_each_entry_safe(dev, tmp_dev,
 					 &fs_devs->devices, dev_list) {
-			int not_found;
+			int not_found = 0;
 
-			if (dev == cur_dev)
-				continue;
-			if (!dev->name)
+			if (cur_dev && (cur_dev == dev || !dev->name))
 				continue;
 
 			/*
@@ -635,8 +630,9 @@ static void btrfs_free_stale_devices(struct btrfs_device *cur_dev)
 			 * either use mapper or non mapper path throughout.
 			 */
 			rcu_read_lock();
-			not_found = strcmp(rcu_str_deref(dev->name),
-						rcu_str_deref(cur_dev->name));
+			if (cur_dev)
+				not_found = strcmp(rcu_str_deref(dev->name),
+						   rcu_str_deref(cur_dev->name));
 			rcu_read_unlock();
 			if (not_found)
 				continue;
-- 
2.7.0

