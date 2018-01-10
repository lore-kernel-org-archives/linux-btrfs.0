Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51036 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752664AbeAJFRG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Jan 2018 00:17:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0A5H58r009785
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:17:05 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2fd8bdrhej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:17:04 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w0A5EY2i032661
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:34 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w0A5EYhL001395
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jan 2018 05:14:34 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] btrfs: rename btrfs_free_stale_devices() arg to skip_dev
Date: Wed, 10 Jan 2018 13:15:22 +0800
Message-Id: <20180110051523.3681-6-anand.jain@oracle.com>
In-Reply-To: <20180110051523.3681-1-anand.jain@oracle.com>
References: <20180110051523.3681-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No functional changes.
Rename btrfs_free_stale_devices() arg to skip_dev, so that it
reflects what that arg for.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bba98d043402..a3edd4d92c57 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -606,7 +606,7 @@ static void pending_bios_fn(struct btrfs_work *work)
 }
 
 
-static void btrfs_free_stale_devices(struct btrfs_device *cur_dev)
+static void btrfs_free_stale_devices(struct btrfs_device *skip_dev)
 {
 	struct btrfs_fs_devices *fs_devs, *tmp_fs_devs;
 	struct btrfs_device *dev, *tmp_dev;
@@ -620,7 +620,7 @@ static void btrfs_free_stale_devices(struct btrfs_device *cur_dev)
 					 &fs_devs->devices, dev_list) {
 			int not_found = 0;
 
-			if (cur_dev && (cur_dev == dev || !dev->name))
+			if (skip_dev && (skip_dev == dev || !dev->name))
 				continue;
 
 			/*
@@ -630,9 +630,9 @@ static void btrfs_free_stale_devices(struct btrfs_device *cur_dev)
 			 * either use mapper or non mapper path throughout.
 			 */
 			rcu_read_lock();
-			if (cur_dev)
+			if (skip_dev)
 				not_found = strcmp(rcu_str_deref(dev->name),
-						   rcu_str_deref(cur_dev->name));
+						   rcu_str_deref(skip_dev->name));
 			rcu_read_unlock();
 			if (not_found)
 				continue;
-- 
2.7.0

