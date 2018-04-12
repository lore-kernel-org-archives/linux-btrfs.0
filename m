Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54084 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752755AbeDLC1x (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 22:27:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3C2Q7Jw041843
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:52 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2h6pn4srrm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:52 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rp1Y027170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:52 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3C2Rpxl006983
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 02:27:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/15] btrfs: drop uuid_mutex in btrfs_dev_replace_finishing()
Date: Thu, 12 Apr 2018 10:29:36 +0800
Message-Id: <20180412022938.8257-14-anand.jain@oracle.com>
In-Reply-To: <20180412022938.8257-1-anand.jain@oracle.com>
References: <20180412022938.8257-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_dev_replace_finish() updates devices (soruce and target) which
are within the btrfs_fs_devices::devices or withint the cloned seed
devices (btrfs_fs_devices::seed::devices), so we don't need the global
uuid_mutex.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/dev-replace.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index ba011af9b0d2..da937eb064aa 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -621,7 +621,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	ret = btrfs_commit_transaction(trans);
 	WARN_ON(ret);
 
-	mutex_lock(&uuid_mutex);
 	/* keep away write_all_supers() during the finishing procedure */
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	mutex_lock(&fs_info->chunk_mutex);
@@ -648,7 +647,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 		btrfs_dev_replace_write_unlock(dev_replace);
 		mutex_unlock(&fs_info->chunk_mutex);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		mutex_unlock(&uuid_mutex);
 		btrfs_rm_dev_replace_blocked(fs_info);
 		if (tgt_device)
 			btrfs_destroy_dev_replace_tgtdev(fs_info, tgt_device);
@@ -699,7 +697,6 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 	 */
 	mutex_unlock(&fs_info->chunk_mutex);
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-	mutex_unlock(&uuid_mutex);
 
 	/* replace the sysfs entry */
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, src_device);
-- 
2.7.0

