Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53064 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbeEVJ1B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 05:27:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4M9Kkux009129
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 09:26:59 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2j2bcdfnse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 09:26:59 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w4M9QwML013862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 09:26:58 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4M9Qvwo016203
        for <linux-btrfs@vger.kernel.org>; Tue, 22 May 2018 09:26:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: drop uuid_mutex in btrfs_free_extra_devids()
Date: Tue, 22 May 2018 17:29:29 +0800
Message-Id: <20180522092929.12014-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_free_extra_devids() frees the orphan fsid::devid with in
btrfs_fs_devices::devices, so we dont need uuid_mutex, instead hold the
btrfs_fs_devices::device_list_mutex.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v1->v2: replace uuid_mutex with device_list_mutex instead of delete.
	change log updated.

 fs/btrfs/volumes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2b101dc49d91..b1e5ac419ca8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -925,7 +925,7 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 	struct btrfs_device *device, *next;
 	struct btrfs_device *latest_dev = NULL;
 
-	mutex_lock(&uuid_mutex);
+	mutex_lock(&fs_devices->device_list_mutex);
 again:
 	/* This is the initialized path, it is safe to release the devices. */
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
@@ -979,8 +979,7 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 	}
 
 	fs_devices->latest_bdev = latest_dev->bdev;
-
-	mutex_unlock(&uuid_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
 }
 
 static void free_device_rcu(struct rcu_head *head)
-- 
2.7.0

