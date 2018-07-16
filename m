Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55964 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730008AbeGPPWs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 11:22:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6GEriNv058628
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:00 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2k7a3svtc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:55:00 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6GEsx6l007603
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:59 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6GEswMf025602
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Jul 2018 14:54:58 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] btrfs: use the assigned fs_devices instead of the dereference
Date: Mon, 16 Jul 2018 22:58:09 +0800
Message-Id: <20180716145812.20836-5-anand.jain@oracle.com>
In-Reply-To: <20180716145812.20836-1-anand.jain@oracle.com>
References: <20180716145812.20836-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have assigned the %fs_info->fs_devices in %fs_devices as its not
modified just use it for the mutex_lock().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
I don't see this in the ML at all, I remember sending this. Anyway
I am marking this as V1.

 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c6f3f0dfbabe..7f4973fc2b52 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2199,7 +2199,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	INIT_LIST_HEAD(&seed_devices->alloc_list);
 	mutex_init(&seed_devices->device_list_mutex);
 
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	mutex_lock(&fs_devices->device_list_mutex);
 	list_splice_init_rcu(&fs_devices->devices, &seed_devices->devices,
 			      synchronize_rcu);
 	list_for_each_entry(device, &seed_devices->devices, dev_list)
@@ -2219,7 +2219,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	generate_random_uuid(fs_devices->fsid);
 	memcpy(fs_info->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
 
 	super_flags = btrfs_super_flags(disk_super) &
 		      ~BTRFS_SUPER_FLAG_SEEDING;
-- 
2.7.0

