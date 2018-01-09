Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52236 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755943AbeAIORf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 09:17:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w09EGXwD151442
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:17:34 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2fcsdn1k78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 14:17:34 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w09ECXYJ017004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:33 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w09ECX7v022985
        for <linux-btrfs@vger.kernel.org>; Tue, 9 Jan 2018 14:12:33 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: make btrfs_free_stale_device() argument optional
Date: Tue,  9 Jan 2018 22:13:12 +0800
Message-Id: <20180109141314.23795-5-anand.jain@oracle.com>
In-Reply-To: <20180109141314.23795-1-anand.jain@oracle.com>
References: <20180109141314.23795-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

This updates btrfs_free_stale_device() helper function to delete all
unmouted devices, when arg is NULL.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 7b253da6c0a4..7646f8860096 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -611,9 +611,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
 
-	if (!cur_dev->name)
-		return;
-
 	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, list) {
 
 		if (fs_devs->opened)
@@ -623,9 +620,7 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 				         &fs_devs->devices, dev_list) {
 			int not_found;
 
-			if (dev == cur_dev)
-				continue;
-			if (!dev->name)
+			if (cur_dev && (cur_dev == dev || !dev->name))
 				continue;
 
 			/*
@@ -635,8 +630,11 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 			 * either use mapper or non mapper path throughout.
 			 */
 			rcu_read_lock();
-			not_found = strcmp(rcu_str_deref(dev->name),
-						rcu_str_deref(cur_dev->name));
+			if (cur_dev)
+				not_found = strcmp(rcu_str_deref(dev->name),
+						   rcu_str_deref(cur_dev->name));
+			else
+				not_found = 0;
 			rcu_read_unlock();
 			if (not_found)
 				continue;
-- 
2.7.0

