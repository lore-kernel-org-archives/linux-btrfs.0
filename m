Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:55786 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753725AbeGIIao (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2018 04:30:44 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w698SQY3052482
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Jul 2018 08:30:43 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2k2p75k3d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2018 08:30:43 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w698UgLl004103
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Jul 2018 08:30:42 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w698UgMB006268
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Jul 2018 08:30:42 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: use fs_devices instead of the dereference
Date: Mon,  9 Jul 2018 16:33:53 +0800
Message-Id: <20180709083353.14517-2-anand.jain@oracle.com>
In-Reply-To: <20180709083353.14517-1-anand.jain@oracle.com>
References: <20180709083353.14517-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have assigned the %fs_info->fs_devices in %fs_devices as its not
modified just use it for the mutex_lock().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0e92969b1adc..781c79a2ff7a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2297,7 +2297,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	INIT_LIST_HEAD(&seed_devices->alloc_list);
 	mutex_init(&seed_devices->device_list_mutex);
 
-	mutex_lock(&fs_info->fs_devices->device_list_mutex);
+	mutex_lock(&fs_devices->device_list_mutex);
 	list_splice_init_rcu(&fs_devices->devices, &seed_devices->devices,
 			      synchronize_rcu);
 	list_for_each_entry(device, &seed_devices->devices, dev_list)
@@ -2317,7 +2317,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	generate_random_uuid(fs_devices->fsid);
 	memcpy(fs_info->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
-	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
+	mutex_unlock(&fs_devices->device_list_mutex);
 
 	super_flags = btrfs_super_flags(disk_super) &
 		      ~BTRFS_SUPER_FLAG_SEEDING;
-- 
2.7.0

