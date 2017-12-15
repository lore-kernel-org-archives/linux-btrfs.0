Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57182 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754824AbdLODyk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 22:54:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBF3rAUa186365
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:54:39 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2ev6fp025j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:54:39 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBF3lCo8031614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:13 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBF3lCVM005336
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Dec 2017 03:47:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: make btrfs_free_stale_device() argument optional
Date: Fri, 15 Dec 2017 11:47:37 +0800
Message-Id: <20171215034739.26090-5-anand.jain@oracle.com>
In-Reply-To: <20171215034739.26090-1-anand.jain@oracle.com>
References: <20171215034739.26090-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This updates btrfs_free_stale_device() helper function to delete all
unmouted devices, when arg is NULL.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 70db6a1d5658..9aee4f987221 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -613,9 +613,6 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
 
-	if (!cur_dev->name)
-		return;
-
 	list_for_each_entry_safe(fs_devs, tmp_fs_devs, &fs_uuids, list) {
 
 		if (fs_devs->opened)
@@ -625,9 +622,7 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
 				         &fs_devs->devices, dev_list) {
 			int not_found;
 
-			if (dev == cur_dev)
-				continue;
-			if (!dev->name)
+			if (cur_dev && (cur_dev == dev || !dev->name))
 				continue;
 
 			/*
@@ -637,8 +632,11 @@ static void btrfs_free_stale_device(struct btrfs_device *cur_dev)
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

